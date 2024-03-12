---
title: Lecture 03-Record, Datatypes, Case
categories: ProgrammingLanguage
date: 2024-03-12 22:39:04 +0000
last_modified_at: 2024-03-12 22:39:04 +0000
---

### Five different things

![스크린샷 2023-04-14 오후 5.36.31.png](Lecture%2003-Record,%20Datatypes,%20Case%200b12fd32ada8437691cf7d2da39d667a/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.36.31.png)

→ semantics, idiom을 집중적으로 볼 것

### 3 most important type building  block

| each of | t value는 t1,t2,t3…tn의 value를 가짐 | tuple ex) int * bool은 int와 bool을 모두 가짐 |
| --- | --- | --- |
| one of | t value는 t1,t2,t3…tn 중 하나의 value를 가짐 | option ex) int or contain no data |
| self reference | t value는 다른 t value를 refer할 수 있다. |  |
- List는 세가지 building block을 모두 사용
    - int list는 (int와 다른 int list)나 no data일 수 있다.
        - head::tail or []

### Records

- c++ struct과 매우 비슷
    - collection of value

![스크린샷 2023-04-14 오후 5.46.35.png](Lecture%2003-Record,%20Datatypes,%20Case%200b12fd32ada8437691cf7d2da39d667a/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.46.35.png)

![스크린샷 2023-04-14 오후 5.46.08.png](Lecture%2003-Record,%20Datatypes,%20Case%200b12fd32ada8437691cf7d2da39d667a/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.46.08.png)

- record values have field holding values

```cpp
{f1 = v1, f2 = v2 ... , fn = vn}
```

- record types have fields holding types

```cpp
{f1: t1, f2: t2 ... , fn: tn}
```

- field의 순서는 상관없음. REPL은 알파벳 순서로 나열하기는 함

**build the records**

**access the records**

```cpp
{f1 = e1, f2 = e2 ... , fn = en}
```

```cpp
#fieldName e
```

- 각 필드에 접근하는 함수는 자동으로 만들어짐
- record type value는 field 이름과 변수를 {}안에 넣어서 가능

```cpp
{name= "Amelia", id= 41123 - 12}
-> evaluate to {id=41111, name = "Amelia"}
-> type is {id: int, name: string}
-> get field #id x or #name x

val x = {name= "subin", id = 3+43};
#name x;
#id x;
#hi x; //안됨
```

### By name vs By position

```cpp
(4,7,9) // tuple
```

- tuple이 좀 더 간단한편

```cpp
{f=4, g=7, h=9}; // record
```

- record는 어떤 값이 있는지 좀 더 쉽게 찾기 위해 proper name을 지정한 것
- record는 어디있는지 좀 더 쉽게 기억할 수 있음

→ 뭘 고르든 상과없지만 field가 많다면 record가 좋은 선택인 편

- construct’s syntax is whether to refer to things by position(field) or by name(record)
    - function call도 비슷한 부분 존재(아닌 언어도 존재)
        - caller는 position을 이용
        - function callee는 variables를 사용
    
    → 그냥 취향 차이, calling은 튜플처럼 선언은 record처럼 하는 경향이 있음
    

### truth about tuples

> tuple은 certain record를 쓰는 다른 방법일 뿐!
> 
- (e1,…,en)은 {1=e1,2=e2, …n=en}과 사실상 같은 거임(value)
- t1*t2…*tn은 {1:t1, 2:t2, …n: tn}과 사실상 같은 거(type)

→ Tuple은 사실 internal에서는 record 타입으로 접근하는 거임을 알 수 있음!

![스크린샷 2023-04-14 오후 6.01.58.png](Lecture%2003-Record,%20Datatypes,%20Case%200b12fd32ada8437691cf7d2da39d667a/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.01.58.png)

![스크린샷 2023-04-14 오후 6.02.25.png](Lecture%2003-Record,%20Datatypes,%20Case%200b12fd32ada8437691cf7d2da39d667a/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.02.25.png)

cf.하지만 record의 field를 1,2,3…으로 하는 거는 좋지 못한 스타일 {1=3,2=7,3=9}

### syntatic sugar

> *Tuples are just syntatic sugar for records with fields named 1,2,….n*
> 

