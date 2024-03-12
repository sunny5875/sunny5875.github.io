---
layout: post
title: Lec05-c++, First-class function
category: Compiler
date: 2024-03-12 22:21:28 +0000
---

### First class function c++

- function을 value처럼 쓰라는 거였는데 ML과 완전 같지는 않지만 거의 동일함
- function type value를 쓰려면 funcional header 추가해줘야함
- c++ 14부터 가능

```cpp
#include <functional>
#include <iostream>

float adder(float a, float b) {return a+b;}
int main() {
	// function type value로 부르기
	std::function<float(float,float)> f = adder;
	f(3.2, 3.3);

	// pair로 만들어서 하기
	std::pair f_arg = {f,std::pair{3.2,3.3}};
	f_arg.first(f_arg.second.first, f_arg.second.second);

	// apply함수 사용하기
	std::apply(f_arg.first, f_arg.second); // c++17부터 가능
}
```

- `f=adder`는 사실 아주 많은 일이 일어나고 있음
    - assign operator는 std::function object를 만들고 있지만 얘는 mimic fist class 임
    - 따라서 adder와 완전 같지는 않지만 그런 거처럼 쓸 수 있다라는 말임
    - c++ 17부터는 인자를 튜플에 담아서 보내도 됨

### Function closures

- function에서 밖에 정의된 변수를 사용할 수 있는 개념
    - lexical scope에서는 그 변수들은 캡처되어서 사용되는 거였음

```cpp
int var1 = 42;
auto addVar1 = **[]**(int arg) {
return var1+arg;
};
addVar1(10);
```

```cpp
int var1 = 42;
auto addVar1 = **[=]**(int arg) {
return var1+arg;
};
addVar1(10);
```

- c++에서도 있지만 다만 explicit하게 해줘야 함
- var1을 쓰지만 컴파일 에러를 냄. implicity하게 캡처할 수 없기에 []안에 어떻게 캡처할 건지 말해줘야 함
    - =: capture the variable, 모든 변수는 캡처되어야한다. 카피되어야 한다
    - &: no capture, access as reference. 모든 변수는 reference로 가져와야 한다.
    - 만약에 변수가 function이 선언된 후에 바뀌고 다시 호출되면 &는 업데이트된 값을 쓰고 =은 아님
    - &를 쓰면 dynamic scoping과 매우 비슷하게 됨. =를 쓰면 lexical scope으로 쓸 수 있음
    - [var1,var2]이렇게 하면 얘네를 캡처하겠다는 소리임
    - [&, var1] : 디폴트는 &인데 캡처를 var1으로
    - [=, &var1]: 디폴트는 =인데 var1은 reference로

### Functions as argument(higher order function)

```cpp
float applyFG(float a, **std::function<float(float)> f**,
                       **std::function<float(float)> g**) {
  return g(f(a));
}
auto add1 = [](float a) { return a+1.0f;};
auto add2 = [](float a) { return a+2.0f;};
float res = applyFG(4.2f, add1, add2);
std::cout << "applyFG(4.2f, add1, add2):" << res << std::endl; // 7.2
```

### Example n_times

![ML에서의 n_times](Lec05-c++,%20First-class%20function%203034667be9034f9c80d24e24959a101e/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.23.39.png)

ML에서의 n_times

```cpp
int n_times(std::function<int(int)> f, int n, int x) {
  if (n==0) {
    return x;
  } else {
    return f(n_times(f, n-1, x));
  }
}

// 여긴 외부 변수를 쓰지 않기 때문에 캡처방법을 명시하지 않아도 에러가 나지 않음
auto dbl = [](int x) { return x+x;};
auto incr = [](int x) { return x+1;};
  
std::cout << "n_times(dbl, 10, 1):" << n_times(dbl, 10, 1) << std::endl ;
std::cout << "n_times(incr, 10, 2):" << n_times(incr, 10, 1) << std::endl ;
// 여기서는 dbl, n_times를 쓰고 있기 때문에 캡처방식 명시 필요!!
auto dbl_ntimes = **[=]**(int n, int x) { return n_times(dbl, n, x); };
std::cout << "dbl_ntimes(10, 3):" << dbl_ntimes(10, 3) << std::endl ;
```

- 교수님은 dbl_ntimes의 캡처방식을 [=, &n_times] or [&, dbl] 이렇게 하는 게 낫다라고 봄
    - n_times은 전역변수니까 바뀌지 않으므로 reference로  괜찮지만 dbl은 바뀔 수 있으니까 캡처하는 게 낫다라고 보는 거임
    - 물론 똑같이 돌아갈거임 그냥 덜 오버헤드가 된다는 것

