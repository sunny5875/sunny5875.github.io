---
layout: post
title: lec6-Lexical Scope, function Closure, Function Closure idioms
date: 2023-06-14 23:25:33 +0000
category: ProgrammingLanguage
---

![스크린샷 2023-04-15 오후 7.08.34.png](lec6-Lexical%20Scope,%20function%20Closure,%20Function%20Clo%20c04b808745e6457baf4616ad25d1d853/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-15_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_7.08.34.png)

## very important concept

- 함수를 선언할 때 함수 안,밖 모두에서 선언된 binding을 쓸 수 가능
- 함수 호출 시 which scope을 사용해야 할까? define or call된 scope??
- lexical scope ↔ dynamic scope
    - 함수가 evaluate될 때 scope in the dynamic environment when define(즉 이전 envir을 사용)

→ lexical이 더유용

semantic 먼저 배운뒤에 왜 이게 나은지 (시험에서나 과제에서 할 떄도 유용 )

### Example

ex) lexical scope without higher-order function

```jsx
val x = 1
fun f y = x+y
val x = 2
val y = 3
val z = f(x+y)
```

- line 2
    - 이 함수를 정의
    - 호출 시 x+y를 Evaluate하는데 x는 1이고 y는 받은 argument다.
- line 5
    - f의 정의를 찾음
    - x+y를 **current environment**에서 계산하여 2+3 = 5가 됨
    - body를 evaluate 시 **old environment과 argument를 확장해서**  1+ 5= 6이 됨

**만약 dynamic scope으로 한다면??**

line 5를 부를 때 argument는 5로 동일하지만 call 될 때 x는 2이기에 function body evaluating할 때 x를 2를 넣고 해서 결과는 2+ 5 = 7이 됨

⇒ ML은  dynamic scope을 쓰지 않고 lexical scope을 사용

### Closures

Q. 어떻게 호출 시 선언될 떄에의 envir을 찾지??

A. 컴파일러는 모든 environment를 뒤에서 저장하고 있음

→ code와 dynamic environment 즉 pair를 저장해서 ML이 internal로 사용함

- function value(pair, **function closure**)
    - **code**
    - **environment** when function was defined

→ function call이 된다면 code는 environment part extended with the function argument를 사용해서 ecvaluate하게 됨

**다시 예시로 돌아가면**

- line 2
    - closure을 만듦
    - code: y를 받아서 x+y를 해라)
    - environment: x = 1 + function f itself를 바인딩함(for recursion)
- line 5
    - closure을 콜하게 되고 그러면 그 environment은 argument mapping을 통해 extend되어서 (x는 1이고 y는 5)이다를 이용해서 body를 evaluate

Q. closure은 람다함수, 익명함수 등의 본체인가…?

A. 지금까지 쓴 함수는 다 closure임. 몰랐겠지만 코드랑 환경이 다 같이 저장되고 있었던 것

Q. f가 recursion하지 않아도 무조건 바인딩하냐?

A. implementation 디테일일듯. 안가지고 있다면 최적화일거임…

lexical scope == semantic scope

이제부터는 high order functon에서 closure을 사용해보자!

### The rule stays the same

- function body는 function이 정의될 때의 environment로 evaluate된다 이 때 function argument으로 확장까지 함
- 하지만 environment에 **nested let expression**이 있다면??

→ lexical scope은 function closure을 좀 더 강하게 만들어줌

ex) returning function

```jsx
val x = 1
fun f y = 
	let val x = y+1
	in fn z => x+y+z 
	end
val x = 3
val g = f 4
val y = 5
val z = g 6
```

- line 4
    - g에 closure을 bind
        - code: z를 받아서 x+y+z를 계산해라
        - environment: y = 4이고 x = 5이다(덮어써짐(shadowing))
        
        → g는 항상 argument에 9를 더하게 됨
        
- line 6
    - 6 + 9 = 15

