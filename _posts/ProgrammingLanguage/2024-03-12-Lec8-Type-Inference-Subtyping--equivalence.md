---
layout: post
title: Lec8 Type Inference, Subtyping & equivalence
date: 2023-06-14 23:25:33 +0000
category: ProgrammingLanguage
---

### Type-checking

- (**static) type checking**은 the possibility of some error를 prevent하기 위해 can reject a program
    - 타입체킹은 타입체킹만 하는 기능말고 reject a program을 할 수도 있다는 관점에서 보자!
- **dynamically typed language**는 거의 컴파일타임에는 타입체킹을 하지 않고 runtime에 진행
- ML, Java, C#, Scala, C, C++: **statically typed**
    - 모든 바인딩이나 expression은 하나의 타입을 가지고 타입이 **compile time**에 결정되어야 함

### Implictly type

- ML: i**mplicitly typed**
    - 리턴타입이나 인자타입을 명시안해줘도 컴파일러가 타입을 추론할 수 있음

![타입체킹은 타입 에러가 있으면 program을 reject함](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_9.20.43.png)

타입체킹은 타입 에러가 있으면 program을 reject함

### Type inference

impliciting type, static type이 가능하려면 컴파일러는 type inference를 해야함

- **type inference problem**
    - every binding/expression에 type cheking이 되는 타입을 줘야 함
    - can’t assign type to each variable and expression → type errror
- type inference는 type checking 전 preprocess로 해야 하지만 대부분 같이 실행
- type inference can be easy, difficult or impossible
    - no type error인 all program을 accept, has type error인 all program reject : 불가능
        - 이유 : halting problem
            - finite time에 프로그램을 보는데 이 파트의 프로그램이 terminate인지 inifinite 알 수 없다
        - 때문에 타입 에러가 있는데 이게 실행되는지 안되는지 모르니까 전체 프로그램이 타입에러인지 아닌지 알 수 없게 됨 → not possible to typec hecker reject all error program accept all no error program
    - 단, all program을 accept, reject하는 건 쉬운 편
    - subtile, elegant, and not magic: ML

### Overview

- ML type inference 예시를 볼 것
- 타입을 어떻게 추론하는지에 대해서 알건데 일반적인 알고리즘은 type inference 알고리즘(힌들러 어쩌구)이지만 advance니까 mimic type inference 알고리즘을 할거임

### Key steps

1. 위에서 아래로 binding의 타입을 결정
    - except mutual recursion
    - 뒤에 있는 binding을 사용할 수 없음 사용한다면 type check가 되지 않을 것
2. 모든 val, fun binding에서 대해
    - 모든 필요한 정보를 모음(constraint)
        - ex) x>0을 보면 x는 int라는 걸 알 수 있음!!
    - 모든 fact를 유지할 방법이 없으면 type error(over contraint)
3. any unconstrained type에 대해 type varaible(’a 같은 generic)을 사용
    - ex)인자로 받았는데 아무일도 하지 않은 경우 any type 가능
4. (value restriction 적용)

### Simple example

![스크린샷 2023-06-10 오전 9.31.34.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_9.31.34.png)

```cpp
1. 
(* simulate type checker (in a way) *)
(* this is given: abs: int -> int *)

fun f x =
	let val (y,z) = x in
		(abs y) + z
	end

```

```python
 f: T1 -> T2
 x: T1
 y: T3
 z: T4
 T1 = T3*T4

T3 = int
T4 = int
T2 = int

f: int*int -> int
x: int*int
```

```python
2. 
fun sum xs =
	case xs of
	[] => 0
	|x::xs' => x + (sum xs')

```

```python
sum: T1 -> T2
XS: T1

T1 = T3 list
T2 = int

X = T3
xs' = T3 list
T3 = T2 = int

sum: int list -> int
xs: int list
```

```python
3. 
fun broken_sum xs = 
	case xs of
	[] => 0
	|x::xs' => x + (broken_sum x)
```

```python
broken_sum = T1 -> T2
xs = T1

T1 = T3 list
T2 = int

x = T3
xs' = T3 list

T3 = int
T3 = T1 <- type error t1 = t3 list = t1 list
타입에러가 나오는 위치가 다를 수는 있음
*)
```

```python
4. 
fun length xs =
 case xs of
	[] => 0
	|x::xs' => 1 + (length xs')
```