### Map

![스크린샷 2023-06-10 오후 9.28.43.png](Lec05-c++,%20First-class%20function%203034667be9034f9c80d24e24959a101e/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.28.43.png)

```cpp
template<class U, class T, class F>
List<U> fmap(F f, List<T> lst)
{
    static_assert(std::is_convertible<F, std::function<U(T)>>::value, 
                 "fmap requires a function type U(T)");
    if (lst.isEmpty()) 
        return List<U>();
    else
        return List<U>(f(lst.head()), fmap**<U>**(f, lst.tail()));
}

List<int> l2 = fmap<int>([](int x){ return x+1;}, l); // l은 [0,1,2,3]
std::cout << "l2:"; print(l2); //l2:(1) (2) (3) (4)
```

- detail은 몰라도 됨 template 를 가지고 있다면 이해할 필요는 없지만 사용하는 방법만 알면됨
- function f가 사실 T를 받아서 U를 리턴해야하는데 이걸 template으로 잘 표현한다면 되지만 이게 너무 복잡함 ㅠㅠ contract같은 거 쓰면 된다는데 따라서 U타입인 거를 알 수 없어서 마지막에 U가 들어가는 거임

### Filter

![스크린샷 2023-06-10 오후 9.44.00.png](Lec05-c++,%20First-class%20function%203034667be9034f9c80d24e24959a101e/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.44.00.png)

```cpp
// true false 내는 거 아니고 배열 필터링 하는 거야 똥멍청아 
template<class T, class P>
List<T> filter(P p, List<T> lst)
{
    static_assert(std::is_convertible<P, std::function<bool(T)>>::value, 
                 "filter requires a function type bool(T)");
    if (lst.isEmpty())
        return List<T>();
    if (p(lst.head()))
        return List<T>(lst.head(), filter(p, lst.tail()));
    else
        return filter(p, lst.tail());// T를 추론할 수 있어서 명시할 필요 x
}

List<int> l3 = filter([](int x){ return x%2==0;}, l);
std::cout << "l3:"; print(l3); // l3:(0) (2)
```

### Ifall

```cpp
template<class T, class F>
bool ifall(F f, List<T> lst) {
  static_assert(std::is_convertible<F, std::function<bool(T)>>::value, 
                 "Requires a function type bool(T)");
  if (lst.isEmpty()) {
    return true;
  } 
  if (f(lst.head()))
    return ifall(f, lst.tail());
  else return false;
}

bool allOdd = ifall([](int x){ return x%2 == 1; }, l3);
  std::cout << allOdd << std::endl;
```

### any_even

```cpp
template(class F)
bool any(F test, Expr e) {
	static_assert(std::is_convertible<F, std::function<bool(int)>>::value, 
                 "Requires a function type bool(T)");
	return std::visit(overload{
		[=](Constant c){return test(c.val);},
		[=](box<Negate>& e){ return test(e->e);}, // box는 ->인거 잊지 말기
		[=](box<Add>& e){**return any(test, e->e1) || any(test, e->e2);**}, **//여기유의**
		[=](box<Mult>& e){**return any(test, e->e1) || any(test, e->e2);**}
	}, e);
}

auto expr = Expr(Mult{Constant{1}, Constant{3}});
std::function<bool(Expr)> any_even = any([](int v) {return v%2 == 0;}, expr);
```

아까는 list였고 얘는 expression tree로 하는 거임

- add,mult의 경우 안에 expression이 더있을 수 있으니까 재귀로 불러야 함!!
- =는 test, any를 캡처함 → 이걸 &로도 쓸 수 있음.
    - any, test는 바뀌지 않고 또한 애는 사용할 동안 살아있기 때문
    
    cf. any 위에 visit 위에 any가 있기에 reference로 가져가더라도 any 안에 test가 로컬변수로 살아있기 때문에 reference라고 써도 됨
    
    만약 any가 test를 캡처한 함수를 리턴한다라고 한다면 test가 더이상 살아있지 않을 수 있기 때문에 reference를 쓸 수 없음. 
    
    =으로 하면 카피에서 람다함수에 저장되는 거고 &를 쓰게 되면 any에 저장된 애를 쓰는 게 되기 때문에 이 경우에서는 상관없음. 왜냐면 function frame이 valid하기 때문
    

[Modern C++](https://www.notion.so/Modern-C-68255570b17d4e8e87d8e22fe77b631f?pvs=21)
