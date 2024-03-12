---
title: lec6. callback
categories: ProgrammingLanguage
date: 2024-03-12 22:39:06 +0000
last_modified_at: 2024-03-12 22:39:06 +0000
---

### Mutation

- mutable data structure이 필요한 경우가 존재
    - ex) update to state of world
- ML에서 mutation을 쓰기 위해서는 **reference**라는 걸 쓸 수 있음.
- 이번 과제 빼고는 되도록 쓰지  않는 것을 추천

### Reference

- new type: `t ref`
    - simliar to option
    - int ref, bool ref….
- `ref e` : create a new reference with initial content `e`
    - ref 0 : integer의 reference ….
- `e1 := e2` : update content of reference
    - e1은 reference이고 e2는 t type이어야 함
- `!e` : retreive content

### Refernce example

![스크린샷 2023-06-10 오후 8.36.56.png](lec6%20callback%20dfb6c4ea363f4641896412bea6840bd2/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_8.36.56.png)

- 3번째 라인 후에는 x,z는 같은 메모리 location을 쓰고 있음. y는 값은 같지만 다른 데에 저장함
- x의 값을 43으로 바꾸게 되면 42에서 43이 되기 때문에 42 + 43 = 85
    - y는 변하지 않고 z만 바뀌기에
- 3번줄 전에 w식이 있다면 84가 될 것임
- x는 여전히 immutable
    - x가 참조하는 값을 바꿀 순 없음
    - 단, reference가 가리키는 content는 `:=`으로 변경 가능
- reference are first-class value
- reference은 aliases를 많이 가질 수 있어 문제가 발생할 수 있음
- like one field mutable object, so := and ! don’t specify the field

cf. 그냥 int에서 x = 42이다가 x= 43이 되면 그냥 포인팅이 다르게 됨 새로 바인딩된다고 보면 됨

Q. ref k, ref k로 한다고 한다면??그 벨류를 가지고 k값은 immutable인데 값을 카피해서 만든다고 보면 됨

사진 참고 - 카피해서 만들었다라고 볼 수 있음

```jsx
val k = 42;
val x = ref k;
val y = ref k;
x := 43;
!y ; // 42가 나옴. 43으로 안바뀜 즉, k를 가리키는 게 아니라 k값을 복사한거라고 볼 수 있음
// k는 값을 못바꿈 .x,y를 통해서만 바꿀 수 있음!!
```

### CallBacks

- library는 event가 occur될 때 function을 apply할 수 있음
    - event driven: GUI application, wait to register function. mouse click
    - network programming
- library may accept multiple callbacks
    - different callbacks may need differnt private data with different type
    - function type은 environment에 포함 x

mimic the GUI function, register function and key가 press되면 call the function하는 예시를 해보자!

### Mutable state

- library는 mutate state를 가지고 function clousre도 state를 바꿔야할 수도 있음 → ref로 해보자~
- provide function which register your function when some event happen
- callback에 등록한 함수가 call되었을 때 등록된 callback이 바뀌길 원함

### Library

- callback들을 저장할 mutable state가 필요
- 새로운 callback을 받는 function이 필요
    - callback의 타입은 int → unit
    - val **onKeyEvent**: (int → unit) → unit
- callback은 side effect을 가지고 실행될 수 있으므로 역시 mutable state가 필요할 수 있음
    
    side effect: io 출력이거나 mutation인 거를 말함. function 내에서 계산만 한다라는 거임. 실행을 다시 실행한다면 두번실행했는지 한번실행했는지 모르는 거임. 근뎨 얘는 결과를 버리니까 side effect이 있어야 하는 거
    
    ex) 출력, 1씩 더한다던지…
    

```python
val cbs:(int->unit) list ref = ref []; (*what callbacks are there *)
(*register the callback*)
fun onKeyEvent f = cbs := f::(!cbs) (* !, () 빼먹지 말것 *)
(*run the callbacks*)
fun onEvent i =
let fun loop fs = 
		case fs of 
		[] => () (*return이 unit일 때에는 ()를 리턴 *)
		|f::fs' => (f(i); loop fs' )
in loop(!cbs) end (* !빼먹지 말것 *);
```

### Client

- client는 int→unit 타입의 함수를 등록할 수 있고 다른 데이터가 필요하면 closure’s environment에 캡처하면 됨(onKeyEvent 밑의 예시)
    - 다른 걸 기억해야 한다면 mutable state 이용(onKeyEvent 위의 예시)

```python
(*ref로 누른 횟수를 기억하는 콜백 등록*)
val timePressed = ref 0;
val _ = onKeyEvent(fn _ => timePressed := (!timePressed)+1)

(*i를 캡처해서 같은 키를 누를 때마다 출력하는 콜백 등록*)
fun printIfPressed i = onKeyEvent(fn j => 
	if i = j
	then print("pressed" ^ Int.toString i)
	else ()
);
```

- timesPressed라는 mutable state를 이용해서 call될 때마다 1씩 증가하는 콜백을 등록
    - 이 때 인자는 어떤 값이든 상관없어서 _를 씀
- i를 캡처해서 누를 때의 키값인 j를 받아서 i값과 같으면 pressed를 출력하는 콜백을 등록

Q. mutation이 아니라 리턴값을 이용하거나 arugment에 현재상태를 넘길 수 있는 거 등등…. 이런 거는…

A. 리턴한다면 어딘가에 가질건지?? 함수는 라이브러리가 가지고 있자너… 아니면 라이브러리가 카운팅해야하는데 그건 말이 안됨. 걔는 general여야 하니까!!