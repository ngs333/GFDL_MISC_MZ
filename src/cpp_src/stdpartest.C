#include <algorithm>
#include <cassert>
#include <chrono>
#include <iostream>
#include <limits>
#include <string>
#include <vector>
#include <execution>
#include <random>
#include <array>
#include <ranges>
//#include <future>
//#include <numeric>  // used with std::transform_reduce

// std::format comes in C++23
// std::views::cartesian_product comes in C++23
#if __cplusplus <= 202002L

#include "include/format"
#include "cartesian_product.hpp"

#endif

using namespace std;
using namespace std::chrono;

constexpr size_t NX{100000};
constexpr int MAX_NN{20};
constexpr int MAX_NNP{MAX_NN + 1};
constexpr int FILL_VALUE_INT{std::numeric_limits<int>::max()};
constexpr float MAX_DISTANCE{1.25};

bool is_near(float x, float y) { //easily made faster; but need it slow for tests.
  return (sqrt((y - x) * (y - x)) <= MAX_DISTANCE);
}

/*
 * init_ids  is a temporary and poor (O(N^2) storage) alternative to tuples
 * generation and access vs std::ranges cartesian_product, but used in
 * one configuration because of nvc++ 23.5 failure with
 * cartesian_product.
 */
std::vector<std::tuple<unsigned int, unsigned int>>
init_ids(size_t nx, size_t ny) {
  vector<std::tuple<unsigned int, unsigned int>> ids;
  ids.reserve(nx * ny);
  for (unsigned int j = 0; j < ny; j++) {
    for (unsigned i = 0; i < nx; i++) {
      ids.emplace_back(std::tuple{i, j});
    }
  }
  return ids;
}

void initialize_data(vector<float> &x, vector<float> &y) {
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_real_distribution dis(-0.25, 0.25);
  auto ids = std::views::iota((size_t) 0, x.size());
  cout << "calling for each n" << endl;
  std::for_each_n(std::execution::seq, ids.begin(), x.size(), [x = x.data(), y = y.data()](int i) {
    x[i] = (double) i;
    if ((i % 2) == 0) {
      y[i] = (double) i; // some large number
    } else {
      y[i] = (double) i;// + dis(gen);
    }
  });
}

void initialize_results_arrays(vector<float> &x, vector<array<int, MAX_NNP>> &y_n_x) {
  y_n_x.reserve(x.size());
  for (size_t i = 0; i < x.size(); i++) {
    for (size_t j = 0; j < MAX_NN; j++) {
      y_n_x[i][j] = FILL_VALUE_INT;
              ;
    }
    y_n_x[i][MAX_NN] = 0;
  }
}

void initialize_results_vec(vector<float> &x, vector<vector<int>> &y_near_x) {
  y_near_x.reserve(x.size());
  for (size_t i{0}; i < x.size(); i++) {
    y_near_x.push_back(vector<int>());
  }
}

//for fixed size results vector;
void initialize_results_vec_fill(vector<float> &x, vector<vector<int>> &y_near_x) {
  y_near_x.reserve(x.size());
  for (size_t i{0}; i < x.size(); i++) {
    y_near_x.push_back(vector<int>());
    y_near_x[i].reserve(MAX_NN);
    for (size_t j{0}; j < MAX_NN; j++) {
      y_near_x[i].push_back(FILL_VALUE_INT);
    }
  }
}

void print_results(vector<vector<int>> &y_near_x) {
  for (size_t i{0}; i < y_near_x.size(); i++) {
    for (size_t j{0}; j < y_near_x[i].size(); j++)
      cout << std::format("i , j, y_near_x : {} , {}, {},", i, j, y_near_x[i][j]) << endl;
  }
}

