---
layout: post
title: LECTURE 02-Pair, List, Local bindings, noMutation
date: 2023-06-14 23:25:33 +0000
category: ProgrammingLanguage
---

### Functions as Parameters

- value, value처럼 return과 parameter에 function을 보낼 수 있음

![스크린샷 2023-03-10 오전 10.34.32.png](LECTURE%2002-Pair,%20List,%20Local%20bindings,%20noMutation%2037fa06ee9a114639a88ad91f5c837c02/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-03-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_10.34.32.png)

```swift
fun mult(x: int, y: int) : int = x* y;
fun add(x: int, y: int) : int = x+y;

(*함수를 arugment로 전달*)
fun apply_f(f: int* int -> int, x: int, y: int) = f(x,y); (* f(x+y, x-y);도 가능 *)
apply_f(mult,10,11);
apply_f(add,10,11);

(*함수를 return type으로 *)
fun ret_f(): int*int -> int = mult; **(*argument없어도 ()는 넣어줘야함 아니면 에러남*)**
ret_f()(4,5); **(*ret_f (4,5)하면 안됨!! *)**
```

### Other type

- value들을 합쳐서 새로운 type을 만들수도 있음

**Tuple**

- *fixed number of pieces that may have differenct types*

**List**

- *any number of pieces that all have the same type*

**local binding**

- 편리와 효율성을 위해 필요

## Pair(2-tuples)

**pair:** tuple인데 두개만 가지고 있는 타입을 의미

- **build pairs**

| syntax | (e1,e2)
이 때, e1,e2는 뭐든 상관없음 ex) (1+3, add); |
| --- | --- |
| type-checking | e1의 타입은 t1이고
e2의 타입은 t2이라면
→ pair의 타입은 t1 * t2가 됨 (== function parameter type과 비슷)
cf. (10,false): int * bool ← value는 evaluation할 필요 없이 바로 결과가 나옴 |
| evaluation | e1을 evaluate해서 v1
e2를 evaluate해서 v2
→ 결과는 (v1,v2) |
- **access**

| syntax | #1 e #2 e |
| --- | --- |
| type-checking | e의 타입이 t1 * t2라면
→ #1 e는 t1 타입, #2 e는 t2타입 |
| evaluation | e를 evaluate 한 후에 첫번째(두번째) 값 리턴
이 때 e가 변수 x라면  dynamic environment에서 x를 찾고
x가 pair가 아니라면(이어야 하는데 혹은 tuple이어야 함) exception을 내놓음 |

```swift
(* pair *)
fun swap(pr: int*int): int*int = 
  (#2 pr, #1 pr);
fun sum_two_pairs(pr1: int*int, pr2: int*int) =
  #1 pr1 + #2pr1 + #1 pr2 + #2pr2;

fun div_mod(x:int, y: int) = 
  (x div y, x mod y);(*(x/y x mod y)*)
fun sort_pair(pr: int * int) =
  if #1 pr < #2 pr 
    then pr
  else (#2 pr, #1 pr);
```

cf. fun swap되면 값이 진짜로 바뀌나요??? → ml에서는 그럴 필요가 없음. value가 바뀐다고 보지 않기 때문, 새로운 튜플인지 원래에서 바뀐 건지 생각할 필요가 없다는 뜻!! 나중에 알려주겠지만 일단은 복사안된다고 생각하라는 뜻. 인자로 오는 얘가 다시 쓰이는지 안쓰이는지 컴파일러가 알아서 해줄 것

- ()를 넣게 되면 우선순위가 높아져서 먼저 계산하게 됨

### Tuple

- pair의 일반화된 버전
- (e1, e2 …,en)
- ta * tb * …* tn
- #1 e, #2 e, #3 e …

### Nesting tuples

- tuple이나 tuple은 얼마든지 nested 가능