```python
length = T1 -> T2
xs = T1

T1 = T3 list
T2 = int

x = T3
xs' = T3 list

length: T3 list -> int
				'a list -> int
```

```python
5. 
fun f(x,y,z) = 
if true 
then (x,y,z)
else (y,x,z)
```

```python
f: T1 * T2 * T3 -> T4
x: T1
y: T2
z: T3

T4 = T1 * T2 * T3
T4 = T2 * T1 * T3
T2 = T1

f: T1*T1*T3 -> T1*T1*T3
	'a * 'a * 'b -> 'a * 'a * 'b
```

```python
6. 
fun compose(f,g) = 
	fn x => f (g x)
```

```python
compose: T1 * T2 -> T3
f: T1
g: T2
**anon func: T3**

x: T4
T2 = T4 -> T5
T1 = T5 -> T6
T3 = T4 -> T6

compose: ((T5 -> T6) * (T4 -> T5)) -> (T4 -> T6)
					('a -> 'b) * ('c -> 'a) -> ('c -> 'b)
```

- type variable은 이름은 달라도 같은 관계만 정해지면 됨

### Relation to polymorphism

- **ML type inference의 central feature**
    - infer type with type variables
        - c++은 subtype 개념으로 가능해짐(재너릭 람다)
    - code를 reuse할 수 있고 function을 이해하는데 도움을 줌
        - 다른 타입이지만 같은 함수 사용 가능
- **type inference와 type varaible(generic): orthogonal!! 상관없는 개념!**
    - language can have type inference without type variable
        - 타입변수는 없고 타입 추론 하는 언어
    - language can have type variables without type inference
        - 타입 추론은 없지만 타입 변수를 사용하는 언어

### Key idea

- type checking에 필요한 모든 fact를 collect
- fact들은 function type을 constaint
- type inference 예시 결과
    - type variable이 있는 예시:  length, f, compose
        - 차이없고 단지 under constrained라는 것!!어떤 타입이든 될 수 있지만 다른 타입들과 동일하게 동작할 것
    - type varaible이 없는 예시: f, sum
    - 타입 체크가 안되는 예시: broken_sum

### Two more topics

- 지금까지 나온 ML type inference 개념은 허술
    - polymorphic type이 있는 곳에 value restriction limit이 필요
- **type checking concept**
    - ex) 6개의 프로그램들이 있는데 6개 중에 3개가 타입에러가 있다라고 가정
        
        근데 아까 말했을 때 컴파일타임에는 어떤게 진짜 타입에러이고 아닌지를 파악할 수 없다고 했음
        
        → 3개의 프로그램에만 진짜로 타입에러가 있는데 컴파일러는 모든 프로그램을 reject함
        
    1. **soundness**
        1. 에러가 있는 프로그램에 대해서 있다고 해야 함
    2. **completness**
        1. 프로그램이 에러가 없다면 없다고 해야 함
    - 위의 예시는 3개에만 타입에러가 있는데  모든 프로그램을 reject함 : sound
    - 또한 맞는 3개에 대해서도 틀렸다고 하니까  not completness
    
    |  | not error | error |
    | --- | --- | --- |
    | completenss | 에러 안나!! | 에러 안날지도?? |
    | soundness | 에런날지도?? | 에러나!! |

→ soundness, completeness를 동시에 만족할 수 없음

Q. 머가 더 유용한가?? sound하고 incompletness가 더 유용함!

- ML은 sound, imcomplete
    - 에러가 나는 부분이 있는데 걔가 실행이 안되면 에러가 안나는 거지만  모르기에 ML은 에러가 난다라고 봄 soundness를 위해서
- C++은 unsound, imcomplete
- ML은 type inference의 최적의 위치에 존재
    - Type inference는 polymorphism(generic type)이 없으면 더 어려움
    - Type inference는 subtype이 있으면 어려움
    
    → polymorphism은 있고 subtype는 없어서 쉬운 편!
    

### The problem

- 지금까지 본 ML system은 unsound!

![스크린샷 2023-06-10 오전 10.28.14.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_10.28.14.png)

- r을 선언
    - r: ‘a option ref 타입
- 어떤 모듈에서 SOME “hi”로 값을 바꿈
    - :=의 타입 ‘a ref * ‘a → int
    - r: string opiton ref 타입
