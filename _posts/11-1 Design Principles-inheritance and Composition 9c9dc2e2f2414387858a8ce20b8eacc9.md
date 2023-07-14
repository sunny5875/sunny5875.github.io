# 11-1. Design Principles-inheritance and Composition

오늘은 설계부분을 할것

지난시간에는 아키텍처 설계에 대해서 배웠는데 서브 시스템은 어떤 식으로 연결되고 가이드라인, 큰 덩어리 설계에 대해서 배웠고 오늘은 상세 설계 전에 설계의 기본원리와 객체 설계의 기본에 대해서 배울 것

# 설계 원리

기본적으로 소프트웨어 개발 시 원리는 일반적인 설계 시 원리 4가지를 말하는 것

## **1) 단계적 분할(stepwise refinement)**

- 문제를 상위개념부터 더 구체적인 단계로 하향식으로 분해하는 기법

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled.png)

처음에는 큰거 점점 쪼개나가는 것, 아키텍처 설계 후에 컴포넌트 설계하는 거처럼 첨에는 큰덩어리로 나눈 뒤 점점 줄이는 것

일반적으로 문제를 해결할 떄 기본적으로 하는 것

종합시스템을 만들려면 큰 도메인이 된 업무로 나누고 더 작게 나누는 방법

## 2) 추상화(abstraction)

- 필요한 부분만을 표현할 수 있고 불필요한 부분을 제거하여 간결하고 쉽게 만드는 작업

가장 기본적인 건데 필요한 부분만 표현하고 구체적이고 세세한 부분은 할 핉요가 없다

객체를 추상화해서 클래스를 만드는 거처럼!

소프트웨어 공학에서 추상화하는 방법에는 세가지가 존재

### 2-1) 기능 추상화(procedure abstraction) - 알고리즘,함수

- 모듈이 수행하는 기능(절차)를 추상화한 것

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%201.png)

기능 절차를 추상화한 것, 알고리즘을 만들 때에는 구체적인 파일명이나 변수를 쓰지않고 중요한 부분만 추상화시켜서 표현

함수호출도 기능 추상화임, getSum이라는 것은 10까지 더하는 건데 이건 복잡하니까 함수 호출로 끝내도로 하는 것

### 2-2)자료 추상화(data abstraction) - 클래스

- 자료 객체 외부에선 내부의 내용은 가려져 있고 자료에 대한 오퍼레이션만 볼 수 있게 추상화한 것

클래스 추상화, 자료는 외부에서 보여주지 않고 operation만 제공하는 것, 외부에 연산을 보여주지 않는 것, 메소드만 알려주고 불필요한 연산은 감춰주는 것

- 클래스의 특징
    - 사용자에게 클래스가 제공할 수 있는 사용법만 알려주고 불필요한 데이터와 연산은 감춤
    - 사용자는 클래스에서 제공하는 연산기능만을 알고 있고 그 연사응ㄹ 이요해서 데이터를 변경

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%202.png)

### 2-3) 제어 추상화(control abstraction)- 기계어 → 어셈블리→ hhl

- 프로그램의 액션(제어 구조)를 추상화한 것

언어의 발전 사항, 기계어를 추상화시켜서 어셈블리로 표현하고 이걸 더 추상화하면 언어로 추상화

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%203.png)

## 3)모듈화(modularization)

C에서도 모듈화하고 함수도 모듈화하며 자바랑 c++도 클래스로 모듈화하고 등등..

자기 기능을 가지면서 대체 가능한 것 : 모듈 (파일, 클래스,함수, 컴포넌트 등등 가능)

전체를 한꺼번에 하는 것이 아니라 기능별로 모듈화한다