**만약 dynamic scope를 사용한다면**

얘는 같을 거 같음?? 

g 6이 호출될 때 x,y는 3,5니까 3+5+ 6 = 14가 된다

ex) passing a function

```jsx
fun f g =
	let val x = 3
	in g(2) 
	end
val x = 4
fun h(y) = x + y
val z = f(h)
```

- line 3
    - h에 closure을 bind
        - code: y를 받아서 x + y를 해라
        - environment: x= 4, f는 closure
- line 4
    - f는 h(2)를 하라고 하고 h는 2를 받아서 2+ x인데 x는 4니까 6이 됨
    
    → 안에 x= 3을 선언하는 건 매우 멍청하고 무관한 코드임! 어짜피 g의 환경에 의해서 무시되니까!!
    
- let expression은 의미 없어짐 왜냐면 이미 bind되었으니까!

**만약 dynamic scope를 사용한다면?**

z는 f를 호출 할 때 x가 3인데 이상태로 h(2)를 부르니까 x+ y = 3+ 2 = 5가 됨

function closure와 lexical scope이 python에는 잘안되어있는 편

```python
x= [1,2] #주소값이라면??
def foo(y):
    return len(x)+y

print(foo(1))#3
x.append(42)
print(foo(1))#4

x= [0] #주소가 바뀌었네?? binding some other value
print(foo(1))#2
#따라서 python function closure, lexical scope이 제대로 정의되지 않음
# 만약에 semantic하게 하고 싶다면?? current value x를 scope해서 로컬에 저장
def foo(y,x=x):#로컬에서 캡쳐한다면?? 
    return len(x)+y
print(foo(1))#2
x= [1,2,3,4,5,6,7]
print(foo(1))# 8이 아니라 2!!
```

free varaible binding이 제대로 동작 안함 

### Why lexical scope

*lexical scope: function이 define된 environment를 사용*

*dynamic scope: function이 call된 environment을 사용*

- 에전에는 이 두가지가 합리적이라고 봤었지만 지금은 대부분 lexical scope이 더 낫다라고 생각!
1. **function의 정의가 variable name이 무엇인지에 의존하면 안된다**
- function 안에 변수를 쉽게 바꿀 수 있는데 그래도 의미가 바뀌지 않아야 함

ex) f안에 있는 변수 x를 q로 바꾸고 싶다

```jsx
fun f y = 
let val x = y+1
in fn z => x+y+z end
```

- lexical scope: 상관없음
- dynamic scope: 결과가 어떻게 쓰이냐에 따라 다름, 다이나믹하게 사용될 수 있기에 고려를 해줘야 함
    - hard to think locally
    - 모든 호출되는 곳에서 사용되는 x를 찾아서 q로 바꿔야함
    - dynamic은 이 함수가 어떤 스콥에서 쓰냐에 따라서 semantic이 달라지기에 한부분만 보고 코드를 바꿀 수 없다라는 것!!

ex) 필요없는 변수인 x를 지운다

```jsx
fun f g = 
	let val x = 3
	in g 2 end
```

- lexical scope: 상관없음
- dynmaic scope: g에서 x가 사용될 수 있기 때문에 지울 수 없다!!
1. **Function은 type check할 수 있고 정의된 위치에 대해 추론할 수 있다**

ex) 

```jsx
val x = 1
fun f y = 
	let val x = y+1
	in fn z => x + y + z end
val x= "hi"
val g = f 7
val z = g 4 
```

- lexical scope:  type check하기 쉬움
- dynamic xcope: 선언부로만 타입체킹하기 어려움. g 4 일 때 현재 x가 “hi”이기 때문에 x+y+z = “hi” + 7 + 4가 된다
1. **closure은 그들이 원하는 private data를 쉽게 저장할 수 있다**

