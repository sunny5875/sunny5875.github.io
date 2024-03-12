---
layout: post
title: Lecture03.cpp-updated
date: 2023-06-14 23:25:33 +0000
category: ProgrammingLanguage
---

### ML record ⇒ C++ Struct

<aside>
🌵 struct은 class와 비슷함(단 struct이 다 public이라고 가정) struct은 생성자가 존재.

</aside>

**build struct and variable**

```cpp
struct {
	type1 f1;
	type2 f2;
} v1,v2...;
```

**assign field**

```cpp
v1.f1= e1;
...
vn.fn = en;
```

**access field**

```cpp
v1.f1
v1.fn
...
```

ex)

```cpp
struct student {
	 string name;
	optional<int> id;
};
student james = {"james", 42};
auto students = {james};
**for(auto s: students)** {
	std::cout << s.name << std::endl;
}
```

만약에 생성자가 있다면 그 생성자를 사용하고 없다면 list syntax를 이용해서 c++ 컴파일러는 first field를 첫번째에 두번째는 두번째 변수에 넣음. 이 때 optional이랑 안맞기에 c++은 알아서 optional에 int를 받는 생성자가 있는지 체크: optional int 생성 → stduent 변수 생성

### ML Data Bining ⇒ C++ Variant

<aside>
📗 c++에서 variant쓰려면 **#include <variant>**를 추가해줘야 함

</aside>

- std::variant는 datatype과 비슷
- datatype과 비슷하고 보면 되는데 different value로 하니까 이름이 variant임

```cpp
int main(void) {
    std::variant<int,float,std::string> v1{42},v2; **// 초기화하지 않으면 int로 여겨짐**
    **// auto v2 = 42.2; // redefinition된다고 에러뜸**
    v2 = {42.2f}; //이거 됨
    // float f = 42.2;  
    // v2 = f; 이거 됨
    // v2{42.2}; 이거 안됨

    **auto *intPtr = std::get_if<int>(&v1); // &붙여줘야 함. variant가 int가 맞으면 포인터 리턴 아니면 널포인터**
    // auto intPtr = std::get_if<int>(&v1); *있든 없든 위 코드와 동일한 의미
     if (intPtr != nullptr) {
        std::cout << "int" << std::endl;
    }

    try {
        auto intVal = **std::get<int>(v1); // variant가 int가 맞으면 실제 변수 리턴 아니면 exception**
    } catch(std::bad_variant_access) {
        std::cout << "exception" << std::endl;
    }
   
std::variant<int, std::string> v = "abc";
std::cout << **std::holds_alternative<int>(v)** << std::endl; // varaiant가 int를 가지고 있다면 true를 리턴
```

- alternative로 먼저 확인한 뒤에 true면 가져오면 됨!

Q. 만약에 variant의 타입이 같은게 여러번 있다라고 한다면 value를 어떻게 가져올까???

```cpp
		std::variant<std::string, std::string> var42;
    **var42.emplace<0>("abc");**

    auto strPtr = **std::get_if<0>**(&var42);
    std::cout << *strPtr << std::endl;

    try {
        auto strVal = std::get<0>(var42);
        std::cout << strVal << std::endl;
    } catch(std::bad_variant_access) {
        std::cout << "exception" << std::endl;
    }
```

인덱스로 가져올 수 있음! 0부터 시작

### ML Case Expression ⇒ Std::visitor

<aside>
📗 c++에서 visit 함수 쓰려면 **#include <variant>**를 추가해줘야 함

</aside>

- 패턴 매칭하려면 struct을 만들어서 해야함
- call operator overriding

그다음 instance를 만들어서 visit 함수에 넣으면 right 패턴이 맞는 거를 찾아줘서 해당 함수를 불러줌

```cpp
using myType = std::variant<int, float, std::string>;
struct MyCase { // 형변환이 마땅히 맞는게 없으면 안됨 string이면 string 있어야함. strind 시 int 없어도 됨
     void operator()(int i) const {
        std::cout << "int " << i << std::endl;
    }
    void operator()(float i) const {
        std::cout << "float " << i << std::endl;
    }
    void operator()(const std::string& i) const {
        std::cout << "string " << i << std::endl;
    }
};

int main(void) {
    myType v1{"42"};
    std::visit(MyCase(), v1);
    // 위 코드와 같은 의미
    // auto a = MyCase();
    // a(42); 
		// a(42.2f);
}
```