- 시스템을 구별된 모듈들로 나누는 것
    - 모듈화를 하면 각각의 모듈을 별개로 만들고 수정할 수 있기 때문에 좋은 구조가 됨
    - 분할과 정복 divide and conquer의 원리가 적용되어 복잡도 감소
    - 문제를 이해하기 쉽게 만듦
    - 변경하기 쉽고, 변경으로인 한영 향이 적음
    - 유지보수가 용이함
    - 프로그램을 효율적으로 관리할 수 있음
    - 오류로 인한 파급효과를 최소화 할 수 있음
    - 설계 및 코드를 재사용할 수 있음
- ✏️**좋은 모듈 설계를 위한 원칙**
    - 모듈 간 결합(coupling)은 느슨하게(Loosely)
    - 모듈 내의 구성요소 들간의 응집도(coheison)은 강하게(strongly)
        
        → 결합도는 낮고 응집도는 높게!!!
        

## 3-1) 모듈화 : 모듈 간 결합, 결합도, coupling⬇️ good!

- 모듈과 모듈 사이의 관계에서 관련 정도

하나의 모듈이 수정되면 다른 모듈이 영향을 받는 정도

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%204.png)

낮은게 좋으며 높으면 유지보수하기 어렵다

종류에는 5가지가 존재하고 내려갈수록 결합도가 커진다

### 3-1-1)Data coupling, 자료 결합

- 가장 좋은 모듈 간 결합
- 모듈들이 매개변수를 통해 데이터만 주고받음으로써 서로 간섭을 최소화하는 단계
- 모듈 간의 독립성 보장
- 관계가 단순해 하나의 모듈을 변경 시 다른 모듈에 미치는 영향이 아주 적음

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%205.png)

### 3-1-2)Stamp coupling, 스탬프 결합

- 두 모듈 사이에서 정보를 교환 시 필요한 데이터만 주고받을 수 없고 스탬프처럼 필요 없는 데이터까지 전체를 주고 받아야 하는 경우

하나의 모듈에서 다른 모듈과 정보를 주고받을 때 데이터 전체를 주고 받는 것 ex) 데이터구조, struct

어원 -외국에서 스탬프를 찍는 경우가 많읁데 회사의 이름 ,주소, 번호까지 다 있는데 나는 주소만 보내고 싶지만 스탬프를 찍으면 다 같이나라간다. -> 안좋아, 불필요한 정보까지 같이 나가니까

→ 필요없는 데이터를 주고받아야한다

구조체가 결국은 객체지향의 크래스가 되므로 낱낱의 데이터가 반드시 같이 가야한다면 구조체를 넘기는게 더 나을 수도 있음.하지만 다 안쓰인다면 문제가 생길 수 있다

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%206.png)

### 3-1-3)Control Coupling, 제어 결합

- 제어플래그를 매개변수로 사용하여 간섭하는 관계
- 호출하는 모듈이 호출되는 모듈의 내부구조를 잘 알고 논리적으로 흐름을 변경하는 관계
- 정보 은닉을 크게 위배하는 결합으로 다른 모듈의 내부에 관여하여 관계가 복잡

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%207.png)

1이면 덧셈, 2면 뺄셈, 이런거처럼 어떤 연산하게 원하는지를 플래그로 전달

그러면 내부의 로직을 알고 있어야한다-> 결합도가 높다

기능을 쪼개는 것이 낫다

### 3-1-4)Common Coupling, 공통 결합

- 모듈들이 공통변수(전역변수)를 같이 사용하여 발생하는 관계
- 변수 값이 바뀐다면 모든 모듈이 함께 영향을 받음

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%208.png)

### 3-1-5) Content Coupling, 내용 결합

- 모듈 간에 인터페이스를 사용하지 않고 직접 왔다갔다하는 경우의 관계

직접와다갔다 하는 것, goto문으로 바로 가는 경우 이게 제일 안좋음

- 상대 모듈의 데이터를 직접 변경할 수 있어 서로의 간섭을 가장 많이 하는 관계

ex) goto 문

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%209.png)

→ Data coupling이 제일 좋고 아래로 갈수록 좋지 않다

