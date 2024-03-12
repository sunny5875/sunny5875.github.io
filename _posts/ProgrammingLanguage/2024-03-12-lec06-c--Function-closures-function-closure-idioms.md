---
title: lec06-c++, Function closures, function closure idioms
categories: ProgrammingLanguage
date: 2024-03-12 22:39:01 +0000
last_modified_at: 2024-03-12 22:39:01 +0000
---

### Function closure

```cpp
	int x = 42;
  auto addX = [x](int y) { return x+y;}; // capture: lexical scope
  std::cout << "addX(10):" << addX(10) << std::endl;
  x = 1;
  std::cout << "addX(10):" << addX(10) << std::endl;
// 52 52

  int y = 42;
  auto addY = [&](int x) { return x+y;}; // reference: dynamic scope
  std::cout << "addY(10):" << addY(10) << std::endl;
  y = 1;
  std::cout << "addY(10):" << addY(10) << std::endl;
// 52 11
```

- =: lexical scope
- &: dynamic scope

### Fold

```cpp
template<class T, class U, class F>
U foldl(F f, U acc, List<T> lst)
{
    static_assert(std::is_convertible<F, std::function<U(U, T)>>::value, 
                 "foldl requires a function type U(U, T)");
    if (lst.isEmpty())
        return acc;
    else
        return foldl(f, f(acc, lst.head()), lst.tail());
}

template<class T, class U, class F>
U foldr(F f, U acc, List<T> lst)
{
    static_assert(std::is_convertible<F, std::function<U(T, U)>>::value, 
                 "foldr requires a function type U(T, U)");
    if (lst.isEmpty())
        return acc;
    else
        return f(lst.head(), foldr(f, acc, lst.tail()));
}
```

```cpp
	List<int> l;
  l = l.cons(0).cons(1).cons(2).cons(3).cons(4);
  int sum = foldl([](int a, int b) { return a+b;}, 0, l); // 10

  float sum_ = foldr([](int a, float b) { return a+b;}, 0.0f, l);
  printf("%f\n", sum_); //10.0

  int max = foldl([](int a, int b) { return a>b?a:b;}, 0, l); // 4

  int val = 3;
  bool anyLargerThanVal = foldl([=](bool acc, int x) { return x>**val**? true:acc;}, false, l);// 1

  
  std::cout << "sum:" << sum << ", max:" << max << std::endl;
  std::cout << "anyLargerThanVal:" << anyLargerThanVal << std::endl;
```

### Combine

- f, g를 받아서 함수를 리턴하는데 x를 받아서 g,f를 적용하는 것

![스크린샷 2023-06-10 오후 10.33.46.png](lec06-c++,%20Function%20closures,%20function%20closure%20idi%2004a2596e9ee843758663c30913ff79f7/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_10.33.46.png)

```cpp
auto compose = [](auto f, auto g) { 
    return [=](auto&& ... x) { 
        return f(g(x...)); 
    }; 
};
```

- **generic lambda**
    - 람다함수인데 파라미터가 auto로 generic한 경우 (auto f, auto g부분)
    - 재러닉 람다는 c++14이후부터 가능
    - 호출 시 instance of compose function을 파라미터로 만듦
- universal reference
    - auto&&
    - use in template or generic lambda, instanticate될 때 타입이 결정됨
    - rvalue면 rvalue로 lvalue면 lvalue로 주는 것을 말함
- **variadic argument**
    - …
    - 여러개의 변수를 받는다는 의미

```cpp
auto h1 = compose([](int x){return x+1;}, [](){ return 42;}); // 43
std::cout << "h1()=" << h1() << std::endl;

auto h2 = compose([](pair<int,int> p){return p.first+p.second;}, [](int x, int y){ return pair(x, y);});
std::cout << "h2(1,2)=" << h2(1, 2) << std::endl; //3
```

- 이건 아주 general function이기에 single argument, multiple argument 등등 모두 가능

### Currying

function clousre의 확장버전

```cpp
auto add3(int a, int b, int c) {
return a+b+c;
}

auto curried_add3(int a) {
	return [=](int b){ // == [a,b] != [&] 여기를 &로 바꾸면 안됨. 
		return [=](int c){ //왜냐면 리턴해버리니까 a,b가 사라지기에 더미 데이터가 들어옴
					return a+b+c;
		};
	};
}

std::cout <<  add3(1,2,3) << " "; // 6 
std::cout << curried_add3(1)(2)(3) << std::endl; // 6
auto add2_one = curried_add3(1);
auto add1_three = add2_one(2);
add1_three(3); // 6
add1_three(4); // 7
```

```cpp
template<class T, class U>
std::function<std::function<U(List<T>)>(U)>
cfoldl(std::function<U(U, T)> f) 
{
    std::function<std::function<U(List<T>)>(U)> captured1;
    captured1 = [=](U acc) {
      std::function<U(List<T>)> captured2;
      captured2 = [=](List<T> lst) {
        if (lst.isEmpty()) return acc;
        else return cfoldl(f) (f(acc, lst.head())) (lst.tail());
      };
      return captured2;
    };
    return captured1;
}

	std::function<int(int,int)> adder = [](int a, int b)->int { return a+b;};
  auto sumFold = cfoldl(adder);
  std::cout << "after sumFold \n";
  int sum2 = sumFold(100)(l); // l: 0 1 2 3 4
  std::cout << "sum2:" << sum2 << std::endl; // 110
```

### ADT

```cpp
#include <functional>
#include <iostream>
#include "List.h"

template<class T>
bool contains(List<T> lst, T v) {
	return !filter([&](T val){return v == val;}, lst).isEmpty();
}

struct set { //set struct을 만들어서 세개의 함수를 포함
	std::function<struct set(int)> insert;
	std::function<bool(int)> member;
	std::function<int()> size;
};

struct set make_set(List<int> xs) { // xs를 캡처
	struct set s = { // nstructor가 없지만 list constructor로 초기화함
	[=](int a){if (contains(xs, a)) {return make_set(xs);}
							else {return make_set(xs.cons(a));}
						},
	[=](int a){return contains(xs,a);},
	[=](){int size=0; forEach(xs, [&](auto x){size++;}); return size;}
	};
	return s;
}

int main(){
	auto s1 = make_set(List<int>{});
    std::cout << s1.size() << std::endl;
	auto s2 = s1.insert(42);
    std::cout << s2.size() << std::endl;
	auto s3 = s2.insert(40);
    std::cout << s3.size() << std::endl;
}
```

- 진짜 ML처럼 한다면 Hide하고 empty set 함수를 만들어서 그 안에 Make_set을 넣으면 됨
- c++에서 클래스 상속으로 다형성을 할 수 있지만 다른 오브젝트를 동일하게 취급해서 하는 다형성 개념을 생각한다면 set struct을 생성 시 이 때 다르게 구현하고(얘를 들어 로깅 함수를 추가한다거나 그런 것들) 사용하는 코드는 바뀌는 게 없어지기에 이것도 다형성이 될 수 있다는 것!!
- make_container라고 하고 사용하는 애가 있고 function pointer가 안에 있다고 가정. 만약에 set container를 만들고 싶으면 관련된 함수 포인터를 담으면 되고 bag(중복을 허용)은 그거 관련된 포인터를 담으면 됨. 그러나 사용하는 쪽은 달라지는 거 없이 된다는 것!!