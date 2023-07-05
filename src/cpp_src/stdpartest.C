#include <algorithm>
#include <cassert>
#include <chrono>
#include <iostream>
#include <limits>
#include <string>
#include <vector>
#include <ranges>
#include <execution>
#include <random>
#include <array>
#include <numeric>
//#include <cartesian_product.hpp> 
//#include <numeric>   // used with std::transform_reduce
//#include <future>

//TODO: make and test the homegrown copy_if that uses atomics as
// alternative to std::copy_if

using namespace std;
using namespace std::chrono;


constexpr size_t NX{100000};
constexpr int MAX_NN{100};
constexpr int MAX_NNP{MAX_NN+1};
constexpr int MAX_INT{std::numeric_limits<int>::max()};
constexpr float max_distance {2.25};

bool is_near(float x, float y){
    if ((sqrt((y-x)*(y-x)) <= max_distance) && 
    (cos(y-x)*cos(y-x)  + sin(y-x)* sin(y-x) <= 2.0)){
        return true;
    }else{
        return false;
    }
}



void initialize_data(vector<float> &x, vector<float> &y) {
    std::random_device  rd;
    std::mt19937        gen(rd());
    std::uniform_real_distribution dis(-0.25, 0.25);
     
    auto ints = std::views::iota((size_t)0, x.size());
    cout <<"calling for each n"<< endl;
    std::for_each_n(std::execution::seq, ints.begin(), x.size(),  [x = x.data(), y=y.data()](int i) {
      x[i] = (double)i;
      if ((i % 2) == 0) {
        y[i] = MAX_INT; // some large number
      } else {
        y[i] = (double)i;// + dis(gen);
      }
    });
  }


void initialize_results_arrays(vector<float> &x, vector<array<int,MAX_NNP>>& y_n_x  ) {
    y_n_x.reserve(x.size());
     for (int i = 0; i < x.size() ; i++){
        for (int j = 0; j < MAX_NN; j++){
          y_n_x[i][j] = MAX_NN;
        }
        y_n_x[i][MAX_NN] = 0;
    }
  }

void initialize_results_vec(vector<float> &x,  vector<vector<int>>& y_near_x  ) {
    y_near_x.reserve(x.size());
    for (auto i = 0; i < x.size() ; i++){
        y_near_x[i].reserve(MAX_NN);
        for (auto j = 0; j < MAX_NN; j++){
          y_near_x[i][j] = MAX_NNP;
        }
    }
}

void print_results (vector<vector<int>>& y_near_x){
for (auto i = 0;  i < y_near_x.size(); i++){
     for(auto j = 0; j<y_near_x[i].size(); j++)
       cout << "i , j, y_near_x : " << i <<", " << j <<", " << y_near_x[i][j] <<endl;
    }
}

void compare_results(vector<vector<int>> &r1, vector<vector<int>> &r2) {
    auto nof_errors{0};
    if (r1.size() != r2.size()) {
     cout << "Error r1.size() != r2.size()" << endl;
     return;
    }

    for (auto i{0}; i < r1.size(); i++) {
     std::sort(r1[i].begin(), r1[i].end());
     std::sort(r2[i].begin(), r2[i].end());
     if (r1[i] != r2[i]){
       cout << "Error r1[i] != r2[i] ffor i=" << i << endl;
        nof_errors++;
    }
    }

    cout << "compare_results found " << nof_errors << " discrepancies." << endl;
}

void search_serial(vector<float> &x, vector<float> &y, vector<vector<int>> &y_near_x) {
    auto ints = std::views::iota(0, (int)x.size());
    auto NY = y.size();
    std::for_each_n(
        std::execution::seq,
        ints.begin(), x.size(),
        [&, x = x.data(), y = y.data()](int i) {
          for (auto j{0}; j < NY; ++j) {
            if (is_near(x[i], y[j])) {
              y_near_x[i].push_back(j);
            }
          }
        });
  }

void search_copy_if(vector<float> &x, vector<float> &y, vector<vector<int>> &y_near_x) {
  auto ints = std::views::iota(0, (int)y.size());  // NOTE: its y.size(); and assuming reuse in loop for i (x)
  for (int i = 0; i < x.size(); i++) {
    auto nn_iter =  y_near_x[i].begin();
     std::copy_if(
         std::execution::par,
         // NOTE: nvc++ w/ GPU requires random_access iterators for 3rd (result) arg.
         ints.begin(), ints.end(), nn_iter,
         [=, x = x.data(), y = y.data()](int j) {
           if (is_near(x[i], y[j])) {
             return true;
           } else {
             return false;
           }
         });
  }
}

void search_for_each(vector<float> &x, vector<float> &y, vector<array<int,MAX_NNP>>& y_near_x) {
  assert(1 == 0); //TODO: unfinished - do not use. Alternative to copy_if?
  auto ints = std::views::iota(0, (int)x.size());
  auto NY = y.size();
  std::for_each_n(std::execution::par_unseq, 
    ints.begin(), x.size(), [&, x = x.data(), y = y.data()](int i) {
        for(int j{0}; j< NY ; ++j){
         if(is_near(x[i], y[j])){ 
            //TODO: lock needed
            assert(y_near_x[i][MAX_NN] < MAX_NN);
            y_near_x[i][ y_near_x[i][MAX_NN] ] = j;
            ++y_near_x[i][MAX_NN];
        
          }
        }
     });
}


int main(int argc, char *argv[]) {
  vector<float> x(NX, 0.), y(NX, 0.);  // allocation of same size and init
  vector<vector<int>> y_near_x_r1, y_near_x_r2;
  vector<array<int, MAX_NNP>> y_n_x;
  initialize_data(x, y);
  initialize_results_vec(x, y_near_x_r1);
  initialize_results_vec(x, y_near_x_r2);
  initialize_results_arrays(x, y_n_x);

  cout << endl << "Calling search_serial" << endl;
  auto start =  high_resolution_clock::now();
  search_serial(x, y, y_near_x_r1);
  auto stop =  high_resolution_clock::now();
  auto duration = duration_cast<microseconds>(stop - start);
  cout << "serial search time: "
       << duration.count() / 1.0e6 << " seconds" << endl;
  //print_results(y_near_x_r1);

  cout << "Calling search_copy_if" << endl;
  start =  high_resolution_clock::now();
  search_copy_if(x, y, y_near_x_r2);
  stop =  high_resolution_clock::now();
  duration = duration_cast<microseconds>(stop - start);
  cout << "paralle search time: "
    << duration.count() / 1.0e6 << " seconds" << endl;
  //print_results(y_near_x_r2);

  compare_results(y_near_x_r1, y_near_x_r2);
}



