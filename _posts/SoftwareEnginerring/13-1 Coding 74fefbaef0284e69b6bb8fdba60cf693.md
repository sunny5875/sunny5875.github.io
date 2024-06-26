# 13-1. Coding

개발 프로세스 중에서 요구사항 찾고 분석하고 설계하고 코딩하고 테스트하는데 오늘부터는 코딩할 거

설계 시 아키텍처 설게하고 부분 설계하고 서브시스템, 클래스, 메소드 설계를 하는데 설계 시 그냥 설계하는 것이 아니라 보통 유명한 사람들이 설계문제에 부딫혔을 때 주로 디자인 패턴을 적용해서 해결

프레임워크 알아야 하고 설계 끝나고 나서 설계문서를 보고 개발자들이 코딩을 시작할 것

# Coding

- 분리하여 구현할 수 있는 작은 단위를 프로그래밍 하는 작업
- 설계 명세에 나타낸 대로 요구를 만족할 수 있도록 프로그래밍

## 코딩 과정

![Untitled](13-1%20Coding%2074fefbaef0284e69b6bb8fdba60cf693/Untitled.png)

1) 코딩의 표준을 정의함. 명명규칙이라든지 들여쓰기를 얼마나 할것인지 함수의 매개변수 후 중괄호를 옆에 할 것인지 밑에 할 것인지 결정, 아키텍처의 가이드도 고려하고 코딩 표준을 코딩단계에 적용하고 설계단계를 보면 프레임워크 패키지가 있고 거기에 응용패키지가 설계로 나와있으면 프레임워크 패키지는 아키텍처 팀에서 제일 먼저 구현하고 그 위에 올라오는 응용 패키지를 다음에 구현. 

2) 각 패키지 안에 클래스들이 있고 그 클래스들을 구현할 거인데 결국 메소드를 구현. 구현 시 상세설계에 나온  수도코드나 명세서를 보고 구현

3) 코딩이 끝나고 나면 개발자 각각이 자신의 코드를 인스팩션, 검토하고 팀별로 돌아가면서 인스팩션함. 구조적방법에서도 코드 인스팩션가 있는데 실행하지 않고 소스코드를 읽으면서 확인하는 것, 나혼다 코딩하는게 아니라 서로의 코드를 봐준다. 다른 사람의 코드의 오류는 잡기 쉽고 다른 사람의 코딩방법을 보면서 잘하는 사람의 노하우도 얻을 수 있음 

4) 코드 인스팩션이 끝나면 혼자서 단위 테스트함, 자기가 구현한 클래스를 테스크해본다. 

5) 통합하기 위해서 릴리즈, 배포함

→ 중요한 것은 표준을 정해서 표준에 따라서 디자인단계에서 나온 문서로 클래스, 메소드를 구현하고 끝나고 나서 클래스 인스팩션 후 단위테스트를 한다

## 코딩 표준의 장점

- 높은 가독성
    - 가독성 : 인쇄물이 얼마나 쉽게 읽히는가 하는 능률의 정도
    - 프로그래밍에서의 가독성은 프로그램을 읽기 쉬운 정도
    
    → 주석, 적절한 줄 바꿈, 들여쓰기, 적절한 공백 사용
    
- 간결하고 명확한 코딩
    - 유지보수 향상
- 개발 시간의 단축
    - 개발과정에서의 정확도 및 효율의 향상 → 개발 시간 단출

표준을 만드는 이유는 혼자서 코딩하는 것이 아니기에 가독성을 높이기 위해. 유지보수 비용을 줄이는 첫번째 방법이 높은 가독성임. 가독성을 높일려면 주석을 쓰고 줄바꾸고 들여쓰기 해주고 공백쓰는 것, 그리고 카멜체로 할건지 변수 시작은 멀로 할 것이지 등등…

Ex) 탭 하나만 쓸 것인지 중괄호를 내릴 것인지 등등 전체 포맷을 맞춰서 다른 사람이 봐도 보기 편하도록

# Code Inspection

클래스를 다 구현한 후 실행하기 위해서 테스트 하기 전에(실행시키기 전에 ) 먼저 실행 코드를 실행하지 않고 검토, 결함이나 좀 더 줄이는 방법, 팀별로 돌아가면서 하는 편

Code inspection을 하면 품질을 높일 수 있고 노하우를 얻을 수 도 있다. 넘기는 경우가 많지만 하는 걸 추천

- 코드를 실행하지 않고 사람이 검토하는 과정을 통하여 코드 상에 숨어있는 잠재적인 결함을 찾아내고 개선하는 일련의 과정
- 소프트웨어 품질을 높일 수 있고 다른 사람의 코드를 통해 여러가지를 배울 수 있음

# refactoring