- 만약에 다른 모듈에서 선언된 r을 이용해서 integer로 바꾼다면???
    - !의 타입 ‘a ref → ‘a
    - r: int option 타입
    - 에러!! int + string을 할 수 없으니까
    - but, 타입체커는 알 수 없음, 같이 있다면 체크할 수 있지만 만약에 다른 모듈에 있다라면 동시에 볼 수 없다면 에러가 날 수 있음
    - mutation이 없다면 이런 일은 없음

### What to do

- restore soundness를 하기 위해 stricker type system이 필요
    - 이 세 라인 중 하나는 reject되어야 함
- 하지만 reference type에 rule을 둘 수 없음
    - 이유: type checker가 모든 type synonyms을 알 수 없기 때문
        
        ![스크린샷 2023-06-10 오전 10.33.10.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_10.33.10.png)
        

### The fix

**value restriction**

- not contain function call이면서 variable이나 value인 expression만 polymorphic type(’a)으로 variable binding이 가능
    - ref는 생성자(함수)인데 funtion과 재너릭 타입(NONE)이 동시에 val binding에 들어가면 reject가 된다는 말
- get a warning을 주고 unconstrained type은 dummy type으로 채워짐

```cpp
val r = ref NONE; //에러남, r은 wield, dummy type이어여서 쓸모없다는 말임
val r = ref NONE: int option ref; // 이건 됨, generic type을 지웠기에 가능
val r = NONE;
r := SOME 42;
```

### Downside

- value restriction은 mutation을 쓰지 않으면 제약할 필요 없음
    
    ![스크린샷 2023-06-10 오전 10.39.11.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_10.39.11.png)
    
    - map 타입: *('a → 'b) → 'a List.list → 'b List.list*; : polymorphic type
    - 여기에 fn x ⇒ (x,1)은 ‘a → ‘a * int 타입: generic type
    - polymorphic type에 또 generic type을 넣으니까 에러
    - 위에서 type checker는 List.map이 mutable reference을 만드는지 확인 불가
- 그렇지만 ML은 여전히 경고를 발생
    - variable binding이 아닌 function binding으로 wrapping하면 됨
        
        ![스크린샷 2023-06-10 오전 10.40.04.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_10.40.04.png)
        

cf. 다이나믹 타입은 빨리빨리 짤 수 있으니까 쓰는 거임

---

### A local optimum

- value restriction이 있지만 ML type inference는 아주 elegant, fairly, easy to understand
- **More difficult without polymorphism(generic type)**
    - length 함수를 가정으로 본다면 generic type이 지원되지 않는다면 우리는 어떤 타입을 줘야할까?? 안되자나 ㅠㅠ ML은 generic type을 지원하기 때문에 type inference가 됨
- **More difficult with subtyping**
    - 만약 pair가 tuple의 supertype이라면?
    - `val (y,z) = x` 에서 x는 정확히 2개의 field를 가지는 게 아닌 적어도 두개의 field를 가질 수 있게 됨, 그럼 x의 타입을 결정짓기 어려워짐 ㅠㅠ
    - subtype이 있다면 type inference하기 더욱 어려워짐 ㅠ

### Generic type and subtype

- **generic**
    - **ML은 type variable로 제공**
        - ‘a, ‘a list, ‘a option, ‘a → ‘b
    - 자바의 generics, c++의 template
- **Subtype**
    - **ML에서는 제공하지 않음**
    - subclass와 거의 비슷한 개념 살짝 다르긴 함
        - java, c#, c++은 subtype을 구현하기 위해 subclass를 사용
    - **Liskov substitution principle**를 만족해야 함
        - S <: T이면 모든 S의 value는 instance of T자리에 바꾸기 가능하다라는 말임!!

### Classes vs types

- **class**는 object’s **behavior**를 정의
    - subclass는 behavior를 inherit하고 overriding으로 바꿀 수 있음

```cpp
class A {
 foo();

}

class B: A {

}
```

```cpp
class B {
A -a;
foo() {-a.foo();}
}
```

- **type**은 **object의 method의 argument, result type**을 describe
    - subtype은 field, method type관점에서 substitutable
    - client가 Instance of a를 쓰는데 test instance of b를 해도 client code는 동일하게 동작
    - substution rule이 필요
- java, c#: 편리를 위해 subclass를 하면 subtype이 되도록 구현해서 같은 개념임
    - class이름이 type 이름임

### Subtyping in a tiny language

- ML과 java를 섞어서 설명을 해보쟈!
    - record + mutable field(ML은 record는 mutaion이 안되지만 된다고 가정해서 해보쟈!)
    - ML은 Record가 있지만 subtyping, fiedl mutataion이 안됨
    - Java는 class name과 interface name을 사용