void compare_results(vector<vector<int>> &r1, vector<vector<int>> &r2) {
  auto nof_errors{0};
  if (r1.size() != r2.size()) {
    cout << std::format("Error r1.size() != r2.size(); r1.size= {} r2.size= {}",
                        r1.size(), r2.size()) << endl;
    return;
  }
  if (r1.size() == 0) {
    cout << "Error r1.size is 0" << endl;
    nof_errors++;
  }

  for (size_t i{0}; i < r1.size(); i++) {
    std::sort(r1[i].begin(), r1[i].end());
    std::sort(r2[i].begin(), r2[i].end());
    if (r1[i] != r2[i] || r1[i].size() == 0) {
      std::ostringstream oss1, oss2;
      for (const auto &e: r1[i]) oss1 << e << " ";
      for (const auto &e: r2[i]) oss2 << e << " ";
      cout << std::format("Error r1[i] != r2[i] ?: i: {} \n r1[i]: {}\n r2[i]: {} \n ",
                          i, oss1.str(), oss2.str()) << endl;
      nof_errors++;
    }
  }
  cout << "compare_results found " << nof_errors << " discrepancies." << endl;
}

void search_serial(vector<float> &x, vector<float> &y, vector<vector<int>> &y_near_x) {
  auto ids = std::views::iota(0, (int) x.size());
  auto NY = y.size();
  std::for_each_n(
          std::execution::seq,
          ids.begin(), x.size(),
          [&, x = x.data(), y = y.data()](int i) {
            for (size_t j{0}; j < NY; ++j) {
              if (is_near(x[i], y[j])) {
                y_near_x[i].push_back(j);
              }
            }
          });
}

/*
 * NOTE: this version expect y_near_x to be pre-allocated and filled.
 * */
void search_copy_if(vector<float> &x, vector<float> &y, vector<vector<int>> &y_near_x) {
  auto ids = std::views::iota(0, (int) y.size());  // NOTE: its y.size(); and assuming reuse in loop for i (x)
  for (size_t i = 0; i < x.size(); i++) {
    auto nn_iter = y_near_x[i].begin();
    std::copy_if(
            std::execution::seq,
            ids.begin(), ids.end(), nn_iter,
            [=, x = x.data(), y = y.data()](int j) {
              return is_near(x[i], y[j]);
            });
  }

  // remove the fill values at the end of the results vector.
  for (int i = 0; i < (int) x.size(); i++) {
    while ((y_near_x[i].size() > 0) &&
           (y_near_x[i].end()[-1] == FILL_VALUE_INT)) {
      y_near_x[i].pop_back();
    }
  }
}


/**/
void search_copy_ifB(vector<float> &x, vector<float> &y, vector<vector<int>> &y_near_x) {
  auto ids = std::views::iota(0, (int) y.size());  // NOTE: its y.size(); and assuming reuse in loop for i (x)
  vector<int> nns(MAX_NN, FILL_VALUE_INT);
  for (size_t i = 0; i < x.size(); i++) {
    auto nn_iter = nns.begin();
    std::copy_if(
            std::execution::seq,
            ids.begin(), ids.end(),
            nn_iter,
            [=, x = x.data(), y = y.data()](int j) {
              return is_near(x[i], y[j]);
            });
    for (int j{0}; j < nns.size() && nns[j] != FILL_VALUE_INT; ++j) {
      y_near_x[i].push_back(nns[j]);
      nns[j] = FILL_VALUE_INT;
    }
  }
}


//Find near-neighbors of x[] in y[], given is_near(x[],y[]) is defined.
// Showing 2D array and index access idiom.
//Note: opportunity to use span<float> x vs vector<float>&x.
void search_copy_if_2D(vector<float> &x, vector<float> &y, vector<vector<int>> &y_near_x) {
  vector<std::tuple<int, int>> nn_pairs(  //Allocate and initialize 1D array of pairs:
          MAX_NN * (int) x.size(),         //no manual de-allocation will be needed.
          std::tuple<int, int>{FILL_VALUE_INT, FILL_VALUE_INT});
  auto xs = std::views::iota(0, (int) x.size());
  auto ys = std::views::iota(0, (int) y.size());
  auto ids = tl::views::cartesian_product(xs, ys);
  std::copy_if(
          std::execution::par,  //Sequential is the default
          ids.begin(), ids.end(), //The range of pairs from ids set
          nn_pairs.begin(), //GPU nvc++ requires random_access iter; container resizing not allowed.
          //for this item, an access by iterator idiom
          [=, x = x.data(), y = y.data()](auto idx) { //[] is start of lambda definition.
            auto [i, j] = idx;
            // auto i = get<0>(idx); auto j = get<1>(idx);
            return is_near(x[i], y[j]);// copy_if is using access by index idiom.
          }//End of lambda
  );
  //Put the results into programs "standard form" (consequnce of nn_iter requirements)
  for (auto &p: nn_pairs) { //An "access all container elems be reference" idion.
    auto [ix, jy] = p;
    //auto ix = get<0>(p); auto jy = get<1>(p);
    if (ix != FILL_VALUE_INT) {
      y_near_x[ix].push_back(jy);
    } else {
      break;
    }
  }
  //Note there is no "manual" deallocation of nn_pairs needed
}

