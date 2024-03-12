---
title: lec05-First Class Function, Subtyping
categories: ProgrammingLanguage
date: 2024-03-12 22:39:03 +0000
last_modified_at: 2024-03-12 22:39:03 +0000
---

### Functional programming?

- ml에서의 패러다임임. 프로그램 쓸 때 어떤 생각으로 하냐는 의미

![스크린샷 2023-04-15 오후 2.02.45.png](lec05-First%20Class%20Function,%20Subtyping%2096bbd24ce8c44d1a9423c723c0850f02/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-15_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_2.02.45.png)

- mutation을 막음
    - bug가 생길 가능성을 낮춰줌
- functon을 value로 취급
    - ==  pass function as argument just like data
    - *instead of data you can pass function to data*
    - map, reduce같은.. high order function: big data, large data를 처리해야할 때 instead of moving data,  move the code to data: 더 빠름
        - 데이터는 크고 code가 작으니까
        - pass code in data를 할 수 있다
- recursion을 많이 사용
- 수학적인 정의에 가깝게 구현 가능
    - ex) fact

vs. oop는 handle difference in same manner를 설명, 다른 행동을 하는 애들을 같이 하도록 하는 패러다임

- ex) dog, cat → treat same way either dog, cat
- 좋은 이유? : 만약에 mouse를 더하고 싶으면 원래 코드를 수정하지 않고 추가할 수 있으니까!

→ fp는 abstraction을 다르게 할 수 있음

### First class function

- 정의
    - value가 쓸 수 있는 모든 곳에 function을 사용할 수 있다
        - ex) argument, result, part of tuple, bound to variable, carried by datatype constructor or exceptions ….

```jsx
fun double x = 2*x
fun incr x = x+1
val a_tuple = (double,incr,double(incr 7))
```

- 대부분은 다른 함수에서의 argument나 result으로 함수를 많이 사용
    - 이 때 다른 함수를 *higher-order function*이라고 부름
    - common functionality를 factor out하는 강력한 방법 중 하나

ex) all animal eat something 

oop-eat method를 만들어서 상속해서 eat함수를 가지도록 했을 것, extract common property를 해서 factor out 그 속성을 했음. data로 factor out함

→ higher order function은 common function(code)를 factor out하는 것!

### Function Closures

function value와 비슷하지만 한단계 더 간 개념

- laziness를 사용
    - ex) lazy list
- function은 function definition 안에 있는 것도 사용할 수 있지만 밖에서 binding된 변수들을 사용할 수 있음
    - function이 defined된 스콥에서
    
    return the function and then call later, 하지만 밖에 정의된 변수를 여젼히 사용할 수 있다면 아주 파워풀해질 것!
    

→ first class function을 더 강력하게 해줌

- **first class function과 function closure 차이점**
    - first class function과 비슷하지만 function closure은 function + **variable binding not define inside but outside**

### Function as arguments

- 한 함수를 다른  함수의 인자로 보낼 수 있다!

```jsx
fun f (g,... ) = ....g(...)... (*함수를 인자로 보내는 f*)
fun h1... = ...
fun h2... = ...
.....f(h1,...) ....f(h2,..)
```

- f 함수는 g를 인자로 받아서 그 함수를 부를 수 있음
    - f: higher order function, 함수를 인자로 받으니까

→ common code를 factoring out하는데 아주 유용

즉, 비슷한 일을 하는 함수 n개를 n개의 다른 작은 function만을 argument로 보내서 처리하는 한개의 함수로 대체할 수 있다!!

ex) n similar function, for loop는 같은데 안에 하는 일이 다른 경우

→ for loop를 다른 데 두고 body를 pass해서 실행

```jsx
fun n_times(f,n,x) =  
	if n=0
	then x
	else f(n_times(f,n-1,x)) (*tail recursive아님! tail call이 아니여서*)

fun double x = x+x
fun increment x = x+1
val x1 = n_times(double,4,7)
val x1 = n_times(increment,4,7)
val x1 = n_times(tl,2,[4,8,12,16])

fun double_n_times(n,x) = n_times(double,n,x)
fun nth_tail(n,x) = n_times(tl,n,x);
```

- n_times의 타입
    - n=0이 있으니까 int이고 f의 리턴이 n_times의 리턴이니까 둘이 같은데 n_times의 결과를 f의 인자에 넣으니까 n_times의 리턴과 x, f의 인자도 같게 됨
    - (’a → ‘a) * int * ‘a → ‘a