```jsx
fun greaterThanX x = fn y => y > x

fun filter (f, xs) = 
case xs of
[] => []
| x::xs' => if f x
						then x::filter(f,xs')
						else filter(f,xs')

fun noNegatives xs = filter(greaterThanX ~1, xs)
fun allGreater(xs, n) = filter(fn x => x > n, xs)
```

- keep the environment하기 때문에 필요한 데이터를 저장하기 쉬움
- 코드에 비교하는 함수가 많이 쓰일 수 있는데 매번 익명함수를 만들어서 넣지 말고 x 를 받아서 비교하는 함수를 만들면 ~1가 closure안에 들어가고 filter는 뭐가 들었는지 몰라도 됨

<aside>
⚠️ dynamic scope은 결과를 추론할 떄에는 현재 상태만 생각하고 따라가야 함 closure안에 선언해도 현재꺼를 따라감

</aside>

### Dynamic scope이 좋은 경우

- 대부분의 경우 lexical이 구현에 맞음
- 하지만 아주 특별한 경우 dynamic scope이 유용한 경우가 존재

ex) 로깅을 텍스트 파일에 저장하는 거인데 어떤 부분만을 스크린에 보여주고 싶다면 ??

```cpp
*log-out-fd* // 파일이름

(defun (log-info msg) // msg라는 인자를 받는 log info 함수를 정의
( 
	write * log-out-fd* "message" msg) // 지정된 파일에 message와 msg를 출력
)

//런타임에 with bind안에 호출된 애들에서는 std-output에 바인딩되게 해라 이런 의미임.. dynamic에서 결정되니까
(log-info "my message") // log info 함수 호출
(
	with-bind *log-out-fd* *std-output*  //log-out-fd를 std-output로 임시로 바인딩
	(call some module) // 여기서 스크린에 보여주자고 하면 됨!!
)

```

- 위의 예시에서 exception handling해야한다면 raise exception한 경우 excpetion은 call stack을 찾아서 처리하니까 이 때는 적당함

→ 하지만 대부분의 경우에는 lexical scope이 맞음

### When things evaluate

- function body는 호출되기 전까지는 evaluate되지 않음
- function body는 호출될 때마다 evaluate
- variable binding은 variable이 사용될 때마다 evaluate되는 게 아니라 binding이 evaluate될 때 그것의 expression이 evaluate됨.

→ closure을 이용한다면 repeating computation을 줄일 수 있음

### Recomputation

```jsx
fun all shorterthan1 (xs,s) = 
filter(fn x => String.size x < String.size s, xs)

fun all shorterthan2 (xs,s) = 
let val i = String.size.s
in filter(fn x => String.size x < i, xs) end
```

두개의 함수는 동일한 일을 하는데 첫번째 함수는 xs의 요소의 개수마다 String.size를 계산하고 두번째의 함수는  list 한개에 한번만 String.size를 계산함

 → string.size s가 매우 어려운 함수라고 본다면 얘는 한번 계산해서 변수로 넘기는게 나음. 왜냐면 variable binding은 사용할때마다 evaluate되는 게아니라 binding이 evaluate될 때 evaluate되기 때문

⇒ let binding은 binding을 만나면 evalaute하고 function body는 호출할 때 evaluate된다!

Q. 원래 저렇게 알아서 컴파일러가 최적화하지 않나..?

A. 아닐수도 있음… side effect이 있을테니까 여러 파일이 있다면 고려하기 힘듦

### Fold == reduce, inject

accumulator를 인자로 가져서 그 결과를 acc로 써서 계속 f함수를 진행

fold(f,acc, [x1,x2,x3,c4]) == f(f(f(f(acc,x1),x2),x3),x4)

```jsx
fun fold (f, acc, xs) = 
case xs of
[] => acc
|x:xs' => fold(f , f(acc, x), xs')
```

ex) acc가 0이고 f가 더하기면 sum임, acc가 1이고 f가 곱하기면 product임

- 대부분의 경우에는 알파와 베타가 같지만 그렇지 않을수도 있음.
- 위 예시는 left fold
    - left fold 왜냐면 왼쪽부터 받으니까!