```python
val x1 = (7, (true, 9)); (* int * (bool * int) *)
val x2 = #1 (#2 x1); (* bool, 이 때 parentheses 생략하면 오류남 *)
val x3 = (#2 x1);(* true * 9 *)
val x4 = ((3,5) , ((4,8), (0,false))) (* (int * int) * ((int* int) * (int * bool)) *);
```

- tuple안에 tuple이 있다면 타입도 tuple이 됨
- (int * bool * int) ≠ (int * (bool* int))
- 접근하려면 괄호로 먼저 밖먼저 접근한 후에 안을 접근하는 인덱스를 사용

cf. fun return 타입이 튜플인 경우 리턴 타입 명시시 괄호가 들어가도 안들어가도 상관없지만 인자로 보내거나 리턴시에는 괄호 써줄 것!! 에러남

cf. #2 #1 x1이면?? 에러가 남. 왜냐면 sml은 바로 뒤에 있는 애를 인식하기 때문, operator operator opearnd 이렇게 된다고 생각하기 때문, tuple이 있어야하는데 Operator가 있다고 판단

### Lists

- nested tuple → multiple number of variable 저장 가능, 하지만 int * int * int 이면 3개만 딱 보낼 수 있음. 동적인 개수의 변수들을 보내고 싶으면??? list를 써보쟝!
- any number of element but same tye(unlike tuple)

**building list-** 3가지 방법 존재

```python
[]
[e1,...en]
e1::e2
```

- []를 이용해서 선언
- 콤마로 나눠서 element를 나열
- dynamic하게 하고 싶다면?? e1::e2
    - e1은 value, e2는 배열, 사이에는 cons operator
    - e1이 v1으로 evaluate되고, e2는 [v2, …,vn]으로 evaluate된다면 e1::e2는 [v1, v2,…,vn]으로 evaluate됨
    - e1 cons e2
    - immutable이기에 e1::e2를 한다면  e1, e2에는 아무런 변화가 없음

Q. 왜 아무런 변화가 없을까???

A. 다른 언어들은 앞에 넣으면 다 밀어버리는데 이는 mutation을 사용하기 때문, 메모리에 있는 값들을 업데이트하는 패러다임을 사용하기에 그런건데 sml은 mutaiton이 없다고 생각! efficiency 때문에 발생한 일. 

즉 새로운 리스트가 만들어지는데 다 카피하진 않고 공유해서 만듦! 

Q. sml자체는 다른 언어보다 자원을 상대적으로 더 많이 쓰긴 하지만 mutation이 더 나빠서 그렇게 한다라고 봐야함? 

A. 맞당. sml은 resource를 control하기 어렵지만 이게 더 programming efficency(버그가 더 잘 안나고 같은 일을 하는 코드가 있다면 더 짧고 생각하기 쉽다는 그런 것을 의미)가 더 낫다라고 봄

Q. 값::배열은 되는데 배열::값은 왜 안되게 디자인했는지? 

A. 기본적으로 앞으로 붙이는 건 effieceny가 더 좋고 뒤에 붙이는 건 어렵기에 그러는 거 같음.  list는 linked list처럼 생겼기에 뒤까지 따라가서 뒤에 붙이기가 어려움. 만약 tail 포인터도 가지게 되더라도 공유하기 어려워서 그렇다고 함 정리하면 뒤에 붙이게 되면 값이 바뀌어서 원래 배열을 더이상 쓸 수 없게 되기 때문!!

Q. list안에 함수 넣어도 되나욤?? 

A. 된당!!

**accessing list**

```python
null e (* e가 []으로 evaluate된다면 true를 리턴 아닌 경우 false를 리턴 *)
hd e (* e가 [v1,v2, ...,vn]으로 evaluate된다면 v1을 evaluate, e가 []이면 exception 발생! *)
tl e(* e가 [v1,v2, ...,vn]으로 evaluate된다면 [v2,...,vn]을 evaluate, e가 []이면 exception 발생! *)
```

- null e == isEmpty와 동일
- hd e == first element of e
- tl e == first 제외하고 list of e