→intOrFloatOrStr이 string variant이기에 세번째 함수가 호출됨

- 만약에 MyCase에서 세번째 함수를 까먹고 구현안하면 컴파일하게 되면 에러가 남
    - ml에서의 에러와 비슷, 따라서 케이스를 안까먹게 해줌

cf. primitive type이 아니라면(class, struct)라면 &를 붙여서 reference를 사용, 안붙이면 copy가 너무 많이 일어나기 때문!! 또한 const를 붙이면 not change state를 명시할 수 있음!

### Multsign function Example

곱해서 부호를 리턴하는 함수

```cpp
struct P {};
struct N {};
struct Z {};

variant<P,N,Z> multsign(int x, int y) {
    auto sign = [](int v) { 
        if (v>0) { return variant<P,N,Z>(P{}); 
        } else if (v<0) { return variant<P,N,Z>(N{}); 
        } else { return variant<P,N,Z>(Z{});}
    };
  struct MyCase {
  variant<P,N,Z> operator()(const P& v1, const P& v2) { return variant<P,N,Z>(P{});}
  variant<P,N,Z> operator()(const P& v1, const N& v2) { return variant<P,N,Z>(N{});}
  variant<P,N,Z> operator()(const P& v1, const Z& v2) { return variant<P,N,Z>(Z{});}
  variant<P,N,Z> operator()(const N& v1, const P& v2) { return variant<P,N,Z>(N{});}
  variant<P,N,Z> operator()(const N& v1, const N& v2) { return variant<P,N,Z>(P{});}
  variant<P,N,Z> operator()(const N& v1, const Z& v2) { return variant<P,N,Z>(Z{});}
  variant<P,N,Z> operator()(const Z& v1, const P& v2) { return variant<P,N,Z>(Z{});}
  variant<P,N,Z> operator()(const Z& v1, const N& v2) { return variant<P,N,Z>(Z{});}
  variant<P,N,Z> operator()(const Z& v1, const Z& v2) { return variant<P,N,Z>(Z{});}
  };

    return std::visit(MyCase{}, sign(x), sign(y));
}
```

- nest function을 선언: 각 정수의 부호를 판단해서 variant를 생성하는 함수
- 아까는 visit에서는 한개의 arugment를 보냈는데 지금은 두개의 arugment를 보냄 → 각각의 두개의 변수에 대해서 override를 해줘야 함
    - 아까는 3개의 함수를 오버로딩, 지금은 3* 3 = 9가지의 경우의 수가 있기에 9개의 함수를 오버로딩
    - 하나의 경우의 수라도 없으면 에러가 남

cf. primitive type이 아니기에 const, &을 붙임: &은 최적화를 위해서 const는 업데이트 안함을 명시하기 위해 사용

두개의 arugment 중에 하나라도 0이면 z이 나오게 됨

```cpp
struct P {std::string str() {return "p";}} //str()로 묶어서 원래 하려고 했는데 variant타입이 오기에 어찌되었든 분기로 해야 함
struct N {std::string str() {return "N";}}
struct Z {std::string str() {return "Z";}}

auto res = multsign(1,-1); // N이 나옴
if (std::holds_alternative<P>(res)) {
	cout<<"P"<<endl;
} else if(std::holds_alternative<N>(res)) {
	cout<<"N"<<endl;
} else {
	cout<<"Z"<<endl;
}
```

cf. visit에서 exhaustive한지 컴파일타임에 체크하는 편

cf. MyCase를 최적화한다면 auto로 받아서 나머지를 다 묶어서 할 수도 있음!

**→template을 사용해서 좀 더 쉽게 바꿔보자**

```cpp
//Ts들을 상속받는 template strcture 
template<class... Ts> struct overload : Ts... { using Ts::operator()...; }; 
// guide, 원래는 template 이니까 타입 명시를 하면서 생성자를 호출해야하는데 그걸 편하게 하기 위한 꼼수 !!
template<class... Ts> overload(Ts...) -> overload<Ts...>; 
```

