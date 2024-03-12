---
title: 11. static typecheck
categories: ProgrammingLanguage
date: 2024-03-12 22:39:10 +0000
last_modified_at: 2024-03-12 22:39:10 +0000
---

lightweight one

### Static checking

- parse는 했지만 run하기 전에 문제가 있으면 reject
- ***Part of PL’s definition: what static checking is performed***
- PL’s static checking을 정의하는 방법은 type system을 통해서!
- type system
    - 컴파일타임에 최대한 많은 걸 체크하는 게 목적, 런타임에 최대한 에러를 줄이기 위해
    - ex) int / string같은 거 막기
    - approach: 각 variable, expression에 type 주기
    - purpose: misuse of primitive을 막고 abstraction을 적용, dynamic checking을 막음
- dynamically typed language는 almost no static checking

### ML, what types prevent

ML에서의 타입체킹이 패스되었다면 실행 시 아래 같은 일들은 없을 거임

- a primitive operation에 wrong type value이 사용되는 경우
    - arithmetic on non-numer: int / string
    - e1 e2 에서 e1이 function이 아닌 경우
    - if then 사이에 non boolean
- variable not define in the environment
- pattern match with a redundant pattern
- code outside a module call a function not in the module’s signature

### ML, what types allow

- ML에서는 이 에러는 prevent되지 않고 run time에 체크됨
    - hd []
    - array bound error
    - division by zero
- 일반적으로 logic, algorithmic error를 prevent하는 type system은 없음
    - reverse branch of a conditional
    - calling f instead of g

strong vs weak typing

- 이 두가지에 대해서 배울 거임, Othgonornal concept

### Pupose

- ML의 type system이 prevent하는 것과 하지 않는 것에 대해서 배웠음
- lanauge design에는 what is checked and how가 포함되어 있음
- 어려운 건 type system이 그의 목적을 달성하는지 확실하게 하는게 어려움

### **Question of eagerness**

> **Catching a bug before it matters** is inherent tension with **don’t report a bug that might not matter**
> 

→ 문제가 있기 전에 버그를 잡을래 아니면 문제가 아닐 수도 있으니 버그라고 하지 말자(고치는데 시간이 또 걸리니까) - tension between two 

- static checking, dynamic checking은 서로 다른 접근 방식을 가짐
- ex) 3/0을 막아보자
    - keystroke time - editor에서 쓰는 순간부터 빨간꾸불꾸불선보이면서 막음
    - compile time - 컴파일 할 때 막기
    - link time - main 함수가 evalaute하기 위해 호출될 수 있는 코드에 있는 경우 막기
    - run time - 실제로 실행할 때 안되면 막기
    - later - 안되지만 +inf로 두고 계속 이어나가기
        
        ex) floating point value는 threshold가 있음. 최대한 근사하도록 표시할건데 계속 곱하게 해서 value가 작아지게 된다면 0이 될 거임…. → 이걸 다른 값과 나누게 한다면??? → 로직은 버그가 없다라고 볼 수 있음.. 그냥 근사문제로 인해 생기는 문제 → continue computation하는데 해당 값을 infinity라고 두는 것
        

⇒ static type checking은 컴파일 타임에 하는 거고 dynamic은 런타임에 체크

### Correctness

<aside>
👉 X: type error
positive: 타입 에러가 있다
negative: 타입 에러가 없다

</aside>

- type system은 일부 X(type error)에 대해 막는다고 가정
- type system이 **sound**
    - 어떤 Input에 대해 X가 있다면 절대 accept program하지 않는다
    - ***no false negative: 에러가 없다고 했는데 에러가 있는 경우는 x***
- type system이 **complete**
    - 어떤 input이 오든 X가 없다면 절대 reject하지 않는다.
    - ***no false positive: 타입에러가 있다고 했는데  에러가 없는 경우는 x***
- PL type system은 일반적으로 sound, not complete

![스크린샷 2023-06-10 오후 6.36.52.png](11%20static%20typecheck%204a91ebc701d8468c88a3aa23d3277ec6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.36.52.png)

- 모든 가능한 프로그램이 전체 네모
- 초록: 어떤 인풋이든 에러가 나지 않는 부분
- 핑크: 어떤 인풋이든 error가 나는 부분

**Soundness**

![스크린샷 2023-06-10 오후 6.34.48.png](11%20static%20typecheck%204a91ebc701d8468c88a3aa23d3277ec6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.34.48.png)

