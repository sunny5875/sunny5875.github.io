---
layout: post
title: LECTURE 02. cpp-fp-updated
date: 2023-06-14 23:25:33 +0000
category: ProgrammingLanguage
---

### Pairs(2-tuples)

**build**

<aside>
✅ c++에서 pair을 사용하기 위해서는 **#include<utility>**필요하다

</aside>

| syntax | std::pair<ta,tb>{e1,e2} // ()대신 {}쓰는 게 좋음
std::make_pair<ta,tb> (e1,e2) // using function 이 때는 ()만 가능!

std::pair<ta,tb> v = {e1,e2}; // variable declaration 
std::pair<ta, tb> x{e1,e2};  // variable declaration |
| --- | --- |
| type-checking | e1은 ta 타입이고 t2는 tb 타입이면
→ 전체 expression의 타입은 ta*t2가 된다 아니면 에러 |
| evaluation | e1을 evaluate하여 v1
e2를 evlauate하여 v2
→ 전체 결과는 (v1,v2) |

cf.  modern c++의 속성

- 생성자의 경우  modern c++에서는 {}로 constructor로 부르는 편
    - uniform initialization, 실수로 변환을 통해 cropping되는 것과 함수 정의로 불리지 않게 막아줌
- old c++은 <>가 필수였지만 modern c++17은 type이 필요하지 않음, 자동으로 체크해줌!
- variable declaration
    - = 을 사용하는 방법은 copy initialization
    - {}로 직접 초기화하는 방법은 direct initialization
    - 일반적으로 direct initialization이 복사 초기화로 발생될 수 있는 모호성을 피할 수 있기에 기본방법으로 간주

**access**

| syntax | e.first
e.second |
| --- | --- |
| type-checking | e가 ta* tb타입이라면
→ e.first는 ta 타입이고 e.second는 tb 타입이 됨 |
| evaluation | e를 evaluate한 후
→ 첫번째나 두번째 값을 리턴 |

```cpp

std::cout<< std::boolalpha;//해당 받은 값을 bool로써 결과를 출력하는 함수라고 보면 됨, 안쓰면 1이나 0이 나오기에 이걸 선언한 것

std::pair a{1, "a"};
std::cout<<a.second<<std:endl; // pointer이지만 가리키는 값이 있기 때문에 1을 리턴

std::pair<int, bool> a = {1, "a"}; // type은 명시해도 되고 명시안해도 상관없음
std::pair<int, bool> a = {1, "a", "b"}; //pair이기에 무조건 두개의 값만 들어가야 하므로 에러!

std::pair a{1, "a"}; //direct initialization: calling  contructor, 아래와 거의 차이없다고 보면 됨
std::pair a = {1, "a"}; //copy initialization: initialize list -> construct를 보고 parameter에 list가 있다면 생성자를 호출, 만약에 없다면 each element를 생성자 호출함. 위와 거의 리소스 차이는 없다고 보면 됨
std::pair a = std::make_pair(1, "a"); // make_pair라는 함수 호출, {}는 함수 호출에는 사용할 수 없고 initialize나 constructor에만 사용가능

std::pair<int, bool> b{1,false}
auto c = swap(b);
```

```cpp
#include <utility>

std::pair<bool,int> swap(std::pair<int,bool> pr) {
	return std::pair<bool,int> {pr.second, pr.first}; 
	// copy ellision발생 , 일반생성자와 복사생성자가 불리는게 아니라 일반생성자만 불림
}

int sum_two_pairs(std::pair<int,int> pr1,std::pair<int,int> pr2 ){
	return pr1.first + pr1.second + pr2.first + pr2.second;
}

std::pair<int, int> div_mod(int x, int y) {
    return std::pair {x/y, x%y}; // c++에는 mod, div없음!!
	//()로 하면 타입 바꾸면서 에러가 나올 수도 있지만 {}로 하면 워닝메세지가 미리 알려주므로 {}사용할 것
}

// std::pair을 그냥 cout해버리면 에러남!!! 조심할 것
```