//ids are custom made because nvc 23.5 compiler bug with cartesian_product.
void search_copy_if_2DB(vector<float> &x, vector<float> &y, vector<vector<int>> &y_near_x) {
  vector<std::tuple<unsigned int, unsigned int>> nn_pairs(
          MAX_NN * (int) x.size(),
          std::tuple<unsigned int, unsigned int>{FILL_VALUE_INT, FILL_VALUE_INT});
  auto ids = init_ids(x.size(), y.size());
  std::copy_if(
          std::execution::par,
          ids.begin(), ids.end(),
          nn_pairs.begin(),
          [=, x = x.data(), y = y.data()](auto idx) {
            auto [i, j] = idx;
            return is_near(x[i], y[j]);
          }
  );
  //Put the results into programs "standard form" (consequence of nn_iter requirements)
  for (auto &p: nn_pairs) {
    auto [ix, jy] = p;
    if (ix != FILL_VALUE_INT) {
      y_near_x[ix].push_back(jy);
    } else {
      break;
    }
  }
}

void search_for_each(vector<float> &x, vector<float> &y, vector<array<int, MAX_NNP>> &y_near_x) {
  assert(1 == 0); //TODO: unfinished - do not use. Alternative to copy_if?
  auto ids = std::views::iota(0, (int) x.size());
  size_t NY = y.size();
  std::for_each_n(std::execution::par_unseq,
                  ids.begin(), x.size(), [=, &y_near_x, x = x.data(), y = y.data()](int i) {
            for (size_t j{0}; j < NY; ++j) {
              if (is_near(x[i], y[j])) {
                //TODO: lock needed
                assert(y_near_x[i][MAX_NN] < MAX_NN);
                y_near_x[i][y_near_x[i][MAX_NN]] = j;
                ++y_near_x[i][MAX_NN];
              }
            }
          });
}


int main(int argc, char *argv[]) {
  vector<float> x(NX, 0.), y(NX, 0.);  // allocation of same size and init
  vector<vector<int>> y_near_x_r1, y_near_x_r2, y_near_x_rf;
  vector<array<int, MAX_NNP>> y_n_x;
  initialize_data(x, y);
  initialize_results_vec(x, y_near_x_r1);
  initialize_results_vec(x, y_near_x_r2);
  initialize_results_vec_fill(x, y_near_x_rf);
  initialize_results_arrays(x, y_n_x);

  string fstr1 = std::format("This is the first line with i1 = {} and "
                             "continues on the second line with i2 = {}", 1, 2);
  cout << endl << fstr1 << endl;

  cout << endl << "Calling search_serial" << endl;
  auto start = high_resolution_clock::now();
  search_serial(x, y, y_near_x_r1);
  auto stop = high_resolution_clock::now();
  auto duration = duration_cast<microseconds>(stop - start);
  cout << "serial search time: "
       << duration.count() / 1.0e6 << " seconds" << endl;
  //print_results(y_near_x_r1);

  cout << "Calling search_copy_if" << endl;
  start = high_resolution_clock::now();
  search_copy_if(x, y, y_near_x_rf);
  stop = high_resolution_clock::now();
  duration = duration_cast<microseconds>(stop - start);
  cout << "paralle search time: "
       << duration.count() / 1.0e6 << " seconds" << endl;
  //print_results(y_near_x_r1);
  // print_results(y_near_x_r3);

  compare_results(y_near_x_r1, y_near_x_rf);
}