- 진핑크+ 핑크: sound가 reject하는 부분
    - reject을 더 하는 것
    - not raising error 부분(초록)은 무조건 맞음
    
    → no false negative: 에러가 없다고 했는데 있는 경우는 없다!!!!
    

**Completeness**

![스크린샷 2023-06-10 오후 6.38.09.png](11%20static%20typecheck%204a91ebc701d8468c88a3aa23d3277ec6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.38.09.png)

- 노랑이: completeness가 reject하는 부분
    - reject을 더하는 것
    - raising error 부분(노랑)은 무조건 맞음

→  no false positive: 에러가 난다고 했는데 없는 경우 없다!!!

→sound, completness는 trade off가 존재

cf. sound type checker인데 error가 아닌데 error라고 하는 경우가 있는거임!! sound type checker 대표적인게 ml이지! type checking해서 type error가 없다라고 한다면 절대 type error가 나지 않는 거지!! 혹은 타입 에러가 있다고 사운드했는데 사실 없을 수도 있음!! 그걸 이제 할거임

### Imcompletness

![스크린샷 2023-06-10 오후 6.40.48.png](11%20static%20typecheck%204a91ebc701d8468c88a3aa23d3277ec6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.40.48.png)

- f1은 절대 호출되지 않음에도 불구하고 타입에러가 있기에 ML은 해당 예시를 reject
    - 왜냐면 potential으로 type error가 일어날 수 있기 때문!!!

### Why incompletenss

- check statically는 **undecidable**
    - type checker는 정확하게 측정할 수 없고 그냥 주어진 시간에 계산하는 거일 뿐
    - static checker가 못하는 것
        - **always terminate**
        - **be sound**
        - **be complete**

→ 즉, 프로그램을 줬을 때 static time에 얘가 종료되는지 사운드되는지 complete되는지 모두 체크할 수 없음!

![스크린샷 2023-06-10 오후 6.43.45.png](11%20static%20typecheck%204a91ebc701d8468c88a3aa23d3277ec6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.43.45.png)

- **sound and complete**
    - program이 execute되는지 안되는지 결정해야 함
    - **== halting problem**
    
    → 주어진 시간에 이게 실행되는지 모르니까 sound할지도 판단할 수 없는거지….!!
    

### Why incomepletenss

Q. 왜 program이 execute되는지 안되는지 모르는 걸까?

A. 

halting problem은 어떤 프로그램이 있을 때 모든 인풋에 대해서 프로그램이 종료할 지 계속 돌지 결정하기 어렵다!! 이게 불가능하다는게 결과임

→ 프로그램이 걔가 실행되는지도 모르니까 당연히 타입체크도 안되는 거지…않을까?

왜 halting problem과 같냐면 어떠한 부분이 실행될지 안될지는 그 부분을 infinit loop를 대체한다면 걔가 실행되는지 종료되는 지 모르는거임

### 모순으로 증명해보자!

- halting problem
    - given program이 terminate되는지 아닌지 결정하는 문제
- 증명
    - halt라는 함수가 있는데 함수를 인자로 받아서 해당 함수가 종료되면 true, 아니면 False를 리턴한다라고 가정
        
        ![스크린샷 2023-06-10 오후 6.46.55.png](11%20static%20typecheck%204a91ebc701d8468c88a3aa23d3277ec6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.46.55.png)
        
    - halts(g)는 true일까 false일까??
    - A. 말이 안됨. halt함수 존재자체가 모순이기 때문!!!

### What about unsoundness?(스킵)

이거 대부분 스킵한다는데?

- soundness라면 type system을 믿을 수 있음
    - type error가 없다라고 한다면 완전 없는 거니까
    - unsound라고 한다면 type system에 쓸 수 없음
        - 언제는 되고 언제는 안되고 이러니까
        - unsound type system은 믿을 수 없고  type error가 없다고 했는데 실행했는데 에러가 있는거!!
        
- type system이 sound하고 complete한다면 always mean static type checker일거임
- weak typing과 strong typing과 static vs dynamic 은 완전 다른 개념 orthogonal

- 근데 unsound보다 더 안좋은 문제는 type error를 허용한 것뿐만 아니라 type error를 있는데 이게  런타임에는 어떤 일이든 일어날 수 있게 되는 것

 → weak, strong typing

Q. c++가 unsound한 경우는 언제???