- 구현은 뒤에 있어도 되지만 먼저 호출할 경우에는 위에 인터페이스를 적어줘야 함. 이때 인터페이스에는 <> type을 명시해줘야 함. compiler가 모르기 때문!
- make_pair로 template function이기 때문에 argument 타입은 알아서 맞춰짐
- auto로 두면 compiler가 추측함.
- swap함수에서 c관점이 친숙하다면 이 코드는 약간 이상해보일 것. 왜냐면 pair object는 스택에 올라감. 그 다음 리턴을 하게 되면 swap 스택은 사라지게 될 것, 하지만 caller 스택에 그 값을 저장하고 있음
    - = sign으로 인해 copy constructor이기에 copy assignment가 됨. caller stack에는 결과를 가지고 있고 swap function에서 만들고 그 값을 caller stack에 복사

→ cpp 컴파일러는 swap함수를 호출하면 무조건 caller stack 에 저장한다고 생각: **copy Ellison**, 일반생성자 호출되자마자 복사 생성자가 호출되는 경우 일반생성자만 호출됨

### Tuples

<aside>
✅ c++에서 tuple을 사용하기 위해서는 **#include <tuple>** 추가해줘야함

</aside>

- pair, tuple은 ml에서는 거의 같은 개념이지만 c++은 좀 다름

**build**

```cpp

std::tuple<ta,tb,tc> {e1,e2,e3} // using constructor
std::make_tuple(e1,e2,...) // using function

//예시
std::tuple t1{1,"",false};
auto t2 = std::make_tuple(1,2,3);
auto t3 = std::tuple{1,2,3}; // only c++17
```

**access**

```cpp
std::get<N>(e1); //N에 인덱스를 넣으면 되고 이때 0부터 시작!! (ML은 1부터 시작)
//범위를 넘으면 에러가 나옴

// 예시
cout<<std::get<2>(t1)<<endl;
```

### Nested Pairs and Tuple

- 역시 가능

```cpp
		auto t1 = std::tuple{1,"abc",std::tuple{2,3.1f}};
	  std::cout << std::get<1> (std::get<2> (t1)) << std::endl;

    auto p1 = std::pair{ false, std::pair{true, 42}};
    std::cout << p1.second.first << std::endl; 
		//p1.second.first  == (p1.second).first 괄호 안써도 잘 됨!!
```

### Lists

<aside>
✅ c++에서 list를 쓰려면 **#include <list>** 필요

</aside>

- ML의 리스트처럼 any number of element but list element have the same type
- 하지만 c++은 **mutable**함!! ml의 immutable list과 다름

**building list**

```cpp
std::list<t>{}; 
std::list<t> l = {}; // variable declaration, {} 대신 [] 안됨!!!
auto l = std::list<t> {}; // variable declaration
```

```cpp
std::list<t>{{1,2,3,4}}; // {1,2,3,4};은 안된다고 했지만 사실 됨 아마 initialize list때문일 듯
std::list<t> l = {1,2,3}; // variable declaration, {} 대신 [] 안됨!!!
auto l = std::list<t> {1,2,3}; // variable declaration
```

```cpp
// ML처럼 동작하도록 e1::e2
auto l = std::list(e2);
l.push_front(e1); // 새로운 리스트를 만들어서 더해줌

// C++에서 동작하는 방식
e2.push_front(e1); // e2는 e1이 들어가도록 변경됨

```

```cpp
//ML처럼 동작하도록 e1@e2
auto l = std::list(e1);
l.insert(l.end(), e2.first(), e2.end());

// C++에서 동작하는 방식
e1.insert(e1.end(),e2.first(),e2.end()); // e1값이 업데이트 됨
```

```cpp
val y = [1,2,3];
val x = 0::y; 
```

![스크린샷 2023-04-14 오전 12.40.37.png](LECTURE%2002%20cpp-fp-updated%2023a650c6944e4731803ddf1d7e267933/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_12.40.37.png)

- ml에서는 y는 1의 헤더를 가리키고 x는 0을 가리키는데 그 뒤는 y배열
- c++에 있는 push_front는 y의 헤더를 0으로 바꿔버림

**access**

```cpp
l.empty() // l이 비었으면 true를 반환 isEmpty아니고 empty!!
l.front()  // l이 [v1,v2,...vn]이라면 v1을 리턴
l.back() // vn을 리턴 ML과 다름!!!

//ML에서의 tl 방법 1
auto l2 = std::list(l);
l2.pop_front();
//방법 2
std::list(++l.begin(), l.end()); // ++l.begin() == ++(l.begin())
```

### Example

```cpp
int sum_list(std::list<int> xs) {
	if (xs.empty()) { 
		return 0;
	} else {
		return xs.front() + sum_list(std::list(++xs.begin(), xs.end()));
	// copy해서 매번 새롭게 배열을 만들어서 넘겨주고 있음
	}
}
```