![스크린샷 2023-04-15 오후 6.15.24.png](lec6-Lexical%20Scope,%20function%20Closure,%20Function%20Clo%20c04b808745e6457baf4616ad25d1d853/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-15_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.15.24.png)

![스크린샷 2023-04-15 오후 6.15.45.png](lec6-Lexical%20Scope,%20function%20Closure,%20Function%20Clo%20c04b808745e6457baf4616ad25d1d853/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-15_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.15.45.png)

대부분은 순서에 상관없지만 상관있는 경우 존재하니까 유의할 것

- +,-는 결과는 동일 division이라면 다를 듯

### Why iterators again?

- map, fold, reduce같은 iterator like function은 built in이 아니라 programming pattern임

ex) fold 0

- ML은 fold 시 0을 봤으면 더이상 계산이 필요가 없으니까 raise exception을 함
- 하지만 다른 언어의 경우 shorthand라고 생각하고 더이상 iteration하지 않고 early stop해서 리턴함
- 이러한 pattern은 **data processing**으로부터 **recursive traversal**을 구분시켜줌
    - data processing은 f가 하는 일이고 iteration은 고차함수가 하는 일
    - different data processing을 같은 traversal에 사용 가능
    - different data structure을 같은 data processing에 사용 가능
    - 의사소통에 편리

### Examle with fold

ex) private data를 사용하지 않는 경우

```jsx
fun f1 xs = fold((fn (x,y) => x+y), 0 , xs) // addtion
fun f2 xs = fold((fn (x,y) => x andalso y>=0), true , xs) // 모든 요소가 양수이면 true
```

ex) private data를 사용하는 경우

```jsx
// 더하기는 하지만 1 or 0를 더하는데 만약에 element가 low와 high 사이에 있는 애들만 카운트해서!
fun f3(xs,hi,lo) = 
fold(fn (x,y) => 
	x + (if y>= lo andalso y <= hi then 1 else 0),
	 0, xs)
//모든 element가 g함수를 통과한다면 true
fun f4(g,xs) = fold(fn (x,y) => x andalso g y, true, xs)
```

- hi,lo는 밖에 있는 변수이고 람다함수는 밖에 있는 변수를 capture되어서 environment에 저장되어서 사용
- private data를 가지고 있는 g 함수를 캡처해서 pass해서 closure에서 사용

⇒ 고차함수는 closure과 lexical scope으로 인해 밖에서 선언된 변수를 캡처하게 되어서 아주 강력해짐. 

 또한 책임이 잘 분리됨 → data processing에 필요한 private data는 함수 안에 있고 iterator는 그걸 몰라도 됨

```cpp
fun map (f, xs) =
  case xs of
      [] => []
    | x::xs' => f(x)::map(f, xs')

fun filter(f, xs) = 
  case xs of
    [] => [] 
  | x::xs' => if f x then x::filter(f, xs') 
                     else filter(f, xs')

fun fold(f, acc, xs) = 
    case xs of 
      []     => acc
    | x::xs' => fold(f, (f(acc,x)), xs')

(* naive하게 확인하는 함수 
returns, true if for all element e in alist
test(e) = true
*)
fun ifall (test, alist) = 
case alist of
[] => true
| a::[] => test(a)
| a::alist' => test(a) andalso ifall(test, alist")
 
(* 
returns true if for any element e in alist
test(e) = true
*)
fun ifany (test, alist) = 
case alist of 
[] => true 
| a::[] => test(a)
| a::alist' => test(a) orelse ifany(test, alist');

(*using higher order function - better, 성능 고려하지 말 것 *)
fun ifany2(f,xs) = 
not (null (filter(f,xs))) ;

fun ifall2(f,xs) = 
	length(xs) = length(filter(f,xs));
```

### Function combine(composition)

closure, high order- 을 사용한다면 combine multiple function가능!