- n_times는 tail recursive한가?
    - Tail recursive가 아님. 왜냐면 function call e1 e2이고 recursion이 e2이기에 리턴해도 해야할 일이 있으니까 tail recursive가 아님
    - 이런걸 tail recursive로 하려면??? ->  (n_times (f, n-1, f x))

Q. c++함수 포인터와 first class function과 다른점?

A. 함수포인터는 first class function과 거의 같지만 closure은 아님, binding이 안되면 할 수 있는 게 제한됨. 다만 function pointer는 Low level이여서 잘못동작할 수도 있다

### Relation to types

- 고차함수는 대부분 polymorphic type으로 *generic이고 reusable* 인데 그 이유는 다양하게 작동하기 위함
    - 물론 아닌 고차함수도 존재하긴 함!
    - 또한 non-higher-order function(first-order, 즉 매개변수로 함수를 받지 않는 함수)의 경우에도 polymorphic한 경우도 존재함

→ higher order를 더 유용하게 하기 위해서는 generic type인게 좋음

<aside>
✅ higher order 함수는 함수를 인자로 받아서 하는 함수인 것! 헷갈리지 말자! first class function은 변수로 쓸 수 있는 모든 함수를 의미

</aside>

![스크린샷 2023-04-15 오후 2.54.09.png](lec05-First%20Class%20Function,%20Subtyping%2096bbd24ce8c44d1a9423c723c0850f02/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-15_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_2.54.09.png)

→ x가 int면 해당 함수는 ‘a에서 int로 instantiate되고 x가 int list면 해당함수는 ‘a에서 int list로 instantiate된다 : 즉, polymorphism이 일어나 더욱 유용해짐!!

### Polymorphism and higher-order functions

- 많은 고차함수들은 some type에 대해 재사용가능하기 때문에 Polymorphic임
- some polymorphic function은 not higher-order function인 경우 존재
    - ex) length: ‘a list → int
- some higher order function이지만 polymorphic하지 않는 경우도 존재

```jsx
fun times_until_0(f,x) =
	if x=0 then 0 else 1+time_until_0(f,f x)
```

### Anonymous function

- 함수를 정의할 때 이름을 정하기 어렵거나 정할 필요도 없는 경우 이름 없이 선언

```jsx
(* naive한 방법 *)
fun triple x = 3*x
fun triple_n_times (n,x) = n_times(triple, n,x)

(*let in end 안에 함수 선언*)
fun triple_n_times(n,x)= 
let fun trip y = 3*y
in n_times(trip,n,x)
end

(* 더 작게 let in end 안에 함수 선언*)
fun triple_n_times(n,x) =
n_times(let fun trip y = 3*y in trip end, n ,x)

(* function binding은 Expression이 아니므로 파라미터에 넣는 건 안됨!! *)
fun triple_n_times(n,x) =
n_times((fun trip y = 3*y), n ,x)

(* 익명함수를 쓰자! *)
fun triple_n_times(n,x) =
n_times(**(fn y => 3*y)**, n ,x)
```

⇒ **anonymous function**: 함수를 선언하면서 바로 호출

- expression이기에 argument로 pass 가능
- fun → fn, = → ⇒, 이름 없음(그냥 argument pattern) 의 차이점
- 사용하는 곳
    - higher order function의 인자로 주로 많이 사용됨

<aside>
✅ 단, 익명함수를 recursive로 하려면 할 수 없음. 이름이 없으니까!

</aside>

→ 따라서 익명함수를 variable binding을 하게 하면 function binding과 동일함(fun binding이 syntatic sugar임을 알 수 있음!!(val binding + anonymous function))

```jsx
fun triple x = 3*x
val triple = fn y => 3 * y
```

```cpp
val x1' = n_times(double, 4,3); // 여러번 사용될 경우 이게 나음
val x1' = n_times(fn x-> x+x, 4,3); // 한번만 쓰면 이게 나음

if x then true else false  // 이렇게 하지 말고
x // 이렇게 할 것

n_tiems((fn y => tl y), 3, x) //마찬가지 그냥 함수만 호출하는 거라면 이렇게 하지 말고
n_times(tl,3,x) // 이렇게 할 것!
```

### Map