![스크린샷 2023-04-14 오전 12.51.02.png](LECTURE%2002%20cpp-fp-updated%2023a650c6944e4731803ddf1d7e267933/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_12.51.02.png)

```cpp
int sum_list2(std::list<int> xs) {
	std::function<int(std::list<int>::iterator)> sum_aux;
	sum_aux = [&](std::list<int>::iterator it) {
        if (it == xs.end()) {
            return *it;
        } else {
            return *it + sum_aux(++it); //it.next() 이런거 없다 수빈아^^
        }
    };

    return sum_aux(xs.begin());
}
```

```cpp
std::list<int> countdown(int x) {
    if (x == 0) {
        return std::list<int> {};
    } else {
        auto result = countdown(x-1); 
        result.push_front(x);  
        return result; // x + countdown(x-1);이 거 안된다 똥아

				// auto s = countdown(x-1).push_front(x); // 얘는 리턴이 없음..
        // return s; 이렇게도 안됨 왜냐면 push_front하고 나서 그 변수 어딨는데..? 없잖아 ㅠㅠ 불가능

    }
}
```

```cpp
std::list<int> append(list<int> xs, list<int> ys){
    if (xs.empty()){
        return std::list(ys);
    } else {
				// 새로운 변수로 만들어줘야 mutable없이 잘 일어남
        auto res = append(std::list(++xs.begin(), xs.end()), ys);
        res.push_front(xs.front()); // iterator가 하나 움직였지만 list는 그대로이기에 xs.front하면 첫번째가 나옴

        return res;
    }
}
```

### Immutable List Class

일단 다 이해하려고 하지말고 친숙하는데 초점을 둔 후에 계속 하다보면 작동원리가 이해가 될 것

> 일단 디테일은 몰라도 되지만 어떻게 쓰는 지만 일단 알면 시험이나 숙제를 모두 할 수 있을 것, isEmpty, head, tail, cons, makeList 이 함수들을 어떻게 쓰는지만 알면 됨
> 

```cpp
#include <cassert>
#include <memory>
#include <iostream>
#include <optional> // optional
#include <functional> // for lamda
template<class T>
class List {
    struct Node; // node를 선언하기 전에 해당 struct가 있음을 알리는 용도. 별의미 x

    private:
        struct Node {
            T _val; // 실제 노드에 들어간 값
            **std::shared_ptr<const Node>** _next; //노드의 다음 포인터

            // 있는 노드에 앞에 노드를 생성해 덭붙이는 생성자로 공유하기 위해 shared_ptr이 필요하고 immutable하기 위해 const가 필요
            Node(T v, std::shared_ptr<const Node> const & tail) : _val(v), _next(tail) {}
            // 하나의 값을 가지는 node
            Node(T v) : _val(v), _next(nullptr) {}
        };

        //list의 머리, 리스트는 얘만 가지고 있음, 역시 공유하기 위해 shared_ptr이고 immutable이니까 const 
        **std::shared_ptr<const Node>** _head; 
        
        // node를 가리키는 ptr을 이용해서 리스트를 만드는 생성자
        explicit List (std::shared_ptr<const Node> nodes) : _head(nodes) {}
    public:
        List(){} // 빈 노드를 만드는 리스트 생성자
        List(T v): _head(std::make_shared<Node> (v)){} // 한개의 노드만 있는 리스트 생성
        List(T v, List const& tail): _head(std::make_shared<Node>(v, tail._head)){} //있던 리스트에 앞에 노드를 붙이는 리스트 생성자, 붙이는 노드 생성자 부른 후에 리스트의 헤드에 넣어주면 됨
        
        // null e
        bool isEmpty() const {return !_head;}

        // hd e
        T head() {
            assert(!isEmpty());
            return _head-> _val;
        }

        // tl e: 리스트를 리턴해야함
        List tail() { // List야 바보자식아 제발 ㅠㅠㅠ 
            assert(!isEmpty());
            return List(_head->_next);
        }

        //e1::e2, 현재 리스트에 새로운 노드를 붙여서 리턴
        List cons(T v) const {
        return List(v, *this);
        }
};

// e1::e2
template<class T>
List<T> cons(T v, List<T> tail) { return List(v,tail);}

// 한개를 가진 list 만드는 함수
template<typename T>
List<T> makeList(const T& arg) {
    return List<T>().cons(arg);
    // return List(arg); 이렇게 해도 됨!
}
// 여러개의 값을 가지는 리스트를 만드는 함수
template<typename T, typename... Args>
List<T> makeList(const T& arg, const Args&... args) {
    // 같은 타입을 가지는지 체크
    static_assert((std::is_same_v<T, Args> && ...),
            "All arguments must have the same type as T");
    // 뒤를 만든 후에 cons로 합침
    return cons(arg, makeList<T>(args...));
}
```