## 3-2) 모듈화 : 모듈의 응집, 응집도, cohesion⬆️ good!

모듈 하나가 하나의 일만 해야한다

- 모듈 내부에 존재하는 구성요소들 사이의 밀접한 정도

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%2010.png)

### 3-2-1) functional cohesion, 기능적 응집

- 응집도가 가장 높은 경우이며 단일 기능의 요소로 하나의 모듈로 구성

기능별로 하나의 역할만 해야 한다

클래스도 하나의 일만, 컴포넌트도 동일

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%2011.png)

### 3-2-2)sequenctial cohesion, 순차적 응집

- 모듈 안에 하나의 소작업에 대한 결과가 다른 작업의 입력이 되는 경우

두개의 요소가 조금 기능이 다르지만 첫번째 출력이 두번쨰 요소의 입력이 되는 경우 

→ 두 요소가 아주 밀접하므로 하나의 모듈로 묶을 만한 충분한 이유가 된다

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%2012.png)

### 3-2-3) communication cohesion, 교환적 응집

- 동일한 입력과 출력을 사용하는 소작업들이 모인 모듈
- 순서는 중요하지 않음

여러개 모듈이 동일한 데이터를 사용

데이터가 바뀔 때마다 영향을 끼치므로 하나로 합치는 게 낫다

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%2013.png)

### 3-2-4)procedural cohesion, 절차적 응집

- 모듈 안의 작업들이 큰 테두리 안에서 같은 작업에 속하고 입출력도 공유하지 않지만 순서에 따라 실행되는 것
- 순차적 응집과 달리 어떤 구성요소의 출력이 다음 구성요소의 입력으로 사용되지 않고 순서에 따라 수행만 됨

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%2014.png)

입출력은 상관없이 순서가 존재

기능이 다르지만 첫번쨰 모듈 -> 두번째 모듈 -> 세번쨰 모듈 순서가 존재하는 경우

이전은 출력이 입력이 되니까 문제가 되는 거여고 얘는 일의 순서가 이렇게 되는 것

응집도는 떨어지지만 묶는게 낫다

### 3-2-5) temoral cohesion, 시간적 응집

- 모듈 내 구성요소들의 기능도 다르고 한 요소의 출력을 입력으로 사용하는 것도 아니고 요소들 간에 순서도 정해져 있지 않지만 같은 시간대에 함께  실행된다는 이유로 하나의 모듈로 구성

관계는 없는데 시간대가 함꼐 실행되는 경우

특정 시간대에 식사하고 출근하는 것들은 묶는 게 낫다. 묶는게 낫다

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%2015.png)

### 3-2-6) logical cohesion, 논리적 응집

- 모듈 간 순서와 무관, 한 모듈의 출력을 다른 모듈의 입력으로 사용하는 것도 아니지만 요소들 간에 공통점이 있다거나 관련된 임무가 존재하거나 기능이 비슷하다는 이유로 하나의 모듈 구성

![Untitled](11-1%20Design%20Principles-inheritance%20and%20Composition%209c9dc2e2f2414387858a8ce20b8eacc9/Untitled%2016.png)

상관이 없는 데 비슷한일을 하는 것, 공통점이 있다면 묶을 수 있다

### 3-2-7)concidentqal cohesion, 우연적 응집

- 구성요소들이 말 그대로 우연히 모여 구성
- 특별한 이유없이 크기가 커 몇개의 모듈로 나누는 과정에서 우연히 같이 묶인 것

이렇게 하면 안된다, 우연으로 이유없이 묶인 것

### 모듈 간의 좋은 관계

⇒ 소프트웨어 설계 시 모듈화해야하는데 모듈은 컴포넌트, 파일 등이 되지만 결합도는 낮고 응집도는 높아야한다

모듈이 주고받을려면 인터페이스, 매개변수로 주고받아야하고 한가지 일만 하는게 제일 좋다

설계방법에는 굉장히 많은데 그 중에서 객체지향 설계를 볼 것