```jsx
fun compose (f,g) = fn x => f(g x)
```

- ML에서는 compose할 수 있는 **o라는 infix operator**를 제공함

ex) abs and then square root(3번쨰가 가장 좋음)

```jsx
fun sqrt_of_abs i = Math.sqrt(Real.fromInt(abs i))
fun sqrt_of_abs i = (Math.sqrt o Real.fromInt o abs) i
val sqrt_of_abs = Math.sqrt o Real.fromInt o abs ;
```

infix operator로 좀 더 쉽게 할 수 있음!

cf. unix-txt에서 sort한다면 그룹핑이 될 거임. 그다음 중복된거 제거하면~

sort iplists.txt | uniq | wc -l

sort → uniq → 라인 수

→ pipe(string stream)에서 함수를 계속 적용할 수 있음!:  Pipeline of function

abs하고 나서 그 결과를 real에 주고 그 결과를 sort에 줌

⇒ math에서 composition right to left인데 많은 프로그래머는 left-to-right니까 **pipelines of function**이 더 일반적

```jsx
infix |>
fun x |> f = f x (* |> 라는 infix 함수를 선언, x가 data, y가 함수 *)
fun sqrt_of_abs i = i |> abs |> Real.fromInt |> Math.sqrt
```

cf.|>이 함수이름, 원래는 함수이름이 인자보다 먼저 오는데(prefix) 얘는 infix임

ex) backup function

```jsx
fun backup1 (f,g) = 
fn x => case f x of
NONE => g x
|SOME => y 
```

타입: (’a → ‘b option) * (’a → ‘b) → (’a → ‘b)

- f에서 exception이 나면 g에서 핸들처리할 수도 있음

## Currying(Multi-arg functions and partial application)

 high order function과 lexcial scope을 흥미롭게 할 수 있음

- ML은 정확히 하나의 인자를 받는다고 했는데 따라서 argument가 n개가 아니라 n -tuple이 됨
- 근데 다른 방법으로 n개 보낼 수 있는 게 argument를 함수에서 처리하고 또 그걸 인자로 보내서 처리하고 ….n번 그럴 수도 있음 : Currying

### example

```jsx
val sorted3 = fn x => fn y => fn z => z >= y andalso y >= x
val t1 = ((sorted3 7) 9) 11
val t1 = sorted3 7 9 11
```

x는 argument를 받고 function을 반환, y도 argument를 받고 function을 반환, z는 argument를 받고 값을 반환

→ x를 먼저 보내서 함수를 받고 그 함수를 y와 함께 보내고 함수를 받고 그 함수에 z를 보내서 구함 : curry

![스크린샷 2023-04-15 오후 7.15.47.png](lec6-Lexical%20Scope,%20function%20Closure,%20Function%20Clo%20c04b808745e6457baf4616ad25d1d853/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-15_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_7.15.47.png)

z는 capture the environment x→y해서 계산

**function call부분**

- (..((e1 e2) e3 ) e4) == e1 e2 e3 e4 이기에 세번째 줄과 두번쨰는 같은 의미
- function call인데 괄호와 ,가 없다라고 생각하면 됨!

→ *caller는 **tuple expression 대신 multi argument function**을 생각*

- tupling과 다름: caller와 callee가 같은 technique을 사용하고 있기 때문

**function binding 부분**

- fun f p1 p2 p3 p4 .. = e
    - val f p1 = fn p2 ⇒ fn p3 ⇒ … ⇒ e 와 동일한 의미
- 기존의 함수 정의에서 argument에 괄호와 ,가  없으면 currying function이 됨! == function call과 비슷하게 생김
    - val sorted3 = fn x ⇒ fn y ⇒ …이나
    - fun sorted3 x = fn y ⇒ fn z ⇒ … 대신

```jsx
fun sorted3 x y z = x ≥y andalso y ≥ x
```