ex) tuple은 좀 더 record type을 쉽게 접근하는 타입이라고 보면 됨. field 이름이 숫자인 record

- syntatc만 다르고 semantic은 동일

→ syntatic sugar는 언어를 좀더 쉽게 이해하고 쉽게 구현할 수 있도록 도와준다 🙂

```cpp
int a = 0;
a = a+1;
a++;
++a;//사실 a++; ++a;는 의미가 다르니까 완전히 맞는 예제는 아니지만 
			// 뭐…그래두 쉽게 쓸 수 있다는 점에서 syntatic sugar
a+= 1; //이런게 다 syntatic sugar같은 거라고 함
```

- ml에서의 syntatic sugar: andalso, orelse, if then else

### boolean operation

![스크린샷 2023-04-14 오후 6.06.06.png](Lecture%2003-Record,%20Datatypes,%20Case%200b12fd32ada8437691cf7d2da39d667a/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.06.06.png)

- not은 predefined function에 해당
- andalso, orelse는 built-in operation에 해당 따라서 function구현하는 거처럼 구현된 게 아님
    - 또한 short-circuit evaluation 제공 → 또한 e1,e2를 모두 evaluate하는 게 아님
    - ex) e1 andalso e2: e1이 false면 e2 evaluate 안함
    - ex) e1 orelse e2: e1이 true면 e2 evaluate 안함
    - e2에 runtime error가 있다고 해도 e1으로 evaluate된다면 에러 안남: short-circuit, 전체가 evlaute가 아니라 일부만 evaluate되는 것을 의미

cf. and랑 andalso 헷갈리면 안됨!! 완전다른거니까 bool은 andalso써야 함

![스크린샷 2023-04-14 오후 6.13.40.png](Lecture%2003-Record,%20Datatypes,%20Case%200b12fd32ada8437691cf7d2da39d667a/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.13.40.png)

→ andalso, orelse를 if의 syntatic sugar로 사용 가능

![스크린샷 2023-04-14 오후 6.14.51.png](Lecture%2003-Record,%20Datatypes,%20Case%200b12fd32ada8437691cf7d2da39d667a/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.14.51.png)

<aside>
💡 가능한 간단한 language를 쓸 것 불필요한 코드를 작성하지 말 것!
만약에 큰 프로그램에서 쓰게 된다면 이런 일이 일어날 수 있음!! 최대한 간단하게 써라~~

</aside>

### Datatype binding

- strange way to make *one of types*
    - one of types == define something one of either int, float ….

```cpp
datatype mytype = TwoInts of int * int
									| Str of string
									| Pizza
```

- Special Keyword: datatype
- mytype은 프로그래머가 주는 해당 타입의 이름
- Constructor(혹은 tag라고 부름): TwoInts, Str, Pizza
- 이 타입은 either 저 세개 중에 하나를 가졌으면 좋겠다!

⇒ 이 mytype은 can have tuple or string or have nothing이지만 태그이름이 pizza일 수 있다

**binding**

- environment에 new type인 mytype을 추가
- environment에 constructor을 추가 : TwoInts, Str, and Pizza
    - constructor는 new type of value를 만드는 함수이거나 new type value임!
    - twoint라는 생성자는 argument로 int * int를 받음 나머지도 동일
- 타입이 mytype인 어떤 value들은 저 세가지 생성자 중에서 하나 선정되어서 생성됨
    - 해당 value는 어떤 생성자인지 나타내는 “*태그”*를 가짐
    - 해당 태그에 “*대응되는 데이터”*들을 가지고 있음

```cpp
(*datatype*)
datatype mytype = TwoInts of int * int
              | Str of string
              | Pizza;
TwoInts(3+4,5+4); -> evaluate TwoInts(7,9)
Str(if true then "hi" else "bye"); -> Str("hi")
Pizza; -> value
```

![스크린샷 2023-04-14 오후 6.22.57.png](Lecture%2003-Record,%20Datatypes,%20Case%200b12fd32ada8437691cf7d2da39d667a/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.22.57.png)

```cpp
(*datatype*)
datatype student = First of string * int
| Second of string * int
| Etc;
First;
Second;
Etc;
val it = First("john", 1234);
val x = Second("jane", 123);
```

![Untitled](/assets/2024-03-12-Lecture-03-Record-Datatypes-Case/Untitled.png)

### Using them

