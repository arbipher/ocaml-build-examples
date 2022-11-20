#include <iostream>

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
}