#include <iostream>
#include <functional>

int Add(int a, int b) {
  return a + b;
}

float AddF(float a, float b) {
  return a + b;
}

// parametric polymorphism
template<typename T>
T PolyAdd(T a, T b) {
  return a + b;
}

// non-type parameter
template<typename T, int base>
T PolyAddWithIntBase(T a, T b) {
  return a + b + base;
}

// error: ‘float’ is not a valid type for a template non-type parameter
// template<typename T, float base>
// T PolyAddWithFloatBase(T a, T b) {
//   return a + b + base;
// }

template<typename T, T(*op)(T, T)>
T BinaryOp(T a, T b) {
  return op(a, b);
}

// Failed attempt: split definition at the template level
// higher-ranked types? 
// see https://www.reddit.com/r/cpp/comments/lmoz4r/advanced_polymorphism_in_c/
template <typename K>
using BinopSplit = K (*)(K, K);;

template<typename T, BinopSplit<T> >
T DoubleThenReduce(T a, T b) {
  return BinopSplit<T>(BinopSplit<T>(a, a), BinopSplit<T>(b, b));
}

// require `-std=c++20`
//
// Split the definitions
// template <typename K>
// using Binop = std::function<K(K arg1, K arg2)>;;

// template<typename T, Binop<T> >
// T DoubleThenReduce(T a, T b) {
//   return Binop(a, b);
// }
//
// end of require

// template <typename K>
// using K (*Binop2)(K, K);;

// template<class T>
// struct OpWrapper1
// {
//   typedef T (*Binop)(T, T);
// };

// error: ‘OpWrapper1<T>::Binop’ is not a type
// template<typename T, OpWrapper1<T>::Binop >
// T DoubleThenReduce1(T a, T b) {
//   return Binop(a, b);
// }

// template<typename T>
// struct OpWrapper2
// {
//   typedef T (*Binop)(T, T);
// };

// error: ‘OpWrapper2<T>::Binop’ is not a type
// template<typename T, OpWrapper2<T>::Binop >
// T DoubleThenReduce2(T a, T b) {
//   return Binop(a, b);
// }


int main(int argc, char* argv[]) {
  int c = Add(3, 4);
  std::cout << "add 3 4 = " << c << std::endl;

  int p1 = PolyAdd(3, 4);
  std::cout << "poly_add 3 4 = " << p1 << std::endl;

  float p2 = PolyAdd<float>(3.0, 4.5);
  std::cout << "poly_add 3.0 4.5 = " << p2 << std::endl;

  auto p3 = PolyAdd(3.0, 4.5);
  std::cout << "poly_add 3.0 4.5 = " << p3 << std::endl;

  float p4 = PolyAddWithIntBase<float, 2>(3.0, 4.5);
  std::cout << "PolyAddWithIntBase 3.0 4.5 = " << p4 << std::endl;

  // float p5 = PolyAddWithFloatBase<float, 2.0>(3.0, 4.5);
  // std::cout << "PolyAddWithFloatBase 3.0 4.5 = " << p5 << std::endl;

  int p6 = BinaryOp<int, Add>(3, 4);
  std::cout << "BinaryOp<Int, Add> 3 4 = " << p6 << std::endl;

  float p7 = BinaryOp<float, AddF>(3.0, 4.5);
  std::cout << "BinaryOp<float, AddF> 3.0 4.5 = " << p7 << std::endl;

  // higher-order
  int p8 = BinaryOp<int, BinaryOp<int, Add>>(3, 4);
  std::cout << "BinaryOp<Int, BinaryOp<int, Add>> 3 4 = " << p8 << std::endl;

// Failed attempt: split definition at the template level
  // int p9 = DoubleThenReduce<int, PolyAdd >(3, 4);
  // int p9 = DoubleThenReduce<int, (BinopSplit)(BinaryOp<int, Add>) >(3, 4);
  // std::cout << "DoubleThenReduce<int, (BinopSplit)(BinaryOp<int, Add>) 3 4 = " << p9 << std::endl;
}