cf. 이 세개로 거의 다할 수 있어서 인덱싱을 안쓰는 거임 

```python
(*배열의 두번째 값을 리턴하려면??*)
fun getSecond(xs) = hd(tl xs); 
getSecond([1,2,3]);
```

**type checking list operation**

- t type을 가진다면 t list 타입을 가짐
    - ex) int list, bool list ….
- 리스트 안에 든 값들이 모두 같은 타입이어야 함
- 그렇다면 []은 무슨 타입일까???  ‘a list
    - can have type t list for any type t
    - 특별한 타입인 any type list(alpha, quote a)가 됨!!
1. cons(e1::e2)
    1.  e1은 t , e2는 t list가 되어야하고 결과적으로는 t list가 되어야함
    2.  e2가 배열이 아니라면 exception이 나옴
2. null
    1. ‘a list → bool
3. hd
    1. ‘a list → ‘a
4. tl
    1. ‘a list → ‘a list

```swift
(*hd tl list*)
fun sum_list (xs: int list) = 
  if null(xs) 
  then 0
  else hd(xs) + sum_list(tl xs);
sum_list([]);
sum_list([1,2,3,4]);

(*
x= 5 [5,4,3,2,1]
x=4   [4,3,2,1]
*)
fun countdown(x: int) = 
  if x = 0 then []
  else x::countdown(x-1);

countdown(3);
countdown(10);
(*countdown(~1)은 안됨*)

(*
  x:[1,2] y: [3,4,5,6] -> [1,2,3,4,5,6]
  x: [] y : [3,4,5,6] ->  [3,4,5,6]
*)
fun append(xs: int list, ys: int list) = 
  if null(xs) then ys
  else hd(xs)::append(tl(xs),ys);

append([1,2],[3,4,5]);
```

cf. tuple은 Indexing이 되는데 왜 배열은 코드로 해줘야 함

```swift
fun getAt(idx: int, xs: int list) = 
   if idx = 0 then hd(xs)
  else getAt(idx-1, tl xs);
```

---

### List of pairs

operator는 튜플같은 타입이고 operand는 함수같은 타입으로 나옴

```swift
(* [(2,2),(3,4)] -> 11*)
fun sum_pair_list(xs: (int*int) list) = 
  if null xs 
  then 0
  else
    #1 (hd xs) + #2 (hd xs) + sum_pair_list(tl xs);

sum_pair_list([(1,2),(3,4)]);

(*return fist elements as a list
* [(1,2),(3,4)] -> [1,3]
*)
fun firsts(xs: (int*int) list) = 
  if null xs
  then []
  else 
    #1 (hd (xs))::firsts(tl xs);

fun seconds(xs: (int*int) list) = 
  if null xs
  then []
  else 
    #2 (hd (xs))::seconds(tl xs);

fun sum(xs: int list) = 
  if null xs 
	then 0
  else hd xs + sum(tl xs);

fun sum_pair_list2(xs: (int* int) list) = 
  sum(firsts(xs)) + sum(seconds(xs)); **(* sum을 붙여줘야 해!! 똥구녕아!! *)**
```

- sum_pair_list2는 두번 recursion을 하게 되지만 좀 더 general function이기 때문에 curstomize를 할 수 있기 때문, 빨리 개발하고 싶다면 위의 방법으로 하면 되지만 좀 더 유지보수적으로 한다면 밑에 방식대로 하는 것이 더욱 효율적

Q. 1000개 이상의 recursion일 경우에는 제한이 되는가? 

A. c++와 동일하지는 않으나 call stack을 생기고 Recursion을 할 때마다 메모리 오버로드와 function call에 대한 오버헤드가 있긴 한데 tail recursion이라는 optimize 알고리즘으로 한다면 오버헤드 줄여줄 것, 현재는 tail recursion 알고리즘같은 걸 쓰지 않으면 역시 제한이 존재하기는 함

### Let expressions

- local variable definition in function