- **ML의 리스트로 구현하기 위한 뽀인트**
    - **con**: 못바꾸게 함. 다음 리스트를 못바꾸게 함!
    - **shared ptr**: 만약에 있던 애로 새로 만든다면 share하게 함.
        - 한 노드를 여러 개가 Pointer하고, 아무도 point하지 않은 경우 자동 deallocate해줌
        - heap에 저장되기 때문에 stack은 함수가 리턴되면 사라지지만 힙은 트레킹해줘야하기 때문

![스크린샷 2023-04-14 오후 3.54.36.png](LECTURE%2002%20cpp-fp-updated%2023a650c6944e4731803ddf1d7e267933/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_3.54.36.png)

- smart pointer == share pointer , allow create reference count, automatically deallocation

cf. Reference count관리하는 애를 obejct 근처에 두는 것 vs 따로 두는 것
-> 근처에 두는 것이 낫다! 왜냐면 ref를 가져오면 object도 같이 캐싱되기 때문에 두번 안가져오게 되니까 좋다!

cf. explicit: c++에서 object를 만들 때 오브젝트의 생성자가 있을 텐데 그 타입이랑 다른 애를 넘겨주면 c++은 type conversion을 함. int → float을 하면 float을 인자로 받는 int 생성자가 있으면 해주는데 Explicit가 있으면 type converison을 하지 말고 해라는 의미!!

### Building List

```cpp
	List<t>();
	makeList(e1,e2,...);
	makeList<t>(e1,e2...);
	auto l = makeList(e1,e2,...); // e1::e2 in ML
	cons(e1,l);
```

### Accessing Lists

```cpp
l.isEmpty(); // null e
l.head(); // v1
l.tail(); // [v1,v2, ... vn]
```

### Example Lists of pairs

```cpp
int sum_pair_list(List<pair<int,int>> xs ) {
	if (xs.isEmpty()) {
		return 0;
	} else {
		return xs.head().first + xs.head().second + sum_pair_list(xs.tail());
	}
}

List<int> firsts(List<pair<int,int>> xs) {
	if (xs.isEmpty()) {
		return **List<int>{}; // 타입 명시해줘야 함**
	} else {
		return cons(xs.head().first, firsts(xs.tail()));
	}
}

List<int> seconds(List<pair<int,int>> xs) {
	if (xs.isEmpty()) {
		return List<int>();
	} else {
		return cons(xs.head().second, seconds(xs.tail()));
	}
}

int sum_list(List<int> xs ) {
	if (xs.isEmpty()) {
		return 0;
	} else {
		return xs.head() + sum_list(xs.tail());
	}
}

int sum_pair_list2(List<pair<int,int>> xs) {
	return sum_list(firsts(xs))+ sum_list(seconds(xs));
}

```

```cpp
auto l1 = makeList<pair<int,int>>(std::pair(1,2),std::pair(1,2));
con(42, l1); //에러, pair<int,int> type이 아니여서
con(pair(42, 0), l1); //good

List<std::pair<int,int>> cons(int c, List<std::pair<int,int>> tail) {
	List(pair(v,0),tail);
}

con(42, l1);// 이제 될 것

print(pair(42,0))// 안됨. pair을 cout가 지원하지 않기 때문
```

cf. terminal에서 fg로 하면 foreground로 올려줌

code 대부분 업로드해줄 거임

### Functions/varaibles with scope

- 변수에 스콥을 주고 싶다면 {}에 넣으면 됨
    - while, for, 등등의 {}도 역시 scope을 준다고 생각하면 됨

```cpp
{
	 [typename] v1=3; 
}
```

### Nested Functions in c++

<aside>
✅ 람다함수를 쓰기 위해서는 **#include <functional>**을 추가해줘야 함

</aside>

c++에서의 nested function은 ml과 매우 비슷함. 