- 약간의 공간을 절약하고 더 중요한 것은 수행 중인 작업을 전달함
- 각 요소에 f함수를 적용하는 것
    - xs = [x1,x2…] ⇒ [f(x1), f(x2) …. ]

```cpp
fun map(f,xs) = 
case xs of
[] => []
|x::xs' => f x :: map(f,xs');

val intlist = [1,2,3,4,5];
map(fn x => x mod 2, intlist); // [1,0,1,0,1], 여기는 알파 베타 모두 int임
List.map (fn x => x mod 2) intlist; // 같은 의미를 curry function으로 
```

- ML에는 List.map이라는 비슷한 predefined curry function 존재

### Filter

- XS 리스트에서 f함수가 true인 애들만 필터링하는 함수

```cpp
fun filter(f,xs) = 
case xs of
  [] => []
  |x::xs' => if f x then x::filter(f,xs') else filter(f,xs');

filter((fn x => x mod 2=0), intlist) ; // [2,4]
List.filter (fn x => x mod 2 = 0) intlist;
```

- ML에는 List.filter이라는 비슷한 predefined curry function 존재

Q. 고차함수가 데이터를 전달하냐 함수를 전달하냐인 거 같은데 왜 쓰지? 

A. 리스트를 반복하면서 해야할 일이 많을 때 그부분을 extract해서 모듈러한거다. 데이터를 캡슐화하는 건 많은데 for loop 안을 모듈러화해서 하는 거

cf. 알파 베타 순서는 먼저 나오는 generic type부터 알파 베타 타입인거고 그냥 이름임.

### Generalizaing

- first class function
    - 한 함수를 다른 함수의 인자로 보낼 수 있음
        - ex) process number or list
    - function을 argumente로 보낼 수 있음
    - data structure에 function을 넣을 수 있음
    - result로 return function을 할 수 있음
    - higher-order function을 쓸 수 있게 되어서 data structure을 순회할 수 있음

→ what to compute with를 abstract하고 싶다면 유용하게 사용 가능!

### Returning functions

```jsx
fun double_or_triple f = 
if f 7 
then fn x => 2 *x
else fn x => 3 * x
```

- 이 때 REPL은 위 함수의 타입을 괄호 없이 (int → bool) → int → int로 표시
    - last to first여서 필요 없음
    - ex) t1→t2→t3→t4 == (t1 → (t2 → (t3 → t4)))

### Other data structures

higher order function은 리스트나 숫자뿐만 아니라 own data type에도 적용가능하다!

```cpp
datatype expr = Constant of int 
| Negate of expr
| Add of expr * expr
| Multiply of expr * expr;

(*higher order function 사용 x *)
fun all_even(e) = 
case e of 
Constant i => i mod 2 = 0
| Negate e2 => all_even(e2)
| Add (e1, e2) => all_even(e1) andalso all_even(e2)
| Multiply (e1, e2) => all_even(e1) andalso all_even(e2);

fun all_odd(e) = 
case e of 
Constant i => i mod 2 = 1
| Negate e2 => all_odd(e2)
| Add (e1, e2) => all_odd(e1) andalso all_odd(e2)
| Multiply (e1, e2) => all_odd(e1) andalso all_odd(e2);

 (*두개를 합쳐보쟝!, 같은 거를 묶고 다른 거만 함수로 넘길 것*)
fun all(test,e) =
case e of 
Constant i => test(i)
| Negate e2 => all(test, e2)
| Add (e1, e2) => all(test, e1) andalso all(test, e2)
| Multiply (e1, e2) => all(test, e1) andalso all(test, e2)

fun all_even(e) = all(fn x=> (x mod 2) = 0, e)
fun all_odd(e) = all(fn x=> (x mod 2) = 1, e)

(*이건 해보래 *)
fun any(test, e) = 
case e of
Constant(e1) => test(e1)
  | Negate(e1) => any (test,e1)
  | Add (e1,e2) => any (test,e1) orelse any (test,e2)
  | Multiply(e1,e2) => any (test,e1) orelse any (test,e2);

fun any_even(e) = any(fn x=> (x mod 2) = 0, e)
fun any_odd(e) = any(fn x=> (x mod 2) = 1, e)

val a = Add(Negate(Constant 2), Multiply(Constant(8), Negate(Constant(3))));
any(fn x => x mod 2 = 0 ,a); // true
all_odd(a); //false
all_even(a); // false 
any_even(a);// true
any_odd(a);// true
```

