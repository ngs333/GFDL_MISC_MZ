#include <algorithm>
#include <cassert>
#include <chrono>
#include <iostream>
#include <limits>
#include <string>
#include <vector>
//#include <cartesian_product.hpp> // Brings C++23 std::views::cartesian_product to C++20
#include <numeric>   // For std::transform_reduce
#include <ranges>
#include <execution>
#include <random>


using namespace std;

bool is_near(float x, float y){
    if (sqrt((y-x)*(y-x)) <= 0.25){
        return true;
    }else{
        return false;
    }
}

void initialize(vector<float> &x, vector<float> &y, vector<vector<size_t>>& y_near_x, const size_t nx, const size_t maxy) {
    std::random_device  rd;
    std::mt19937        gen(rd());
    std::uniform_real_distribution dis(-0.25, 0.25);

    y_near_x.reserve(nx);
    for (int i = 0; i < nx; i++) {
      vector<size_t> vt;
      vt.reserve(maxy);

      for(int j = 0; j<maxy; j++){
        vt[j] = nx+1;
      }
      y_near_x.push_back(vt);
    }

    y.reserve(nx);
    x.reserve(nx);

    auto ints = std::views::iota(0);//TODO: cast?
    std::for_each_n(std::execution::par, ints.begin(), x.size(), 
    [x = x.data(), y=y.data()](int i) {
      x[i] = (double)i;
      if ((i % 2) == 0) {
        y[i] = 0;
      } else {
        y[i] = (double)i;// + dis(gen);
      }
    });
    // std::fill_n
  }


void search(vector<float> &x, vector<float> &y, vector<vector<size_t>>& y_near_x) {
  auto ints = std::views::iota(0, (int)x.size());
  
  std::for_each_n(std::execution::par, 
    ints.begin(), x.size(), [&](int i) {
        for(int j{0}; j< y.size(); ++j){
         if(is_near(x[i], y[j])){ 
            //y_near_x[i].push_back(j);
            //y_near_x[i].emplace_back(j);
            assert(y_near_x[i].size() < y_near_x[i].capacity());
            y_near_x[i][y_near_x[i].size()] = j;

          }
        }
     });
  }


int main(int argc, char *argv[]) {
  const size_t NX{100};
  const size_t MY{10};
    vector<float> x,y;
    vector<vector<size_t>> y_near_x;
    vector<array<int,10>> y_n_x;
    initialize(x,y,y_near_x,NX,MY);
    search(x,y,y_near_x);

}