datatype를 만들었으니 이제 access해보자!

1. check what *variant* it is(어떤 생성자로 만들어졌는지?)
    1. ex) list - null, t option - isSome
2. extract the *data*(variant가 가지고 있는 데이터)
    1. ex) list - hd, tl  t optiona - valOf

### Case

- ML은 위에 있는 acess one of value하는 두과정을 case expression + pattern matching으로 합침
    - switch와 비슷하게 생겼지만 완젼 다름

```cpp
fun f x = 
case x of (* x인 datatype을 pattern matching함*)
	Pizza => 3
	| TwoInts(i1,i2) => i1 + i2
	| Str s => String.size s
```

- 패턴마다 | 로 구별
- ⇒는 만약에 저 변수가 저 pattern에 매칭된다면 오른쪽에 있는 expression을 실행하라!
- multi-branch은 variant를 기준으로 branch를 고름
- extract data한 후 해당 브랜치에 local variable에 바인딩함

| syntax | case e0 of
p1 ⇒ e1
|p2 ⇒ e2
…
|pn ⇒ en |
| --- | --- |
| type-checking | all branch는 같은 타입이어야 한다, arrow 옆에 있는 타입도 모두 같아야 함 |
| evaluation | case of 사이에 있는 expression을 evaluate한 후에 맞는 브랜치를 evaluate |
- 다양하게 활용할 수 있지만 오늘은 변수의 생성자 태깅을 찾는 예제로 사용할 것
- pattern는 expression이 아니지만 그렇게 보임
    
    → evaluate하지 않음!
    

### why this way is better

1. case를 까먹지 않게 한다
    1. ml은 타입체킹을 하면서 all of variant 이 모두 같은 타입이 아니라면 컴파일도 하지 못하게 됨
2. case를 중복할 일이 없다
    1. 중복된 케이스는 없음. two parent가 같다면 에러를 뱉음, switch는 안될수도
    2. `Pattern matching is not exhaustive.`
3. variant correctly test하는 것을 까먹지 않게 하고 exception을 받을 수 있음
    1. 중요한 케이스를 잊지 않을 수 있음.(이전 과제에서 list를 썼었는데 empty여도 접근하는 경우가 있었음. pattern matching을 하게 되면 list가 비었는지 체킹할 수 있음)
4. 시각적으로 좀 더 읽기 쉽고 better overview를 제공

```cpp
(*case pattern matching*)
val x = First("subihn", 42);

case x of
First(name,id) => id 
  |Second(name,id) => id
(*Etc 생성자가 존재하기에 워닝이 뜨는 것*)
```

![Untitled](/assets/2024-03-12-Lecture-03-Record-Datatypes-Case/Untitled%201.png)

### Useful examples

ex)  card

```cpp
datatype suit = Club | Diamond | Heart | Spade
datatype card_value = Jack | Queen | King 
                    | Ace | Num of int
datatype card =  Card of suit * card_value
(*
datatype card = Jack of suit |
                Queen of suit |
                King of suit |
                Ace of suit |
                Num of suit * int
*)
val hands = [Card(Club, Jack), Card(Club, Num(10)), Card(Club, Ace)]
val hands2 - [Card(Club, Jack), Card(Diamond, Num(10)), Card(Club, Ac
e)7
val hands3 - [Card(Di amond, Num(10)), Card(CLub, Ace), Card(Club, Jac
k)7
val hands4 = [Card(Diamond, Num(10)), Card(Club, Ace), Card(Club, Jac
2, Card(Spade, Ace)]

(*assume hand is not empty *)
	returns true if suits of all cards are same
e.g. [(Club, 10), (Club, King), (Club, Ace)] ==>
==› true
[(Club, 10), (Diamond, King)] ==> false
datatype card = Card of suit * card_value *)
```

ex) identifying real-world things/people

: student data를 저장해야하는데 id를 가진 사람도 있고 없는 사람도 있음

```cpp
datatype id = StudentNum of int
							| Name of string * string option * string;
```

