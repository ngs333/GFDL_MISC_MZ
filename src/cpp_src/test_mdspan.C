#include <algorithm>              
#include <iostream>
#include <numeric>
#include <vector>
#include <execution>
#include <random>

#include "mdspan.hpp" //Some compilers don't yet have #include <mdspan>

using namespace std; //sometimes its conveninet to not type the funn name.

constexpr int NX{10};
constexpr int NY{10};

/* 
With auto, let the compiler deduce the types and generate code appropriately. 
for local vars, function return types, function args ... Also can mix with
templates. Extremely usefull for complex types, but also as form of generics and even
simple functions lile index() below. Still stronly types
*/
//2Dspatial index collapsed into one 1D :
auto  index(auto i, auto j) { return (j * NX + i); }
//Whats wrong with "int index(index i, index j) { return (j * NX + i); }" ?"
//Templates are also common, and now support concepts (or contracts):
template<class T>
T  index_b(T i, T j) { return (j * NX + i); }

void init_data(auto mds, float mean = 0.0, float sigma=0.) {
  std::random_device rd{};
  std::mt19937 gen{rd()};
  std::normal_distribution dis{mean, sigma}; //C++ random dist functions are techhnically "great"
  for (auto i{0LU}; i != mds.extent(0); i++) {//auto not so usefull here (yet). 
    for (size_t j = 0; j != mds.extent(1); j++) { //this indexing more common.
      //Testing - just make the value equal to the collpased index + some error.
      //How does the next line show 
      mds[i, j] = (float)index(i, j) + dis(gen);  // MDS "array" notation not too wierd 4 you?
    }
  }
}

//Program illustrating by_value std parallelism:
int main(int argc, char* argv[]) {
  vector<float> ovg(NX*NY,0.), pvg(NX*NY,0.); // 1D vectors of Observed and Predicted values on "a grid";
  //<float> can be <some other class or type>
  //What did Bryce say about mdspan relative to algebra libraries?
  auto mso = mdspan(ovg.data(), NX, NY); //2D mdspan - the grid view
  auto msp = mdspan(pvg.data(), NX, NY);

  init_data( mso);
  init_data( msp, 0.5, 0.24 );

  // Calculate the square error:
  auto se = std::transform_reduce(std::execution::par, // sequential if omitted.
      ovg.begin(), ovg.end(),        // range of elems from ovg vector
      pvg.begin(),                   // first element from pvg
      0.0,                           // starting value of accumulation
      std::plus<>{},                 // reduction operation
      [](double o, double p) {       // [] is start of the lambda function that defines
        return ((o - p) * (o - p));  //    the transform operation
      }                              // end of lambda
  );                                 // end of transform_reduce

  //Note the type (float, string) not specfied. No error possible
  cout << "The mean square error is : " << se / ovg.size()  <<endl; 
  //And after 44 years:
  //std::print("{0} {2}-{1}!\n", "The cout statement above is old-fashioned since ", 23, "C++");
  //Does it remind you of Python?
}