A. int라고 선언했지만 float으로 넣어버릴 수 있는데 이게 unsound한거지! 그냥 타입에러가 런타임에 발생할 수 있도록 그냥 c++이 선택한거임

### Weak typing(헷갈리면 컴구 3_semantic_analysis 참고)

- strong(강하게 타입을 체크)
    - 프로그램에 타입 문제가 있다면 static이나 runtime 에 캐치해서 문제를 알려주는 것
    - ML
- weak(약하게 타입을 체크)
    - 프로그래머가 타입에러를 했다면 allows to happen, crashing되는 등등의 것들을 다 허용해주는 것
    - c, c++

Q. 왜 그렇게 디자인??

- ease of language implementation
    - want to make easy to implement을 위해서
    - 컴파일러가 아닌 프로그래머가 체크
- performance
    - dynamic은 모든 변수에 대해서 check을 해야하기 때문에 시간이 더 오래걸림
- low level
    - weak typing의 가장 큰 문제는 array out of bound 문제
    - 배열에서 인덱스 범위를 벗어나면 그냥 쓰레기값을 주게 되고 이걸로 문제가 생길 수 있음
    
    → stack smashing problem까지 일어날 수 있음.
    
    cf. c의 array bound 문제…얘기하는 거 같음…
    

### What weak typing has caused

스킵

### Python

- not weakly type just check dynamically
- strong type임. 타입 에러을 알려준다면 그건 무조건 strong인거임…

### Another misconception

what operations are primitives defined on and when an error?

- 언어마다 다름
- perl: string + int가 가능
    - int를 string으로 알아서 바꿔줌
- 배열의 인덱스가 넘어지게 된다면 null을 리턴하는 경우도 있음
- objective c: nullptr 값을 가져오면noop를 리턴
- type cohersion
    - automatice convert one type to another type
- static/dynamic checking vs weak/strong typing
    - static, dynamic: 타입체킹을 언제하는가에 대한 문제
    - weak, strong: 타입 체크를 얼마나 강하게 할 건가에 대한 문제

Q. static checking 예를 들어 java같은 경우에서는 타입체킹을 해도 에러가 날까?

### Static checking(p30)

![스크린샷 2023-06-10 오후 6.09.13.png](11%20static%20typecheck%204a91ebc701d8468c88a3aa23d3277ec6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.09.13.png)

- 문제점
    - 의미가 다른데 냅다 더해버림
    - differnent unit인데 더함
    - 설립 년도 + elevation + 인구 수
- 단위가 다르지만 모두 int로 볼거임

ex) E = m*c (x)

### Dimension in source code

- dimension
    - id, $, date, port, color, flag, state, mask, count, message …
- 같은 타입이여도 semantic이 다를 거임.

Q. 다른 유닛을 더하려고 한다면 에러가 나지 않을 거임. 하지만 이 정보를 이용한다면 타입체킹을 할 수 있을 거임 어떻게 할 수 있을까??

A. 이름은 다른데 실제로 다른 semantic이 다른지를 찾아내는 게 어려움 그래프를 짜서 하면 된대

### Dimension inference example

![스크린샷 2023-06-10 오후 6.11.16.png](11%20static%20typecheck%204a91ebc701d8468c88a3aa23d3277ec6/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_6.11.16.png)

x = y+z 

- 이미 세개의 타입이 같다는 거를 가정한 거임

a < b

- 이거 역시 semantic이 같아야 함

d[i]

- i가 d.length와 같아야 함

u= v*w

- u가 v*w와 dimension이 같아야함. 혹은 v가 u/w의 dimension과 같아야 함

### Find bug

- code repository에 코드를 저장하는데 precious version들이 있을 거임
- dimension inference을 version마다 해서 compare dimension하면 됨
- 다른 dimension이면 버그가 있는 거임
- 혹은 이전버전에는 달랐다가 합쳐졌다면 이거또한 문제가 있는 거라고 볼 수 있음(같다가 달라지거나 달라지거나 같아지는 경우)
- 라이브러리만으로 dimension을 분석했을 때 x,y가 같은 디멘션이고 z가 다른 디멘션이였는데 유저코드와 같이 dimension을 분석했을 때 x,y,z가 같은 dimension으로 inference가 되면 문제가 될 수도 있다는 것!
    - 문제라고 해도 문제가 아닌 경우도 있긴 함(false positive)