- record type으로도 할 수 있음. (one of type인 곳에 each of type으로 만드는 건 bad style 😢)
    
    ```cpp
    {student_num: int, first: string, middle: string option, last: string}
    ```
    
    - id가 없는 사람은  student_num을 -1로 주게 할 수도 있지만 그건 not good style
    - 모든 장소에서 -1인지 체크해야 하고 만약에 깜빡하면 문제가 생길 것, 그리고 모든 코드에서 그걸 체크해야한다는 단점 존재
    
    cf. oop라면 student를 상속해서 id만 있는 class, name만 있는 class 상속받는 방식으로 해결할 수 있음. 하나의 class로 하면 매번 체크해야하니까 좋은 방식이 아님
    
    → student_name을 int가 아닌 int option으로 변경한다면 아까보다는 낫기는 함 -1보다는 isSome, valOf이 낫긴 함
    

### Expression Trees(using self-reference)

```cpp
datatype exp = Constant of int
               | Negate of exp
               | Add of exp * exp
               | Multiply of exp * exp
               | If of bool * exp * exp;
```

```cpp
Add(Constant(19), Negate(Constant(4)))
```

![스크린샷 2023-04-14 오후 8.34.26.png](Lecture%2003-Record,%20Datatypes,%20Case%200b12fd32ada8437691cf7d2da39d667a/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_8.34.26.png)

```cpp
(* simple example of exp tree *)
val add = Add(Constant 10, Constant ~11) // -1
(* creating exp tree*)
val ifExpr = If(false, 
								Add(Constant 10, Constant 11),
								Multiply(Constant 1, Constant 42)) //42
(* true ==> 21, false => 42*)

(*eval fun*)
fun eval(e)=
case e of
Constant(i) =>i
|Negate(e) => **~(eval(e)) // eval(~e) 이거 아닙니다~ ~뒤에 eval바로 올 수 없음 괄호 필요!**
|Add(e1,e2) =>  eval(e1) + eval(e2)
|Multiply(e1,e2) => eval(e1) * eval(e2)
|If(b,e1,e2) => if b then eval(e1) else eval(e2)

(*max_constant*)
fun max_constant(e)=
	case e of
		Constant(i) =>i
		|Negate(e) => max_constant**(e) // eval(~e) 이거 아닙니다~ ~뒤에 eval바로 올 수 없음 괄호 필요!**
		|Add(e1,e2) =>  if max_constant(e1) < max_constant(e2) then max_constant(e2) else max_constant(e1)
		|Multiply(e1,e2) => if max_constant(e1) < max_constant(e2) then max_constant(e2) else max_constant(e1)
		|If(_,e1,e2) =>if max_constant(e1) < max_constant(e2) then max_constant(e2) else max_constant(e1)

fun max_constant2(e) = 
let fun max_of_two(a: int, b: int) =
	if a>b then a else b
in 
	case e of
	Constant(i) => i
	| Negate e1 => max_constant(e1)
	| Add(e1, e2) => max_of_two(max_constant2(e1), max_constant2 (e2))
	| Multiply(e1, e2) => max_of_two(max_constant2(e1),max_constant2(e2))
	| If (_, e1, e2) => max_of_two(max_constant2 (e1),max_constant2 (e2))
end;

fun max_constant3 (e: exp) =
  case e of
    Constant(i) => i
  | Negate e1 => max_constant2 (e1)
  | Add(e1, e2) => **Int.max(max_constant3 e1, max_constant3 e2)**
  | Multiply(e1, e2) => Int.max(max_constant3 e1, max_constant3 e2)
  | If (_, e1, e2) => Int.max(max_constant3 e1, max_constant3 e2)

(* count_adds: exp -> int *)
fun count_adds(e: exp) =
   case e of
    Constant(i) => 0
  | Negate e1 => count_adds(e1)
  | Add(e1, e2) => 1+count_adds(e1)+count_adds(e2)
  | Multiply(e1, e2) => count_adds(e1)+count_adds(e2)
  | If (_, e1, e2) => count_adds(e1)+count_adds(e2)
```

- pattern에 변수를 안에서 쓸 수 있지만 필요 없다면 _로 둬서 얘는 아무 변수에도 바인딩되지 않음

cf. recursive하게 계속 부른다면 stack이 너무 많아지지 않을까?? ML에서는 좀 다를 수 있음. 주로 다른 언어에서는 frame object를 다른 곳에 저장하는 경우가 많음. 이 frame object는 Eval함수에서 호출. tail recursion을 한다면 while와 똑같은 recursion이 됨