template을 쓰면 MyCase struct을 아래처럼 overload 람다함수로 바꿀 수 있음!!

- 첫번째 줄
    - 여러 유형을 상속받는 template structure을 선언
    - using문은 Ts안에 ()가 있는데 namespace를 쓰고 싶지 않아서 적은 코드 → 모든 ()연산자 함수를 overload 클래스로 가져오는 효과
- 두번째는 guide, 컴파일러에게 알려주는 가이드
    - overload 같은 constructor가 있다면 위의 템플릿으로 하라고 알려주는 것
    - 즉, overload 클래스의 인스턴스를 만드는 방법을 정의하고 생성자에 해당 인수를 전달
- 코드에서 overload 구조체의 인스턴스를 생성할 때, Ts에 여러 개의 함수 포인터를 전달하면, 해당 함수들을 상속한 overload 객체를 생성할 수 있습니다. 이렇게 생성된 overload 객체는 std::visit 함수 호출에 사용되어 std::variant에 저장된 값의 유형을 판별하고 해당 작업을 수행합니다.

```cpp
auto res = std::visit(overload{
            [](const P& v1, const P& v2) { return variant<P,N,Z>(P{});},
            [](N& v1, N& v2) { return variant<P,N,Z>(P{});},
            [](P& v1, N& v2) { return variant<P,N,Z>(N{});},
            [](N& v1, P& v2) { return variant<P,N,Z>(N{});},
            [](auto, auto) { return variant<P,N,Z>(Z{});}, //base case를 의미, generic lamda라고 부름(c++14)
					//만약에 sign x, y가 위의 4개가 아니면 불려짐
        },sign(x), sign(y));
```

→ commma separate 되고 overload는 struct을 가지기에 이전 코드와 동일한 효과를 가짐

- templete class 선언이고 밑은 가이드인데 templete definition 안에 있는거, overload라는 템플릿 클래스 구조체로부터 저 람다함수들에 해당하는 structure을 만들어서 그렇게 만들어진 구조체를 파라미터로 해서 실제 인스턴스를 만들고 visit 함수가 operator를 접근할 때 이름없이 접근하기에 using이 있는 것

template class는 이해할 필요는 없지만 쓸 수는 있어야함

### expression tree

ml에서 한 거를 c++에서 해보쟈

- expression tree는 recursive datatype이 뽀인트!

![스크린샷 2023-04-14 오후 10.33.17.png](Lecture03%20cpp-updated%2075191ea85b41457498dc4778946c01d6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_10.33.17.png)

동작되니? no! 아직 expr을 선언안했으니까!

![스크린샷 2023-04-14 오후 10.33.33.png](Lecture03%20cpp-updated%2075191ea85b41457498dc4778946c01d6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_10.33.33.png)

struct선언하기전에 위에 variant에 쓴다면???

얘가 얼마나 스페이스를 쓰는지모르기에 쓸 수 없음 ㅠ

→ 포인터로 해보쟝: 되지만 우리는 ml에서 했던 거처럼 하고 싶음!( new 없이)

![스크린샷 2023-04-14 오후 10.36.29.png](Lecture03%20cpp-updated%2075191ea85b41457498dc4778946c01d6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_10.36.29.png)

cf.expr 대신 variant로 적으면 되지 않나? 안되지 선언을 안했으니까 대신 포인터로 한다면 가능~

### Expresstion tree in c++

box는 Negate, add, mult를 받아서 expr로 바꿔주기 위해 box로 wrapping함

```cpp
template <typename T> // T는 negate, add, mult가 될 것
class box {
    std::unique_ptr<T> _impl;
    public:
        box (T &&obj): _impl(new T(std::move(obj))) {} //잠깐 존재하는 애를 deep copy하지 말고 shallow copy해라는 의미
        box (const T &obj):_impl (new T(obj)) {}
				// copy constructor
        box (const box &other):box(*other._impl) {}
        box &operator=(const box &other) {
            *_impl = *other._impl;
            return *this;
        }
				// move constructor
        box (box &&other) : box (std:: move (*other._impl)) {}
        box &operator= (box &&other) {
            *_impl = std::move(*other._impl);
            return *this;
        }
        ~box() = default;

        T &operator*() { return *_impl; } // * operator, 실제 객체의 레퍼런스를 돌려줌
        const T &operator* () const { return *_impl; } // * operator

        T *operator->() { return _impl.get () ;} // -> operator
        const T *operator->() const { return _impl.get () ; } //-> operator,포인터를 돌려줘서 attribute를 접근
};

```