→ redundency를 제거할 수 있으니까 higher order function을 사용하쟝!

oop는 상속으로 해결하는 거고 fp는 higher order function으로 해결하는 것

### Type Synonyms == type alias

int*int*int를 date로 부르고 싶다면?? 

```jsx
type date = int * int * int;
```

```cpp
(* 이건 내가 그냥 든 예시 *)
datatype suit = Club | Diamod | Heart | Spade;
datatype card_value = Jack | Queen | King | Ace | Num of int;
datatype rank = Rank;

(*datatype으로 suit * rank 타입을 만드는 법*)
datatype card_datatype = Card of suit * rank;
val a: card_datatype = **Card(Club, Rank)**; (***card** 타입*)

(*type으로 suit * rank의 별칭을 만드는 법*)
type card_type = suit * rank;
val a: card_type = **(Club, Rank)**; (*card2는 단지 별칭이기 때문에 실질적인 type은 **suit * rank**!*)

fun printSuit(x: **card_datatype**) =  
case x of
  Card(s, _) => s;
printSuit(Card(Club, Rank));

fun printSuit(x: **card_type**) =  #1 x;
printSuit(Club,Rank);
```

**type vs datatype**

- datatype: 새로운 Type을 생성
- type: 새로운 데이터타입을 만들지말고 별칭 생성

Q. 왜 type을 사용하면 유용할까??

### Type Generality

- generic type

```cpp
fun append(xs, ys) = 
case xs of
[] => ys
|a::b  => a::append(b,ys);
```

- string list라는 타입을 쓰다가 타입을 지워도 여전히 동일하게 작동하지만 함수의 타입이 ‘a list로 바뀌게 됨

Q. string list이 ‘a list로 바뀌어도 왜 될까??

A.  ‘a가 string의 general version이기에 string은 ‘a의 subset이 됨

*→ more general types can be used as any less general type*

**more general rule**

> t1을 take한 후에 type variable로 일관되게 대체해서 t2를 얻을 수 있다면
⇒  t1이 t2보다 더 general하다
> 
- t1이 더 일반적이여서 t1에서 t2로 바꾼 후 실행하면됨
- 앞에 예시에서는 t1: ‘a, t2: string 이 되고 t1을 type value consistently하게 replace한 후 ‘a를 string으로 모두 바꿀 수 있으니까 general하다라고 볼 수 있다.

<aside>
🌵 t1이 t2보다 general, t2가 t1보다 general 둘 다 안될 수도 있음!
ex) Int list, string list는 포함되는게 아니라 그냥 다른 두개임

</aside>

cf.int랑 real은 type generality와 subtype 관계 모두 없음. 

### Subtype 좀 더 semantic

> S와 T 타입이 있는데 S가 T의 subtype이라면(S <: T)
 S의 인스턴스는 T 인스턴스가 쓰이는 어느 곳에서든 safely used가 가능
> 
- ml은 subclass는 없고 subtype과 generic type만 제공
- c++은 subclass(class inheritance)과 generic type(template) 제공

**subtype vs subclass in semantic**

ex) 인스턴스 t로 쓴 코드(exception 없었음), 근데 거기에 s를 넣게 된다면?? s 안에 있던 메소드에서는 runtime exception을 던진다면?? 걔는 subtype처럼 safe하다라고 볼 수 없음!

→ subtype과 subclass가 다름을 알 수 있음

ex) subtype관계: record와 tuple

![스크린샷 2023-04-15 오후 4.41.10.png](lec05-First%20Class%20Function,%20Subtyping%2096bbd24ce8c44d1a9423c723c0850f02/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-15_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_4.41.10.png)

### Subtype example

자바 디자인할때에는 잘못했었음 array 타입이 잘못되었는데… 이건 나중에 커버할거래

![위가 type generality, 아래가 subtype](lec05-First%20Class%20Function,%20Subtyping%2096bbd24ce8c44d1a9423c723c0850f02/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-15_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_4.06.16.png)

위가 type generality, 아래가 subtype

![스크린샷 2023-04-15 오후 4.06.29.png](lec05-First%20Class%20Function,%20Subtyping%2096bbd24ce8c44d1a9423c723c0850f02/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-15_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_4.06.29.png)