### Datatype bindings

```cpp
datatype t = C1 of t1 | C2 of t2 | ... | Cn of tn
```

- t type 와 (ti → t) 타입의 constructor ci를 추가
- of t가 없는 constructor는 underlying data가 없는 tag가 됨. 그냥 value

→ t type을 사용하는 Expression이 주어지면 case를 써서 

1. varaint(tag)를 찾기
2. extract underlying data 

```cpp
case e of p1 => e1 | p2 => e2 | ... | pn => en
```

- case expression도 expression이기 때문에 expression이 있을 수 있는 모든 곳에서 사용 가능
- e를 evaluate해서 v
- pi가 v와 맞는 첫번째 패턴이라면 “*environment extended by the match”* 에서 ei를 evaluation한다
    - Pattern Ci(x1, …, xn)은 value ci(v1,…vn)에 매치되고 environment는 x1 → v1, ….xn → vn으로 확장된다
    - 만약에 데이터가 없는 생성자인 Ci같은 거라면?? pattern Ci는 value ci에 매치됨

cf. python에서 case와 같은 패턴매칭인 match라는 구문 존재. 파이썬은 다이나믹이기에 컴파일에 체크하는 파이썬과 다르긴 함

→ order of expression 역시 먼저 e 먼저 한 후에 p1 이 first pattern to match라면 매칭 각각에 바인딩된 변수로 매칭됨

> *p ::= _ | C | x | (p1,…,pn) | {x1=p1,…,xn=pn} | [] | p1::p2| X | X(p)*

→ pattern은 무시될 수도 있고 constant 값일수도 있고 변수 이름일수도 있고 tuple, record, 배열 등등이 될 수 있다!
> 

### Recursive datatypes

위에 봤었던 expression tree처럼 datatype binding을 recursive하게 선언 가능 

ex) linked list

```cpp
datatype my_int_list = Empty 
										| Cons of int * my_int_list
val x = Cons(4,Cons(23,Cons(2008, Empty)))

fun append_my_list(xs, ys) = 
case xs of
empty => ys
| Cons(x,xs') => Cons(x,append_my_list(xs', ys))
```

### 1. options are datatypes

- option도 predefined datatype binding이다
- NONE, SOME 둘다 constructor임 not function!!
- isSome, valOf은 pattern matdching을 쓴다고 볼 수 있음

```cpp
fun inc_or_zero intoption = 
	case intoption of
		NONE => 0
		|SOME i => i+1 ;
inc_or_zero(NONE); // 0
inc_or_zero(SOME 3); // 4
```

### 2. lists are datatypes

- [], ::도 생성자
    - ::은 infix operator or constructor that infix
    - cf. 생성자 이름 % 이런것도 됨 []도 그렇게 만들지 않았을까??

```cpp
fun sum_list xs =
case xs of
	[] => 0
	| x::xs' => x + sum_list xs'
```

```cpp
fun sum_list xs=
if null xs
then 0
else hd xs + sum_list (tl xs)
```

→ null or, hd, tl 을 사용하는 함수도 있지만 33쪽에 있는 함수 구현방식이 좀 더 직관적, empty이고 뭐가 있는지 좀 더 잘보이는 편

```cpp
fun append(xs, ys) = 
case xs of
[] => ys
|x::xs' => x::append(xs',ys)
```

- case expression을 사용할 경우, empty or non empty 두가지 종류가 있다면 extend을 쉽게 할 수 있음. 만약에 xs가 오직 한개 일 때랑 두개 이상일 때랑 null일 때로 바꾼다고 한다면 어떻게 해야할까?

```python
case xs of
	[] => 0
	| x:: [] => 1 // 오직 하나의 element를 가지는 경우
	| x::xs' => 2
-------------------
case xs of
	[] => 0
	| x:: [] => 1 // 오직 하나의 element를 가지는 경우
	| x::y::xs' => 2 // 이게 더 명확

case xs of
	[] => 0
	| x::xs' => 2 // 이게 더 명확
	| x::[] => 1 // 오직 하나의 element를 가지는 경우
-> 이렇게 하면 두번째가 먼저 걸릴 거 같음 마지막이 절대 안걸리게 됨!! match redundant여서 에러가 남
2번째 조건이 3번째조건보다 더 큰 조건이여서 redundant여서 에러가 나게 됨
이전 조건이 같거나 include되었다고 ml에서 에러를 냄
```

