---
layout: post
title: 7-2.Optimization 2
date: '2024-03-12 22:21:28 +0000'
category: Compiler
---

# forward copy propagation

constant propagation과 거의 동일, 아까는 상수를 넘겨주는 거였다면 얘는 다름

Forward : bb를 위에서 아래로 보겠다는 의미, 반대는 backward, 즉 아래에서 위로 적용하겠다

Copy : 레지스터에서 레지스터로 move를 의미

- **무브에 오른쪽에 있는 값을 전달**
    
    ~~r1 = r2~~ 
    
    r4= r1+1 → r4 = r2 +1
    
    조건 - r2는 def되면 안되고 즉 새로 지정되면 안되고 avaiable해야 한다. r1+1까지 살아있어야 한다. 또한 r1을 r2로 대체하려면 r1 또한 새로 지정되면 안된다. : r1,r2가 새로 지정되면 안되며 available해야 한다.
    
- 장점
    - Move를 하나 없앨 수 있다
    - dependency가 사라진다 → Dependency chain이 줄어드므로 스케줄링 시 좋다.
- **rule**

![Untitled](/assets/2024-03-12-7-2-Optimization-2/Untitled.png)

X가 무브이고 y는 어떤 instruction이고 x의 소스가 레지스터(constant propagation에서는 x가 무브인데 source가 constant인 경우였음)

Ra가 y까지 available하고 ra가 x에서 available expression이라면(du chain ud chain과 비슷)

사이에 문제가 없고 dependency가 존재한다면 rc= rb+rd로 지정할 수 있다!

![Untitled](/assets/2024-03-12-7-2-Optimization-2/Untitled%201.png)

# ✅CSE(common subexpression elimination)

이게 진짜 아주 유명한 최적화 기법임

- 이전 결과를 사용하는 expression(공통되는 subexpression)을 없앤다
    
    수식을 없애는 것, 이전에 결과를 이용해서 어떠한 expression의 실행하는 것을 없애겠다!
    

![Untitled](/assets/2024-03-12-7-2-Optimization-2/Untitled%202.png)

R100을 만든 후 r100을 카피하도록 한다

R4=r1은 왜안될까?

사실 되긴 되지만 r100을 이용하는 이유는 r1,r4사이에 r1이 업데이트가 될 수 있으므로 r4=r1을 하면 맞을 수도 틀릴 수도 있으므로 새로운 변수를 introduce한 후에 사용해야 한다.

r4=r100임을 쓰려면 r2,r3가 재정의되면 안된다. r100은 내가 만든 것이므로 고려할 필요 x

→ Forward copy propagation에 의해서 사라질 수 있음, r100을 만들더라도 사이에 만약 r100이 다시 만들어지지 않는다면 R1이 업데이트 되지 않는다면 R100을 지울 수 있음

- 장점
    - 곱셈을 하나 줄어든다
    - 새로 만든 move도 copy propagation에 의해 사라질 수 있다
    
    단, 사용하는 레지스터 수가 하나 늘고 Instruction이 증가한다
    
- **rule**
    - X,y가 같은 작업을 수행(동일한 opcode)
    - x의 소스와 y의 소스가 동일할 때 사용 가능
    - expression x가 y에서도 유효(r2,r3 변하면 안됨)
    - X가 Load인 경우에는 좀 더 생각해야 한다, redundant load elimination하는 게 나으므로 cse에서는 웬만하면 load는 건들지 말 것

![Untitled](/assets/2024-03-12-7-2-Optimization-2/Untitled%203.png)

cf.
cse 적용 후 forward copy propagation해서 r100을 r1으로 바꾸고 싶음.. 두번쨰를 지우고 r4=r1으로 바꿔야 하는데 r1이 바뀌면 안됨
나중에 시험볼 때 cse는 r100까지만 말하는 것이고 r4=r1을 넣으면 되겠네 이렇게 하면 틀렸다라고 볼 수 있음. 안되는 경우도 있으니까…!! Cse 적용 시 copy propagation까지 적용하면 안된다. 만약에 추가할 거면 말해줘야 한다
Q. 왜 이렇게 나눠놨을까? R100을 무조건 만들고 copy propagation에게 맡겼을까???
A. r1이 변경될 수도 있는데 왜 r100을 넣는 거에서 멈췄을까?? 각각의 컴파일러가 수행하는 많은 최적화가 있기에 redundant할 수 있으므로 짜잘한 최적화하는 과정을 가지고 있으니까 cse는 자기가 할 수 있는데까지 하지 않고 나중에 다른애해서 할테니까 자신의 영역의 일만 하는 것
Load는 다른 최적화가 해주니까 고민하지 않는다.  메모리와 레지스터를 위한 최적화가 좀 나뉘어져 있는 편, 경계가 있기 때문, 메모리는 좀 더 고려할 것이 많음
시험문제는 코드 주고 이 중에서 최적화를 가지고 있으니까 이 최적화를 보이는 과정을 보여라

# ✅LICM(Loop Invariant Code Motion)

루프와 관련이 있지 않은 코드는 옮긴다, 루프와 상관없이 값이 바뀌지 않는 코드를 옮긴다