코딩은 코딩 규칙에 맞게 설계도를 보고 코딩하면 된다. 요즘은 코딩 시 리팩토링이라는 과정을 거침. 리팩토링은 실행결과는 바뀌지 않지만 프로그램의 구조를 뜯어 고치는 것, 이건 설계단계가 아니라 코딩 한 다음에 결과는 그대로이지만 프로그램을 쉽게 이해하고 변경을 쉽게 할 수 있도록 하는 것, 변경이 앞으로 발생하면 변경에 대처할 수 있도록 설계해야 한다.  결과적으로 변경이 또 생길 것인데 생길 때 잘 변경될 수 있도록 하려고 프로그램의 내부구조를 수정

- Refactoring은 프로그래밍의 행위를 변경하지 않으면서 프로그램 을쉽게이해하고변경할수있도록프로그램의내부구조를수정 하는 것을 의미한다.
    
    리팩토링은 존재하는 코드(설계 no, 코딩 단계에서 수행) 코드의 실행결과는 동일하게 나오지만 구조를 좀 더 좋게 변경, 혹은 이해하기 쉽게 뜯어고치는 것
    
    - 고프의 디자인패턴은 패턴의 context가 있는데 그 상황에서 해결할 수 있는 클래스, 시퀀스 다이어그램과 예제가 나와있는데 리팩토링도 카탈로그 방식으로 이럴 때에는 이렇게 하세요~ 해놓음.
- 개발자는 refactoring을 사용하여 프로그램을 이해하기 쉽고 변화를 포용할 수 있도록 단계적으로 개선할 수 있다.
– 결과의 변경없이코드의구조를재조정
    
    – 이미 존재하는 코드의 디자인을 안전하게 향상시키는 기술
    
     – 가독성을높이고유지보수를편하게하기위한것
    

개발자는 코딩단계에서 리팩토링을 해서 프로그램을 이해하기 쉽고 변화를 표용할 수 있도록 단계적으로 개선

디자인 단계에서 하는 게 아니라 코딩 단계에서 하는 것!

## refactoring의 효과

- 소프트웨어 설계 품질 개선
- 소스 이해하기가 쉬워짐
- 버그를 발견하기 쉬워짐
- 프로그램을 더 빠르게 개발 가능

## refactoring 순서

- 소스코드를 관찰하여 이해하기 어렵거나 추후에 쉽게 변경하기 어려운 코드 조각(bad code smells)를 꼼꼼히 찾는다

ex) 로직이 중복되면 함수로 만들어야 한다. 변수와 함수가 중복되면 클래스로 만들어야 한다.

- 문제가 있는 코드를 발견하면 해결할 방법을 선택하여 수정
- 제대로 동작하는지 테스트하고 확인

### bad code smellls

ex) 중복된 것! If문이 많다. 타입이나 클래스 타입이 들어가면 다형성을 적용해야 한다!

- 개발자가 이해하거나 유지보수하기 어렵게 만드는 것
- 읽기 어려운 프로그램
- 중복된 로직을 가진 프로그램
- 복잡한 조건문이 포함된 프로그램

→ 리팩토링으로 해결될 수 있는 문제가 있다는 징후

![Untitled](13-1%20Coding%2074fefbaef0284e69b6bb8fdba60cf693/Untitled%201.png)

![Untitled](13-1%20Coding%2074fefbaef0284e69b6bb8fdba60cf693/Untitled%202.png)

클래스가 여러 책임을 가지고 있지 않는지 확인

파라미터 수가 너무 많으면 그것도 이상 ->파라미터를 묶어서 클래스를 만들 수 있지 않을까?

## Refactoring vs Design pattern

- 리팩터링은 코딩단계에서 디자인은 설계단계에서
- 공통적으로 변화를 포용할 수 있는 유지보수성이 뛰어난 소프트웨어의 완성

### design pattern

- 디자인 패턴은 설계단계에서 적용, OCP한 코드를 만드는 것
- 설계 단계에서 확장성과 재사용성이 높은 소프트웨어 구조에 대해 고민하여 어떤 design pattern을 적용하면 그것이 성취되는지 결정하려함

### refactoring

- 이미 만들어져있는 소스코드에 refactoring을 적용하여 이해하기 쉽고 변경을 포용할 수 있는 구조로 변경
- 소스코드를 보면서 문제가 있는 코드를 계속 변화시켜 나감

→ 리팩토링의 결과로 만들어진 프로그램에 design pattern이 적용되는 경우가 많음

리팩토링 하다보면 결국 디자인패턴처럼 되는경우가 많음. 결국 디자인패턴을 잘 설계되면 문제가 없을텐데 그냥 로직만 돌아가게 한다면 결과가 디자인패턴이 적용된 결과 코드가 나온다는 것!

리팩토링의 목적은 변화에 포용하기 쉽게끔 적용하기 쉼게끔 품질 좋은 소프트웨어 등등의 목적인데 그 중이 디자인패턴. 즉, 리팩토링을 적용하면 디자인 패턴을 적용한 코드가 나오게 된다는 것