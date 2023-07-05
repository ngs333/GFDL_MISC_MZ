
//#include <algorithm>
#include <cassert>
#include <chrono>
#include <iostream>
#include <string>
#include <vector>

#include <random>
#include <numeric>
#include <algorithm>
#include <ranges>
#include <execution>

constexpr size_t NX{1000};

using namespace std;
using namespace std::chrono;


void par_sqrt_test(const size_t NS){
  vector<double> v(NS);
  std::generate(v.begin(), v.end(), std::rand);
  auto ints = std::views::iota(0);
  std::for_each_n(std::execution::par_unseq,
    ints.begin(), v.size(),
    [=,v = v.data()](int i){
      v[i] = std::sqrt(sin(v[i]) + cos(v[i]));
    });
}

  int main(int argc, char* argv[]) {
    cout << "Calling par_sqrt_test" << endl;
    auto start = high_resolution_clock::now();
    par_sqrt_test(NX * NX * NX);
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop - start);
    cout << "paralle par_sqrt_test: "
         << duration.count() / 1.0e6 << " seconds" << endl;
  }