루프와 관련된 최적화이므로 더욱 중요

- loop안에서 바뀌지 않는 source operand를 가지는 Operation을 prehdeader로 옮긴다.
    
    Operation을 옮기는데 source operand가 변하지 않는 애를 preheader로 옮긴다.
    

![Untitled](/assets/2024-03-12-7-2-Optimization-2/Untitled%204.png)

- R5는 아무것도 없기 때문에 invariant함. R4도 사용만 되지 바뀌지 않음
- R4를 루프 안에 있으면 5번 수행하지만 r4에 r5를 넣는 작업은 한번만 하면 됨. Load는 시간이 오래걸리는 주요한 연산이므로 R4,r5가 invariant하기 때문에 얘는 preheader로 옮긴다.

→ 1번만 수행하므로 속도가 빨라짐

- Memory operation은 계속 읽어야할 수도 있기 때문에 조심해야하긴 하다
- opt가 매 반복마다 실행되는 경우가 아니라면 조심할 것

Q. load는 디램에서 데이터를 꺼내는데 100사이클이고 캐시에서 꺼낼 때에는 1번 걸리는데 100번도는 루프를 preheader로 올리면 한번만 100사이클 걸리고 그 다음부터는 한사이클만 걸림. 캐시에서 가져오기 때문
->전체 199사이클이 된다

- **rule**

![Untitled](/assets/2024-03-12-7-2-Optimization-2/Untitled%205.png)

X를 옮길 수 있는데 X의 소스가 loop에서 바뀌지 않아야 한다

x라는 명령어는 x의 dest를 바꾸는 오직 하나의 명령어여야 한다. 여러개라면 업데이트 해줘야하니까! 

Dest x의 사용은 Available def에 들어가야 한다

Load, store의 경우 값을 쓰지 않는다는 것의 확신이 있어야 한다

R0= load(r1)

R1에 해당하는 주소가 업데이트 되지 않음을 확신할 수 있어야 함

Store가 loop 밖에 있으므로 바꿀 수 있지만 안에 있다면 store안의 값이 r1과 무조건 달라야 함 중요

Load가 올라갈 수 있는 이유는 store가 루프 뒤에 실행되기 때문

메모리 location이 바뀌지 않음을 확신할 수 있을 때 수행 가능

# global variable migration

전역변수를 만들고 루프 안에서 사용할 전역변수를 하나 새로이 만드는 것

r5를 실제로 수행하고 싶을 때 r7= load (r5)한 다음에 r7으로 바꿀 수 있는데 얘는 licm 이후에 너무 심화이므로 더이상 보지 마라!

- assign a global variable temporarily to a register for the duration of the loop

![Untitled](/assets/2024-03-12-7-2-Optimization-2/Untitled%206.png)

이건 중요한게 아니라서 그냥 봐라
R4가 있는데 얘는 아까는 위로 올렸는데 얘는 올릴 수 없음. 왜냐면 r5이 store하니까 r5가 변할 수 있음. 

->위에서 먼저 load r5를 해주고 r10으로 바꾸는 것을 말함

# induction variable strength

Induction variable : 루프를 제어하는 변수를 말함. I++같은 변수

Strength reduction : 강도를 낮춘다

오래걸리는 오퍼레이션을 작게 걸리는 오퍼레이션으로 바꾸는 것, constant folding과 약간 비슷한 개념, algebraic folding과 비슷(instruction latency를 낮춰주는 것)

- create basic induction variables from derived induction variables

![Untitled](/assets/2024-03-12-7-2-Optimization-2/Untitled%207.png)

Induction variable(루프를 컨트롤하는 변수, i++)
R2= r1*4;이런 것도 있는데 얘는 derived induction variable인데 곱셈이 있다면 오래 걸리기 때문에 얘를 strength reduction한다. Instruction의 latency를 줄여준다
→ R1*4를 r1<<2;로 변경
R2= r1*4에서 r2=r2+4로 변경

R1,r2를 연관이 있다고 볼 수 있지만 사실 따로 동작이 가능 

→ r2 초기값 0 넣고 +4로 바꾸면 곱셈을 덧셈으로 바꾸니까 효과적, 루프 안에서는 곱셈에서 덧셈으로 바꾸는 것이 큰 효과를 가져옴

R4는 r4+1이니까 r4=0일 경우에는 r4는1,2,3,4로 가는데 r6는 4,8,12로 가니까 r6의 초기값은 0으로 넣어줘야 한다.

Q. shift는 오래 안걸리는데 왜 굳이 바꿀까?

A. R4*4이라면 이렇게 바꾸는게 훨씬 좋다라고 볼 수 있음

- **rules**

![Untitled](/assets/2024-03-12-7-2-Optimization-2/Untitled%208.png)

X는 곱셈, 등등일 때 소스가 basic induction variable(++,--같은 것) 소스가 변하지 않는 경우에(상수) dest를 바꾸지 않는다면 바꾸기 위해서는 자신을 이용해서 업데이트하는 것으로 바꾸고 초기값은 i를 이용해서 바꾼다.