| syntax | let b1,b2 … bn in e end
bi는 binding을 의미(function binding, variable binding)
e는 any expression을 의미 |
| --- | --- |
| type-checking | 각각의 bi와 e를 static environment + 이전 binding 에서 체크
→ whole expression의 타입은 e의 타입이 될 것 |
| evaluation | 각 bi를 evaluate한 후에 dynamic environment + previous binding에서 e를 Evaluate
→ whole expression의 값은 e의 값이 될 것 |

<aside>
✅ expression이기 때문에 expression이 있는 어디든 사용 가능

ex) fun s() = let val z = 3 in 3 end; ←가능함

</aside>

```python
fun silly1(z: int) = 
let val x = if z > 0 then z else 34
		val y = x+z+9
in
	if x > y then x* 2 else y*y
end;
```

- 두개의 variable binding
- 바로 위에 바인딩한 값을 사용할 수 있음

```python
fun silly2() = 
let val x = 1
in
	(let val x = 2 in x+1 end) + (let val y = x+2 in y+1 end)
end;
```

- in 안에도 let을 사용할 수 있음 let은 expression이니까!!!
    - function call argument이나 branch에서도 사용 가능
- expression에서 첫번째 expression은 3이 되고 두번째 expression은 3+1 = 4가 되어 정답은 7

→ variable의 scope을 지정해줌

함수 밖에 지정하면 global level variable이 됨

하지만 let expression을 사용하게 된다면 with in scope에서 사용하고 버려지게 될 것

overwrite or **shadow** previous binding

### Any binding in function

- let expression을 사용한다면 function 안에 function이나 variable 모두 바인딩 가능
- 내부에 function을 지정하면(helper function == nested function) 좀 더 효율적으로 구현 가능

```swift
(*let expression*)
 let val x = 42 in x+3 end;

(*3 -> [1,2,3]*)
fun countup_from1(x: int) = 
  let fun count(from: int, to: int) =  (*사실 count가 general하기에 다른 사람들이 쓸 수 있도록 밖에 둬도 됨*)
    if from = to 
      then [from] (*from::[]*)
    else 
      from::count(from+1, to);
  in
    count(1,x)
  end;

(*redundentcy 제거 *)
fun countup_from1(x: int) = 
  let fun count(from: int) = 
    if from = x
      then [from] (*from::[]*)
    else 
      from::count(from+1);
  in
    count(1)
  end;
```

- function은 정의된 environment에서 바인딩을 사용할 수 있음
    - binding from outer environment ex) parameter
    - earlier binding in the let expresion
- helper function이 좋은 경우
    - 다른 곳에서는 사용되지 않는 경우
    - 다른 곳에서 오용될 가능성이 있는 경우
    - 나중에 지우거나 바꿀 가능성이 있는 경우

Q. 왜 helper funciton이 중요(유용)할까?

A. helper function이 있다면 구현을 쉽게 하게 해주며 또한 function을 많이 사용하지 않은 함수라면 가리는 역할도 해줌. 만약 helper function을 악용해서 global자리에 둬서 누군가 직접적으로 접근할 수 있다면 private로 해주면 됨. 하지만 나중에 사라질 예정이라면 안에 정의하는 것이 나음. 만약에 top level에 두고 바로 접근하게 한다면 hard to change later 이기 때문

ex) 파이썬의 hash 함수: 같은 값이면 같은 결과가 나오는 해시 함수. 만약에 다시 restart를 한다면 다른 값이 나올 것

Q. restart를 해도 만약에 계속 같은 값이 나오게 된다면 이게 왜 문제일까?

A. 해커가 악용할 수 있다! 메모리 주소를 계산해서 원하는 정보를 +,-하면 얻을 수 있는데 항상 정보의 자리가 고정되면 해커들로 하려금 원하는 정보가 무엇인지 특정지을 수 있음. 해커가 different key이지만 같은 linked list를 계속 물어본다면 single budket이 엄청 커지게 됨 .그렇다면 다른 것들은 다 비게 되고 그렇다면 해커가 공격하기 쉬워짐