**record(ML + java)**

- **record creation**
    - `{f1=e1, f2=e2,..,fn=en}`
    - ei를 evaluate해서 record를 생성
- **record field access**
    - `e.f`
    - e를 f field를 가진 record로 evaluate하고 f field의 content를 가져옴
- record field update
    - `e1.f = e2`
    - e1을 f field를 가진 record인 v1으로 evaluate하고 e2를 v2로 evaluate
    - v1의 field를 v2로 change
    - return v2
    - ML에서는 update가 안되지만 된다라고 가정!! f의 타입과 e2의 타입은 동일해야함

### Basic type system

- **record type**
    - `{f1: t1, f2: t2, ... , fn: tn}`

**type checking**

- e1이 t1, …en이 tn 타입이면
    - `{f1=e1, f2=e2,..,fn=en}` 은 `{f1: t1, f2: t2, ... , fn: tn}` 타입
- e가 f(type t)를 가진 record type 이라면
    - `e.f` 는 type t
- e1가 f(type)를 가진 record type이고 e2가 t type이라면
    - `e1.f = e2` 는 type t

### This is safe

- 이 evaluation rule과 typing rule은 없는 feild를 접근하지 않기에 safe

ex)

![스크린샷 2023-06-10 오전 11.13.30.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_11.13.30.png)

- distToOrigin: 원점과 p의 거리를 구하는 함수임
- pythang과 distToOrigin의 인자인 p의 타입이 완전 같기에 동작함

좋지만 얘는 만약에 우리가 다른 attribute도 하고 싶은데 어떻게 해야할까?

### Motivating subtyping

![스크린샷 2023-06-10 오전 11.14.23.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_11.14.23.png)

- c의 타입과 distToOrigin의 인자인 p의 타입이 달라 타입 체크 x

→ 하지만 아무 문제 없는 거 같은데 support하는 게 어떨까?

### allow extra field

- `{f1: t1, f2: t2, ... , fn: tn}` 이면 some filed가 없는 타입도 가질 수 있다라고 해보자!

![스크린샷 2023-06-10 오전 11.16.52.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_11.16.52.png)

- c는 x,y,color field를 가지고 있는 타입인데 인자가 x,y만 가진 혹은 color만 가진 타입이여도 c는 보낼 수 있게 됨

### Keeping subtyping separate

- programming language에는 이미 많은 typing rule이 있기 때문에 바꾸지 않고 새로 추가
    - **subtyping** : t1이 t2의 subtype이라면 t1<: t2
    - **new typing rule** that use subtyping
        - `if e has type t1 and t1<: t2, then e also type 2`

### Subtyping rule

- Principle of substitutability
    - t1<:t2이면 t1인 any value들은 t2가 있는 어디든 사용할 수 있어야 함
        - 우리의 예시에서는 subtype은 supertype의 모든 field를 갖고 있어야 함

### Four good rules

- 구체적으로 이 4가지를 추가해야하는데 1번째만 추가하고 나머지는 이미 있는 거임
    - **Width subtyping**
        - supertype은 같은 타입들의 subset을 가진다
        - 즉, subtype은 super type보다 더 많은 타입을 가질 수 있음
    - **Permutation subtyping**
        - supertyping은 ordering을 고려하지 않는다
    - **Transitivity**
        - `if t1<:t2 and t2<:t3 then t1<: t3`
    - **Reflexivity**
        - 모든 타입은 자기자신과 subtype

→ 아까 타입체크 안된 예시가 동작됨

### More record subtyping

- 지금까지의 subtyping rule은 type을 바꾸는 게 아니라 버리는 거였음

![스크린샷 2023-06-10 오전 11.22.41.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_11.22.41.png)

- field는 그대로 있는데 center의 타입이 다름 → type check안됨

→ `{center: {x: real, y: real}} <: {center: {x: real, y:real, z: real}}` 룰을 추가해줘야 함

### Add Depth subtyping

**Depth subtyping**

- `if ta<:tb then {f1:t1, … ,f: ta, fn:tn} <: {f1:f1, …., f:tb, …. , fn:tn}`

### Stop!

- 다른 변수의 타입을 보낼 수 있어서 좋지만 얘는 **soundness를 망가뜨림**
    - mutation with depth subtyping이 문제임

### Mutation strikes again