→ *callee는 **tuple pattern 대신 multi argument function**을 생각*

- tupling과 다름: caller와 callee가 같은 technique을 사용하고 있기 때문

![스크린샷 2023-04-15 오후 7.27.40.png](lec6-Lexical%20Scope,%20function%20Closure,%20Function%20Clo%20c04b808745e6457baf4616ad25d1d853/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-15_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_7.27.40.png)

![syntatic sugar curry function](lec6-Lexical%20Scope,%20function%20Closure,%20Function%20Clo%20c04b808745e6457baf4616ad25d1d853/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-15_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_7.27.31.png)

syntatic sugar curry function

### curried fold

```jsx
fun fold f acc xs =
case xs of
[] => acc
| x::xs' => **fold f (f(acc,x)) xs' //괄호 하나라도 빠지면 에러남**

fun sum xs = fold (fn(x,y) => x - y) 100 xs;
fun suml xs = List.foldl (fn(x,y) => **y-x**) 100 xs;
val xs = [1,2,3,4,5];
sum xs; // 85
suml xs; // 85
```

- 다 똑같고 ()만 없고 콜할 때 형식이 다른 거
- ML에 기본으로 있는 foldl에서의 f는 반대로 argument를 받음

Q. 왜 유용?

A. 선언한 거중에 few argument를 보내야한다면??? function만 보내고 싶다면??

남은 인자를 기다림: 이게 아주 유용 

왜??? 아주 큰 프로그램에서 fold를 써야한다면 1,2번쨰 인자는 뭘 넣을지 아는데 3번째는 모르겠다면?? 내가 1,2번쨰를 넣고 아는 3번째는 다른데에서 넣어줄 수 있음

즉, 프로그램을 짤 때 어떤 코드 이부분에서 일부 인자만 알고 마지막 인자를 모른다면 내가 1,2번째를 보내면 함수는 1,2번째를 가지고 있게 되서 사용하는 사람은 3번쨰 아는데가 패스해서 사용하면됨 : encapsulation!!! 

> if caller provide *too few argument*, we get back a closure *waiting for the remaining arguments* : **partial application**
> 

### Example

```jsx
fun fold f acc xs = 
case xs of
[] => acc
|x::xs' => fold f (f(acc,x)) xs'

fun sum_inferior xs = fold (f(x,y) => x+y) 0 xs
val sum = fold (fn(x,y) => x+y) 0 // better. more concise
```

- sum function을 보면 뒤에 리스트를 아직 안넣어줌
    - xs가 주어지면 evaluate됨, 그때서야 f는 fn (x,y) ⇒ x+y에 bound되고 acc는 0에 bound되면서 case expression이 evaluate될 것
- previously learned not to write fun f x = g x when we can write val f = g

### Iterator

이런 paritial application 방법은 iterator에 유용

![스크린샷 2023-04-15 오후 11.54.12.png](lec6-Lexical%20Scope,%20function%20Closure,%20Function%20Clo%20c04b808745e6457baf4616ad25d1d853/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-15_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_11.54.12.png)

- reverse로 한다면 list를 주고 나서 test function을 기다리게도 할 수 있음
- hasZero는 function을 넣어놓고 int list를 기다리고 있으며 0이 들었는지 체크하게 됨.
- ML은 curried 함수를 제공
    - **List.map, List.filter, List.foldl**

cf. oop는 상속을 쓰면 child가 parent class를 받는 거가 장점 1, super class instacne와 child class instance를 구별안해도 되는게 장점 2임. curried는 약간 다른 오브젝트를 같은 방식으로 핸들링하는 거라면 얘는 test 함수가 어떻게 되는지 몰라도 다른 곳에서 받아서 쓸 수 있게 해주는 그런 느낌의 캡슐화임

<aside>
⚠️ 커리 함수에 적은 인자를 보내서 기다리게 할 수 있지만 가끔 value restriction 에러가 나올 수 있음! 그렇다면 기다리지 않는 버전으로 하면 됨.