계속 문제가 되어왔으나 hard to fix 왜냐면 애를 feature로 사람들이 많이 쓰기 때문 → 천천히 바꿔야 함

→ fix 하기 어려우니까 helper function으로 가리는 게 낫다~

### Avoid repeated recursion

```python
fun bad_max(xs: int list) =
if null xs
then 0
else if hd xs > bad_max(tl xs)
		then hd xs (* 내림차순이라면 recursion 1번씩 수행 *)
		else bad_max(tl xs); (* 오름차순이라면 recursion 2번씩 수행 *)

val x = bad_max([50,49,...,1]);
val y = bad_max [1,2,...,50];
```

Q.  x,y이 같은 값과 시간이 같나?

![스크린샷 2023-04-13 오후 11.09.49.png](LECTURE%2002-Pair,%20List,%20Local%20bindings,%20noMutation%2037fa06ee9a114639a88ad91f5c837c02/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-13_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_11.09.49.png)

A.hd가 큰 경우에는 바로 나오는데 반대라면 bad_max가 두번 불리게 되어서 pooling이 되기에 y가 더 길게 걸림.

→ x는 50번 정도 걸리고 y는 exponential하게 2^50승이 됨

- 숫자가 늘어날수록 매번 두배로 시간이 더 걸리게 됨

Q. 그렇다면 어떻게 해결할 수 있을까?

A. local binding으로 중복된 작업을 줄일 수 있음

```python
fun good_max(xs: int list) =
if null xs
then 0
else 
		let val tl_ans = good_max(tl xs)
		in 
			if hd xs > tl_ans 
			then hd xs
			else tl_ans
		end;

val x = bad_max([50,49,...,1]);
val y = bad_max [1,2,...,50];
```

![스크린샷 2023-04-13 오후 11.13.39.png](LECTURE%2002-Pair,%20List,%20Local%20bindings,%20noMutation%2037fa06ee9a114639a88ad91f5c837c02/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-13_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_11.13.39.png)

그렇다면 then 0 이부분은 어떻게 해결할 수 있을까?

### Options

- **t option**: a type for any type t
    - int list, bool list같은 거와 비슷하게 int option, bool option 이렇게 사용가능

**building**

- **NONE**: 타입이 ‘a option value
    - []이 타입이 ‘a list인 것과 동일
- **SOME e**: e가 type t이면 t option이 타입
    - e::[]이면 e가 type t면 t list가 되는 것과 일맥상통

**accessing**

- **isSome:**
    - ‘a option → bool
    - true면 값을 가지고 false면 NONE을 의미
- valof은 실제 값을 줌
    - ‘a option → ‘a
    - NONE을 넣으면 exception 발생

```swift
(*t option*)
val x = SOME 42;
isSome x;
isSome NONE;
valOf x;
valOf NONE; (* exception 발생! *)
valOf (SOME("abc"));
```

이전 예시에 option을 넣어보자!

```python
(* val better_max = fn: int list → int option; *)
fun better_max (xs: int list) = 
if null xs
then  NONE
else 
		let val tl_ans = better_max(tl xs)
		in 
			if isSome tl_ans andalso hd xs > valOf tl_ans (*int option은 valOf으로 까줘야함!!*)
			then SOME(hd xs)
			else tl_ans
		end;

```

더 좋게 해보쟈!! 바로 recursive case(better_max(tl xs))에서 xs는 empty가 아니인데 왜 option에 넣을까?? 그냥 int value에 넣을수도 있자나!!

```python
(* val better_max = fn: int list → int option; *)
fun better_max2 (xs: int list) = 
if null xs
then  NONE
else 
		let fun max_nonempty(xs: int list) =
			if null(tl xs)
			then hd xs
			else let val tl_ans = max_nonempty(tl xs)
						in if tl_ans < hd xs then hd xs else tl_ans
						end
		in 
			SOME (max_nonempty(xs)) (* SOME뒤에 괄호 넣어줘야 에러안남!! *)
		end;
```