![스크린샷 2023-06-10 오전 11.26.40.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_11.26.40.png)

- setToOrigin함수까지는 동작함
    - sphere의 center타입이 {x: real, y: real}이 됨
- sphere.center.z에서 z가 없어졌기 때문에 문제 발생

→ mutation이 없으면 문제가 없지만 있어서 문제가 나는 거임!

- 지원한다면 soundness가 깨지게 되고 이런 예시가 자바임

### Moral of the story(교훈)

- getter와 setter(mutation)를 가진 record, object에서 depth subtyping은 unsound
- field가 immutable하다면 depth subtyping은 sound할 것
- setter, depth subtyping, soundness에서 2개만 만족 가능
- 이런 문제는 실제로 자바에서 일어남

### Picking on java

subtype == subclass라고 했었음

- java의 array는 depth subtyping이 일어나는 record와 동일하게 동작
    - `if t1<: t2 then t1[] <: t2[]`
    - type check는 되지만 실제로 돌리면 에러가 남

![스크린샷 2023-06-10 오전 11.31.11.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_11.31.11.png)

Q. 왜 이렇게 되도록 했었을까??

A. 초기 자바 버전에는 제너릭 타입이 없었음.  Object class는 모든 클래스의 부모 클래스임. 이 말은 object[]은 string[]의 super class라는 의미임. 

```cpp
Arrays.copy(Object[] src, Object[] dst);
String[] a;
String[] b;

Arrays.copy(a,b); //여기까지 타입 에러 문제없었음
```

- 아주 편리하지만 아까 예시와 같은 문제가 발생할 수 있음

cf. subtype == subclass이게 아닌 언어가 있나욤?

A. python은 subtyping과 subclass 개념이 다름. Python은 function argument 넣을 때 subtype check을 아예 하지 않음…

A. a가 쓰는 거처럼 b가 쓸 수 있어야 하는데 a에서는 런타임 에러가 안나는데 b에서는 난다면 client 코드는 런타임 에러 대처를 안하니까 얘는 사실 subtyping이라고 보면 안됨… compiler가 체크해주는 subtype은 맞지만 principle을 생각해봤을 때 즉, 개념 자체를 생각한다면 아니라고 봐야함…

## Now functions

- caller는 subtyping for argument를 쓸 수 있다는 걸 배웠음
    - caller에 인자를 보낼 때 인자의 subtype을 보내도 괜찮다는 소리!

만약에 함수에서 함수를 인자로 보낸다면 subtyping을 어떻게 체크할까??

### Example

![스크린샷 2023-06-10 오전 11.34.02.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_11.34.02.png)

- 여기에는 subtyping 적용되지 않음
    - flip의 타입: `{x: real, y: real}-> {x: real, y: real}`
    - distMoved의 인자 f 타입:  `{x: real, y: real} -> {x: real, y: real}`
    - p에 subtype을 보낼 수 있지만 그건 아까 한거~

→ 그래서 argument는 같지만 리턴타입은 subtyping이 되도록 룰을 추가해보자!

### 1) Return type subtyping

![스크린샷 2023-06-10 오전 11.36.25.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_11.36.25.png)

- flip의 타입: `{x: real, y: real} -> {x: real, y: real, color: String}`
- distMoved의 인자 f 타입:  `{x: real, y: real} -> {x: real, y: real}`

→ 문제 없음: `if ta <: tb then t→ta <: t→tb`

- function은 *필요한 거 보다 더 많이 return*해도 됨!
- return type은 *covariant(순서가 같음)*

### 2) argument subtyping

![스크린샷 2023-06-10 오전 11.39.27.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_11.39.27.png)

- flip의 타입: `{x: real, y: real, color: String} -> {x: real, y: real}`
- distMoved의 인자 f 타입:  `{x: real, y: real} -> {x: real, y: real}`

**→ 얘는 안됨!! unsound**

 `if ta <: tb then ta→t <: tb → t` 는 허용하면 안됨

![스크린샷 2023-06-10 오전 11.41.25.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_11.41.25.png)

- flip의 타입: `{x: real} -> {x: real, y: real}`
- distMoved의 인자 f 타입:  `{x: real, y: real} -> {x: real, y: real}`
    - 받아야하는 것보다 적게 보낸 건데 상관없음. 해당 함수안에는 y를 접근하지 않으니까
    

→ 이건 가능: `if tb <: ta then ta→t <: tb→t`