</aside>

### More combining function

curry function에서 argument를 reverse order를 할 수 있다고 했는데 해보자~

![스크린샷 2023-04-16 오전 12.00.18.png](lec6-Lexical%20Scope,%20function%20Closure,%20Function%20Clo%20c04b808745e6457baf4616ad25d1d853/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-04-16_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_12.00.18.png)

- 아까 예시로 하게 된다면 first list and then function → function apply first and then list: reverse order로 할 수 있음
- normal function과 curry function 변환도 할 수 있음

### efficiency

**tupling vs curring multiple-arguments**

커리 함수는 거의 비슷 따라서 커리 함수의 efficiency를 고려할 필요는 없음

normal함수가 좀 더 efficently하기는 함 (in ML)

→ 그냥 편하면 커리함수 쓰셈~

# Implementing an ADT

- closure can implement **abstract datatype**
- 함수를 list, tuple, record 등에도 들어갈 수 있지만 record가 가독성이 좋기 때문에 record에 넣음
- function들은 private data를 가질 수 있음
    - class having instance variable
- private data는 mutable or immutable할 수 있음
- object와 비슷한 느낌

→ 사실 OOP와 FP는 비슷한점이 존재한다

: oop와 Pl은 reduce redundency와 express abstraction하는 거지만 redundency를 줄이는 다른 방법인거임

ex)insert, member, size 함수를 가지는 immutable integer set

```cpp
(* abstract data type using closures *)

(* int set 
 * with 3 methods: insert, member, size, 
 *             notice insert returns a set (a new set)
 *)

(*나중에는 이 datatype이 왜필요한가 느낄 수도 있음 *)
datatype set = S of { insert : int -> set, 
                  member : int -> bool,  
                  size   : unit -> int
                };

(* implementation of sets: this is the fancy stuff, but clients using
   this abstraction do not need to understand it *)
val empty_set =
  let
    fun make_set xs = 
        let fun contains i = List.exists (fn x => i=x) xs
        in
            S({insert = fn i => if contains(i)
                                then make_set(xs)
                                else make_set(i::xs),
                member = contains,
                size   = fn () => length(xs)
            })
        end
  in
    make_set [] (*  set value S{...}*)
  end ;

(* example client *)
val S(s1) = empty_set; (*using pattern matching record type*)

val S(s2) = (#insert s1) 34;  (* s2 has xs=[34] *)
val S s3 = (#insert s2) 34;  (* s3 xs=[34] *)
val S s4 = #insert s3 19;  (* s4 xs = [34, 19] *)
(#member s4) 19;
```

make_set: let expression안에 선언. 중복된 요소가 있으면 안된다는 constraint가 있는데 유저가 이 함수를 바로 부르지 않았으면 좋겠어서 nested function으로 둠

- make_set 함수는 set type을 반환
- make_set 함수는 nested function으로 해당 요소가 set에 있는지 체크하는 contains 함수 존재
- make_set 안에 있는 함수들은 xs를 캡처함
- List.extist는 curry함수이고 list에 저 테스트를 통과한다면 true를 줄 것
- make_set을 만드는 건 좀 효율성이 떨어지긴 하지만 지금은 고려하지 말것
- make_set을 안에 함수 넣는 거는 그냥 1,2 막 넣게 해주면 constraint가 지켜지지 않으니까 맨 처음 만들 때 redundent하지 않게 지켜서 만들어주면 그 뒤에 체크해서 넣어주면 되는데 밖에 두면 안 되니까 안에 두는 것

→ record는 함수들을 묶어주는 거고(빼도 뭐 상관은 없음, class에서 function 묶어주는 거랑 비슷) 이 세 개의 함수는 xs를 접근하니까 xs는 private data라고 볼 수 있음 == oop에서의 class에서 함수 정의하고 instance variable쓰는 것과 비슷

**Map, Fold data processing example**