### why pattern matching

- 모든 datatype에 유용 : no missing case, no exception for wrong variant
- 시각적으로 케이스를 보기 편하기에 실수를 면할 수 있다
- 하지만 여전히 null, tl, hd는 중요한 함수이긴 함. argument in higher function에선 필요한 개념(map, reduce, filter 등에서는 유용하게 사용될 예정)

이제부터는 다른 부분에서 case expression을 사용하는 거에 대해서 배울 것!

- value binding, function binding에서도 pattern matching을 배울 수 있음.

### Each of types

이 때까지는 one of type에 패턴매칭을 사용했었는데 지금은 each of type(tuple, pair, record)에도 패턴 매칭을 사용해보쟈!

- tuple과 record에서도 역시나 Pattern matching 사용 가능
    - tuple
        - pattern (x1,…,xn) match the  value(v1, ….,vn)
    - record(순서는 reorder)
        - pattern {f1=x1,…,fn=xn} match the value {f1=v1, …, fn = xn}

```python
val x = {name="s", id=42};
case x of
  {name = n, id = 40} => "id is 40"
  | {name = n, id = id} => "id is not 40";
```

```cpp
(* using case expression *)
fun sum_triple triple =
case triple of
(x,y,z) => x+ y+ z;

fun full_name r =
case r of
{first=x, middel=y, last=z} => x ^ " " ^ y ^ " " ^ z;
```

- 좋은 방법은 아님, 왜냐면 single pattern이기 때문에 굳이 좋진 않음

### Val-binding pattern

- val binding은 variable만 쓰는 게 아니라 **pattern**도 쓴다!!

```cpp
val p = e
```

```python
val (x,y) = (42,43);
val y = {name="3", id=42};
val {name=n,id=i} = y;
val (a,_) = (1,2);
val (1,_) = (1,2); // exhaustive 워닝
```

- each of type에 해당하는 모든 데이터를 꺼내는 데 좋다

but 단순히 각 요소를 추출하는 방식으로 pattern을 사용하는 것은 좋지 않음

```cpp
(* using val-binding pattern *)
fun sum_triple triple =
let val (x,y,z) = triple
in x+ y+ z
end

fun full_name r =
let val {first=x, middle=y, last=z}= r
in  x ^ " " ^ y ^ " " ^ z
end
```

### function-argument pattern

- function argument도 pattern으로 일반화 가능

```cpp
fun f p = e
```

```cpp
(* using function-argument pattern *)
fun sum_triple (x,y,z) = x+ y+ z
fun full_name {first=x, middle=y, last=z}= x ^ " " ^ y ^ " " ^ z
```

(정리) case expression → value binding pattern → function argument pattern으로 변환

```python
fun fact(n) = if n= 1 then 1 else n * fact(n-1);

fun fact(n) = case n of 1 => 1 | n' => n' * fact(n'-1);

fun fact(1) = 1 
  | fact(n) = n * fact(n-1);

fun fibo(1) = 1| fibo(2) = 2 | fibo(n) = fibo(n-1) + fibo(n-2);
-> 좀 더 수학적인 식에 가까운 편
```

### Function take only one argument!

```cpp
fun sum_triple (x,y,z) = x+ y+ z
```

← 3개의 값을 가지는 한개의 tuple을 전달하는 함수나 3개의 값을 전달하는 함수나 생긴게 같다?!?!?

⇒ 모든 ml function arugment는 하나의 arugment를 받는 거고 여러개면 그걸 다 묶어서 하나의 tuple로 받는 거임!!! 

cf.

```cpp
fun rotate_left (x,y,z) = (y,z,x)(*argument 3개*)
fun rotate_right t = rotate_left(rotate_left t )(argument 1개)
```

- right함수를 선언할때 tuple에 직접 접근하지 않아도 함수 호출 가능, 튜플을 그래도 가져가는 추상화를 유지할 수 있다는 장점 존재, t 안에 있는 값을 실제로 접근하지 않고 구현할 수 있다~
- zero argument
    - (): unit value, kind of nothing
        
        ex) homework 2에 있는 () → ‘a lazyList 또한 unit type
        

→ function pattern matching generalize가능!!