- function은 *arugment를 원하는 것보다 적게 받아도 됨*
- Argument type are *contravarient(순서가 반대)*

### Can do both

![스크린샷 2023-06-10 오전 11.49.35.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_11.49.35.png)

- flip의 타입: `{x: real} -> {x: real, y: real, color: String}`
- distMoved의 인자 f 타입:  `{x: real, y: real} -> {x: real, y: real}`
- `if then t3<:t1, t2<:t4 then t1 -> t2 <: t3 -> t4`

### Conclusion

- `if then t3<:t1, t2<:t4 then t1 -> t2 <: t3 -> t4`
    - generality를 유지하면서 soundness를 유지하려면 function subtyping은 argument는 contravariant하고 result에는 covariant
- 사람들이 실수로 covaraint argument가 괜찮다고 생각한대

### 3) Subtyping and Generics

Q. 언어는 제너릭과 subtyping 모두 지원가능해?

A. c++, java 모두 가능!!

→`Any type t1 <: any type t2`도  가능: **bounded polymorphism**

- t1,t2가 제너릭인데도 subtype가 가능

### Bounded polymorphism

![스크린샷 2023-06-10 오후 12.00.06.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.00.06.png)

Q. 여기에 List<ColorPoint>를 보내고 List<ColorPoint>를 받을 수 있을까?

A. List에서는 안되지만 자바 arrays 타입에서는 에러가 나지 않을 거임 (List는 flexible arrays같은 거)

- array는 depth subtyping을 허용하기에 통과되지만 아까같이 mutation이 있다면 문제 날 수 있음
- list에서 prevent하지 않음
    - non color point가 있는 리스트를 return하는 것
    - add non color point를 넣음으로써 pts를 수정하는 것
    
    → 근데 color point라고 생각하니까 쓸 수 있음
    

### Generics?

![스크린샷 2023-06-10 오후 12.10.06.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.10.06.png)

- generic을 쓴다면 계산할 때 p.distance 함수를 불러야 하는데 T가 되면 Point가 아닌 애도 들어가니까 애는 안됨!!
- 타입 캐스팅도 있지만 그러면 unsound가 될거임

### Bounds

![스크린샷 2023-06-10 오후 12.10.53.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.10.53.png)

- T를 받지만 모든 T는 아니고 subclass인 애들만 받을 수 있게 제한을 두자!!
- callee는 T<: Point을 가정하기에 distance를 부를 수 있음
- calle는 List<T>를 리턴하기에 pts에 들어있는 점들이 들어갈 것

→ 그렇게 한다면 colorpoint여도 instantiate가능해짐!!

![스크린샷 2023-06-10 오후 12.13.41.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.13.41.png)

cf. subtyping in array는 완전 못했지만 generic은 잘 동작한대

java는 이전 버전과의 호환성을 위해 use cast to get around the static checking with generics을 사용

---

# Last-Topic Equivalence

프로그래머는 equivalent of code를 항상 생각함

두개의 코드가 동일하다면 좀 더 나은 애로 바꿀 수 있음

- *more careful look at what two pieces of code are equivalent*

### Equivalence

- 필요성
    - code maintenance: can i simplify this code?
    - backward compatibility: can i add features without change how any old features work?
    - optimization: can i make this code faster?
    - abstraction: can an external client tell i made this change? == beautiful code

cf. 펄언어는 너무 나쁜 점이 많대…? 그래서 펄 4, 펄 6사이 차이가 많음(backward compatibility가 안됨)그래서 파이썬한테 개밀렸대… 

### Definition

- equivalent하려면
    - produce equivalent result
    - have the same termination behavior
    - mutate non-local memory in the same way
        - global a,b,c를 mutate하고 다른 애는 global c,b,a라면 걘 다름
    - do the same input/outpute
    - rasie the same exceptions
- equivalent가 같은지 비교하기 좀 더 쉬울려면
    - complexity가 작아야 비교하기 쉬움 즉, argument가 작아야 함
    - little or no side effect이 쉬움: mutation, input/output, exception

### Example

1. variable look up

![스크린샷 2023-06-10 오후 12.18.54.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.18.54.png)

![f가 side effect이 없으면 equivalent 아닐수도 있기 때문에 not equivalent ](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.19.04.png)

f가 side effect이 없으면 equivalent 아닐수도 있기 때문에 not equivalent 