map reduce framework을 사용해서 합쳐서 해보자

배열이 어어엄청 길고  여러 머신이 가지고 있으며 각 머신이 각 라인을 가지고 있다라고 가정

```cpp
(* map, fold, filter는 not curry로 구함 위에 있음 *)
(* use fold to find max in a list *)
val ints = [1,9,5,1]
val mymax = fold (fn (acc, x) =>  if x>acc then x else acc,
                          hd(ints), ints)

val nums_list = [[9, 40, 75, 7],
                 [64, 34, 88, 96],
                 [91, 92, 53, 31],
                 [50, 84, 73, 65],
                 [54, 44, 75, 11],
                 [91, 71, 48, 46],
                 [70, 72, 5, 42],
                 [25, 77, 49, 56],
                 [89, 4, 73, 52],
                 [36, 56, 61, 1]]
(* fun fold(f, acc, xs) *)

(* let's find local max by applying fold to each list *)
val local_max =  
    **map**(fn nums => 
           **fold** (fn (acc, x) =>  if x>acc then x else acc,
                          hd(nums), nums)
        nums_list)
                
(* [75, 96, ... ] *)

(* now apply fold again! *)
val global_max = 
  **fold** (fn (acc, x) =>  if x>acc then x else acc,
        hd(local_max), local_max)
              

(* given x, count the multiples of x in each list
 * x=11, num_list= [[1, 2, 11], [2, 3, 22, 33], [4, 5]]
 * ==>   [1, 2, 0]
 *)
(* 1. apply modular (filter) to *each* list
 * ==> [[11], [22, 33], []]
 * 2. count *each* list
 * ==> [1, 2, 0]
 *)
(* filter(f, xs) *)

fun count_multiples (x, nums_list) =
  let val multiples = 
    filter(fn num => num mod x = 0, nums_list)
  in
    map(List.length, multiples)
  end

(* similar to above, given x, count the multiples of x in each list
 * and returns the index of the list having the maximum count.
 * x=11, [[1, 2, 11], [11, 22, 33], [4, 5]]
 * ==>   1  
 *)

(* 1. call count_multiples above
 * 2. apply fold. acc = (max_index, curr_index, max_value)
 * hint: keep acc tuple containing (index of current max, current index, max multiples)
 *  e.g. x=11, [[1, 2, 11], [11, 22, 33], [4, 5], [11, 22, 33, 44]] 
 *       counts= [ 1,         3,             0,           4]
 *           (0, 0, 1) ==> (1, 1, 3) ==> (1, 2, 3) ==> (3, 3, 4)
 *                  (0, 1, 1)     (1, 2, 3)    (1, 3, 3)
 *)
fun index_of_max_multiple_count (x, nums_list) = 
let val counts = count_multiples(x, nums_list)
(*   [1, 3, 3] *)
in
    fold(fn acc, y => if (#3 acc) > y
                        then (#1 acc, 1+(#2 acc), #3 acc)
                        else (#2 acc, 1+(#2 acc), y)
        (0, 0, hd(counts)),
        counts)
end

(*
   (* the above implemented using record type instead of tuples*)
    fold(fn acc, y => if #maxVal acc > y
                        then 
                          {maxIdx=#maxIdx acc, 
                           currIdx=1+(#currIdx acc),
                           maxVal=#maxVal acc}
                        else
                          {maxIdx=#currIdx acc,
                           currIdx=1+(#currIdx acc),
                           maxVal=y}
        {maxIdx=0, currIdx=0, maxVal=hd(counts)},
        counts)
*)

(* {maxIdx:int, currIdx:int, maxVal:int} *)
```

첨에 local max를 구한 후에 aggregate 한번 더하면 됨!

map은 각 배열을 접근하고 fold는 각 배열에 있는 각 요소를 접근

- 코드 업로드해줄테니 봐라~

call back, value restriction 빼고 지금까지의 범위임

---

#