```cpp
{
	auto func1 = [] (type1 arg1, type2 arg2) {
			// function body
	};
	
	func1(val1,val2);
}
```

- 람다함수라고 함
    - syntax: [](args..) {…}
- 이를 이용해서 파라미터, 리턴 등등에도 함수를 넣을 수있음

![스크린샷 2023-04-14 오후 4.22.48.png](LECTURE%2002%20cpp-fp-updated%2023a650c6944e4731803ddf1d7e267933/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_4.22.48.png)

```cpp

List<int> l3(); // 이거 안됨 왜 안될까?? 컴파일러가 얘가 function declaration이라고 생각함.그래서 생성자를 부를 때 {}로 쓰는게 낫다는 것!!
List<int> l3 {}; //이렇게 해야 함!!
```

```cpp
//count up c++ 코드

List<int> countup_from1(int x) {
	std::function<List<int>(int)> count = [&](int from) {
		if(from == x) {
			return **List<int>(x);** // x 넣어줘야 함
		} else {
				return count(from+1).cons(from);
				// return cons(from, count(from+1));
		}
	};

	return count(1);
}
```

- c++에서 recursion이고 외부의 변수를 사용하는 함수인 경우에는 [&]를 써야 한다.
    - call by reference로 부른다는 의미
    - count가 이런 타입이라는 거는 아는데 이 함수 안에서는 저 함수를 못쓰는데 [&]를 두면 쓸 수 있게 됨
    - cf. [&]이 없으면 카피해서 사용하게 됨. globa[l](http://됨.global) x를 가져온다면 카피해서 가져오기 때문에 글로벌 x값이 바뀌어도 안바뀌게 되는 거임!! 컴파일하는 동안에는 count 함수가 만들어지기 전이기 때문에 copy하지 말고 reference로 써라라는 의미로 [&]를 사용하는 것

Q. 람다 함수가 어떻게 작동하냐?

A. c++은 익명 struct을 만들어서 function call operator를 만듦. 람다식은 그다음 인스턴스를 만들고 걔로 함수를 부름

```cpp
struct (#AB) {
	float operator()(int, ..);
};

#AB a;
a(4);
```

![Untitled](/assets/2024-03-12-LECTURE-02-cpp-fp-updated/Untitled.png)

### better max

<aside>
✅ optional을 사용하기 위해서는 **#include <optional>**을 추가해야 함
NONE == optional<T>{std::nullopt};
isSome == opt.has_value();
valOf == opt.opt.value();

</aside>

![스크린샷 2023-04-14 오후 4.39.04.png](LECTURE%2002%20cpp-fp-updated%2023a650c6944e4731803ddf1d7e267933/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_4.39.04.png)

```cpp
optional<int> max(List<int> xs) {
	if(xs.isEmpty()){
		return **std::nullopt; // optional<int>{std::nullopt};이 좀더 정확**
	} else {
		auto tl_ans = max(xs.tail());
		**if (tl_ans.has_value() && tl_ans.value() > xs.head()) { //순서를 바꾸면 안됨!!! 왜냐면 <로 하면 tl_ans에 값이 없어도 head에는 값이 있을 수 있는데 그게 처리가 안됨!**
			return  tl_ans;  
		} else {
			return std::optional<int>{xs.head()};// tl_ans.value(); 도 가능
		}
	}
}
```

- ml은 NONE의 타입을 지정하지 않지만 optonal<int>{std::nullopt};의 경우는 타입을 정확하게 지정해주는 편
    
    Q. 만약에 return std::nullopt;로 하게 된다면??
    
    A. c++ 컴파일러는 알아서 nullopt → optional<int>로 바꾸도록 explicit conversion을 하기에 사용할 수 있음
    
- optional(xs.head());로 하는 거는 타입 추론이 가능하기 때문에 생략한 것

max_nonempty로 바꿔서 해보자

```cpp
optional<int> max2(List<int> xs) {
	if(xs.isEmpty()){
		return std::nullopt; // optional<int>{std::nullopt};이 좀더 정확
	} else {
			std::function<int(List<int>)> max_nonempty = [&](List<int> _xs) {
			if(_xs.tail().isEmpty()) {
				return _xs.head();
			} else {
				auto tl_ans = max_nonempty(_xs.tail());
				if(tl_ans < _xs.head()) {
					return _xs.head();
				} else {
					return tl_ans;
				}
			}
		};
		return optional<int>{max_nonempty(xs)};
	}
}
```