- ex) g((gn i ⇒ print “hi”; i), 7)
1. 변수의 순서만 다른데 얘는 같다면?? 
    
    ![스크린샷 2023-06-10 오후 12.20.16.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.20.16.png)
    
    - g,h가 raise exception, side effect(print, update state …)이 없으면 equivalent
    - mutation을 한다면 값이 다르게 될거임 혹은 하나는 mutation이 있고 하나은 Exception한다면?? 결과가 다르게 될 거임
2. syntatic sugar
    
    ![스크린샷 2023-06-10 오후 12.22.06.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.22.06.png)
    
    - 단 evaluation 순서가 다르면 not equivalent
        
        ![스크린샷 2023-06-10 오후 12.22.35.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.22.35.png)
        

### Standard equivalence

1. bound varaible == local varaible을 의미, 이름 바꾼다고 달라지지 않음
    
    ![스크린샷 2023-06-10 오후 12.23.12.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.23.12.png)
    
    - 단, refer된 같은 이름으로 바꾸는 건 안됨
        
        ![스크린샷 2023-06-10 오후 12.23.45.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.23.45.png)
        
2. helper 함수가 없어도 의미가 같다면 동일한 함수
    
    ![스크린샷 2023-06-10 오후 12.24.11.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.24.11.png)
    
    - 단, environment를 주의할 것
        
        ![스크린샷 2023-06-10 오후 12.24.38.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.24.38.png)
        
3. 불필요한 function wrapping을 없애도 동일한 함수
    
    ![스크린샷 2023-06-10 오후 12.25.19.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.25.19.png)
    
    - 하지만 side effect가 부르는 함수가 있다면 주의해야 함
        
        ![스크린샷 2023-06-10 오후 12.25.47.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.25.47.png)
        
        - 왼쪽은 evaluate가 안된거고 오른쪽은 evaluate되었기 때문에 왼쪽은 프린트 안되고 오른쪽은 프린트 됨!! 따라서 다름

### One more

안중요함

- type을 무시한다면 ML let binding은 이렇게 syntatic sugar로 익명함수를 바꾼다
    
    ![스크린샷 2023-06-10 오후 12.26.33.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.26.33.png)
    
    - 다른 경우가 있긴 함
        
        ![스크린샷 2023-06-10 오후 12.27.21.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.27.21.png)
        

### What about performance?

![스크린샷 2023-06-10 오후 12.27.55.png](Lec8%20Type%20Inference,%20Subtyping%20&%20equivalence%20d018e111f0df4844ae4c3369e6f8729d/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.27.55.png)

- 왼쪽이 bad max, 왜냐면 매번 2번씩 호출하기 때문에 지수함수적으로 호출의 수가 늘어남

### Difference definintion for different jobs

equivialence에 3가지가 존재함, 이 세가지는 standard concept이 아니긴 하지만 프로그래머가 항상 사용하는 거임

- **PL equivalence**
    - given same input same output and effects
    - semantic of algorithm이 같은지 판단
    - 장점- replace 가능
    - 단점- 성능을 고려하지 않음
- **asymptotic equivalence**
    - ignore constant factor 빅오가 같으면 같다고 봄
    - constant값은 무시하고 behavior를 examine을 Increasing input data하면서 진행
    - 알고리즘이 인풋이 클때도 잘돌아가는지 확인해줌, 작을 떄에는 비교가 잘안되니까!
    - 장점- algorithm과 effciency for large inputs 에 집중
    - 단점- constant factor를 무시하기에 4배많다 이런 거 무시함
- **systems equivalence**
    - constant overhead를 처리하고 performance tune
    - 장점: faster는 다르고 진짜 better라는 의미
    - 단점: overtuning on wrong, small input , 즉 lead to premature optimization
        - improperly optimize : 최적화했는데 인풋이 작으면 잘돌아가게 되지만 큰 인풋을 넣으면 잘 안돌아갈 수 있음

ex) timsort : 빅오는 다른 애들이랑 같지만 constant factor를 고려했기에 실질적으로 젤 빠름

리스트는 partially sorted→ 이걸 이용한 알고리즘

- 퀵소트가 제일 빠르다고 알려져있음. 왜냐면 평균 빅오가 nlogn
    - 피봇값이 레지스터에 있으니까
    - 레지스터가져오는 속도가 1나노이고 캐싱은 5나노여서 그 constant factor 차이로 성능이 좋은 것임
- mergesort도 캐싱을 하긴 하지만 레지스터에는 없음