![스크린샷 2023-04-14 오후 10.44.32.png](Lecture03%20cpp-updated%2075191ea85b41457498dc4778946c01d6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_10.44.32.png)

![스크린샷 2023-04-14 오후 10.41.53.png](Lecture03%20cpp-updated%2075191ea85b41457498dc4778946c01d6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_10.41.53.png)

- negation 오브젝트를 만들어서 mult 생성자를 받으려고 하는데 생성자 expr이자나!! 그래서 컴파일러가 negation → expr로 바꿔줌 이를 위해 box로 wrapping해서 expr로 바꿔줌
- 박스가 하는 일이 뭘까? stack에 할당된 벨류(Negate)를 받아서 똑같은 오브젝트를 heap allocaiton해서 unique ptr이 reference count해서 비할당해주는 거고 몇가지 연산자가 있어서 편하게 해줌

cf.몰라도됨! &&가 있는게 rvalue reference라는 것: 곧 사라질 object의 레퍼런스를 의미, 이게 좀 어려움. 이 개념 자체가 프로그래머를 위한 게 아니라 컴파일러 최적화를 위해서 만들어진 개념이라서 어려움. negate가 힙에 만들어지자 마자 mult 생성자로 들어간거임. 그니까 잠깐만 존재하는 오브젝트라고 볼 수 있는데 그런 경우에 걔를 받아서 std::move가 heap에 negate를 만드는데 copy 생성자 부르지말고 안에 오브젝트로 포인팅하는 애들은 그냥 포인팅해라. deep copy하지 말고 shallow copy해라는 의미! → 그러면 필요없을 때 스콥이 끝나면 걔가 없어지니까~rvalue reference 생성자가 부르도록 강제하는게 move함수

cf2.mult 오브젝트를 다시 add에 옮길 때 사용, expr안에서 포인터로 box를 갖고 있는데 이때 다 카피하지 않고 무브한다~ : 결론은 최적화하는 거다~ 몰라도 됨>ㅁ<

- 이제 ml과 비슷한 Expression tree를 만들었고 eval함수를 만들어보쟈~

### eval function

*box<Add>&이지 Add&가 아님*

```cpp
template<class... Ts> struct overload : Ts... { using Ts::operator()...; }; //template strcture
template<class... Ts> overload(Ts...) -> overload<Ts...>; // guide, 원래는 template 이니까 타입 명시를 하면서 생성자를 호출해야하는데 그걸 편하게 하기 위한 꼼수 !!

int eval(Expr e) {
   return std::visit(overload{
		[](const Constant& c) {return c.val;},
		[](box<Negate>& e) {return -(eval(e->e));},
		[](box<Add>& e) {return eval(e->e1) + eval(e->e2);},
		[](box<Mult>& e) {return eval(e->e1) * eval(e->e2);}
	},e);
}
```

const를 람다 함수 앞에 적는게 사실 더 좋음

### max_const

```cpp
int max_const(Expr e) {
    return std::visit(overload {
        [](Constant& c) {return c.val;},
        [](box<struct Negate>& c) {return max_const(c->e);},
        [](box<struct Add>& c) {return **std::max**(max_const(c->e1), max_const(c->e2));},
        [](box<struct Mult>& c) {return std::max(max_const(c->e1), max_const(c->e2));}
    }, e);
}
```

### count_adds

```cpp
int count_adds(Expr e) {
    return std::visit(overload {
        [](Constant& c) {return 0;},
        [](box<struct Negate>& c) {return count_adds(c->e);},
        [](box<struct Add>& c) {return 1 + count_adds(c->e1) + count_adds(c->e2);},
        [](box<struct Mult>& c) {return count_adds(c->e1) * count_adds(c->e2);},
    }, e);
}
```

### expr in oop

- unique ptr이나 box class를 사용해야 함

any 함수에 대한 코드를 올릴테니 함 봐라