max_nonempty함수: xs가 null이 아니라는 가정하에 return int 하는 함수를 적음 → 그 후에 some으로 wrapper해서 리턴하게 됨

- xs가 널이면 위에서 걸리게 되고 그렇다면 하나 이상의 배열이 무조건 됨 따라서 싱글일 경우에는 if으로 걸려지게 되고 else에는 두개 이상의 요소를 가지고 있는 배열이 되고 얘는 tl 또한 null list가 아니기에 max_nonmentpy 파라미터로 넣을 수 있고 그걸로 비교하면 됨

Q. let in end 안에 꼭 함수를 선언해야하나요?? Let in end 없어도 다른 언어처럼 함수를 선언할 수 없나용???

A. 안됨! 왜냐면 expression이 하나만 있을 수 있는데 varible(function) binding은 expression은 아님.  따라서 function에는 expression이 하나만 있어야 하는데 function binding은 expression이 아니여서 안되고 만약에 expression이라고 하더라도 expression이 하나만 있어야 하는데 바디까지 있으면 expression이 2개가 되기 때문 안됨

### Why no mutation is better?

```python
fun sort_pair(pr: int * int) =
  if #1 pr < #2 pr 
  then pr
  else (#2 pr, #1 pr)

fun sort_pair(pr: int * int) =
  if #1 pr < #2 pr 
  then (#1 pr, #2 pr)
  else (#2 pr, #1 pr)

val x = (3,4);
val y = sort_pair x;

(*#1 x값을 5로 바꿨다고 가정*)
val z = #1 y (*5일까 3일까??????*)
```

- 위는 있는 걸 리턴하고 밑은 생성해서 리턴
    - 위아래를 구별할 필요가 없음. 왜냐면 y를 업데이트할 수 없다면 위처럼 해도 됨. 하지만 y가 5로 바뀐다면 z를 저렇게 연결하면 안됨!!
    - sml은 이 두 함수를 구별할 필요가 없다고 봄. 왜냐면 mutation이 안가능하니까!
- 튜플은 immutable하기 때문에 위 두 함수는 동일한 함수임(굳이 따지면 위가 나음)
- sml에서는 mutation을 허용하지 않음
    - mutation: update the state of object

Q. 왜 no mutation이 좋을까??

A. 다른 언어의 경우 위아래를 항상 구별해야 하고 구별하지 않을 경우 큰 문제가 일어날 수 있음. aliasing과 identical copy를 매번 구별해줘야 한다.

```python
fun append(xs: int list, ys: int list) = 
  if null(xs) then ys
  else hd(xs)::append(tl(xs),ys);

val x = [2,4];
val y = [5,3,0];
val z = append(x,y);
```

![ML은 밑에 해당. append하면 y랑 z는 share하게 됨](LECTURE%2002-Pair,%20List,%20Local%20bindings,%20noMutation%2037fa06ee9a114639a88ad91f5c837c02/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-13_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_11.38.46.png)

ML은 밑에 해당. append하면 y랑 z는 share하게 됨

cf. tl은 뒤의 리스트를 카피해오지 않기 때문에 걱정하지 않아도 됨!

### ML vs Imperative Languages

![스크린샷 2023-04-13 오후 11.40.39.png](LECTURE%2002-Pair,%20List,%20Local%20bindings,%20noMutation%2037fa06ee9a114639a88ad91f5c837c02/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-13_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_11.40.39.png)

![스크린샷 2023-04-13 오후 11.40.58.png](LECTURE%2002-Pair,%20List,%20Local%20bindings,%20noMutation%2037fa06ee9a114639a88ad91f5c837c02/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-13_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_11.40.58.png)

위 자바 코드의 **문제점**

- getAllowedUsers() 함수가 문제. 얘로 값을 바꿔버리면 접근하는 권한이 바꿀 수 있게 됨. → 카피로 줘야 바꿔도 영향이 없게 됨