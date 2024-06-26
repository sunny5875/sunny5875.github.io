# 14-2. software process

# 소프트웨어 개발 프로세스

소프트웨어 앞단계에 해당

- 소프트웨어를 개발하는 과정, 즉 작업 순서
    - 순서제약이 있는 작업의 집합
    - 높은 품질과 생산성이 목표
    
    프로세스, 단계, 과정, 순서가 있다. 분석이 끝나야 설계가 되고 설계가 되고 구현이 되는 것
    
    이유 – 품질과 생산성이 목표
    

소공 목적 : 고객인 원하는 품질좋은 소프트웨어를 on time, on budget으로 만족하기 위해서 소프트웨어 개발 단계를 잘 지켜서 개발하고 각 개발 단계 프로젝트 관리가 되어야하고 품질 보증이 되어야 한다(생산성)

목적을 만족시키기 위해서 세가지 조건이 필요 : 개발 프로세스, 프로젝트 관리, 품질 보증

최소한의 품질보증은 테스팅

↔ 프로세스가 없는 개발  : code and fix

![Untitled](14-2%20software%20process%20512ecd8f33e24e5faf8507e85ef10d7a/Untitled.png)

## code-and-fix

개발 프로세스가 없고 그냥 과제하는 것을 말함 한사람이 만들고 유지보수 안되고 아키텍처 만들 수 없는 그런 것, 전체 프로젝트 관리가 안되는 것

- 공식적인 가이드라인이나 프로세스가 없는 개발 방식
- 요구분석명세서나설계단계없이간단한기능만을정리하여개발하는형태
- 일단 코드를 작성하여 제품을 만들어본 후에 요구 분석, 설계, 유지보수에 대해 생각
- 주먹구구식 모델의 사용
– 개발자한명이단시간에마칠수있는경우에적합 – 대학수업의한학기용프로젝트정도
- 주먹구구식 모델의 단점
– 정해진 개발 순서나 각 단계별로 문서화된 산출물이 없어 관리 및 유지보수가 어렵다.
– 프로젝트전체범위를알수없을뿐더러좋은아키텍처를만들수도없다.
– 일을효과적으로나눠개발할수도없으며,프로젝트진척상황을파악할수없다.
– 계속적 수정으로 인해 프로그램의 구조가 나빠져 수정이 매우 어려워진다.

# 프로세스와 방법론 비교

Process, methodology

![Untitled](14-2%20software%20process%20512ecd8f33e24e5faf8507e85ef10d7a/Untitled%201.png)

프로세스 : 각 단게를 설명해놓은것,설계는 how에 초점을 두는 것 같은 것처럼 각 단계의 틀만 중점을 둬서 멀하는 가에만 초점을 두고 구체적인 거는 언급,방법론이 없음, 패러다임 방법론도 없고 순서만 있는 것, what에만 초점을 두는 것

방법론 : 어떻게 하는가 방법이 들어감, 객체지향 방법론, 구조적 방벌론 에자일 방법론이 있다는 것은 구체적인 설게하는 방법, 분석하는 방법, 나와야하는 문서의 포맷이 존재

프로세스는 그냥 요구분석, 유지보수, 테스트, 구현이 어떤 순서를 하고 그런 걸 그냥 프로세스라고 함

과정, 순서만 나오고 각 단계적으로 어떻게 하느냐는 방법론

순서만 나오는 것이고 각 단계를 어떻게 하는가는 방법론에 해당

# 소프트웨어 생명주기                                                             (SDLC, software development life cycle)

- 개발 계획 수립부터 최종 폐기 때까지의 전과정

**1)계획(관리)**

- 주 목적은 비용, 얼마나 걸릴지, 얼마나 많은 사람들이 필요할까, 잘못될 가능성이 있나 등등
- 범위 정하기
- 산정(estimation)
- 리스크 분석(중료)
- 일정 계획
- 관리 전략 수립

계획은 주로 management, 프로젝트 관리에 해당되는 것

**2)요구분석**

여기부터가 개발

- 요구 : 시스템이 가져야할 능력과 조건
- what의 단계로 도메인(응용 분야)에 집중
- 가장 중요하고도 어려운 단계 : 작은 차이가 큰 오류로 변함
- 결과물 : 요구 분석서(SRS)

가장 중요한 리스크가 제일 컨 걸 먼저

**3)설계**

- 요구불석에서 나온 What을 how로
- 솔루션에 집중
- 구현하기 전에 전체  설계를 진행
    - 아키텍처 설계
    - 데이터베이스 설계
    - UI 설계
    - 상세 설계
- 결과물 : 설계서(SD), 시스템 디자인이 나옴

**4) 구현**

- do it 단계
- 코딩하고 단위테스트
- 설계 혹은 통합단계와 겹치기도 함. 보통 단위테스트까지가 구현이기도 한데 통합까지 합쳐서 말하기도 함
- 특징 : 압력 증가, 최고의 인력 투입
    
    일정 짤 때 인력관리를 하는데 아무리 잘해도 결국 변경이 생기고 오류가 생기기 때문에 구현 단계에 가면 결국 일정에 압박을 받게 됨
    
    계속 개발자를 투입함, 이때 엄청 투입하는데 그만큼 효과는 없음
    
- 이슈
    - last minute change
        
        소프트웨어는 항상 변경, 유지보수, 다한 거 같은데 변경 생김(last minute change)
        
    - communication overhead
        
        개발자가 계속 투입됨 하지만 그만큼 효과는 없는 편( communication overhead) 앞부분부터 하지 않기 때문에 잘 모르기 때문에 다시 나가게 됨
        
    - 하청 관리

**5)통합과 테스트**

- 통합해나가면서 테스트 시작

통합은 빅뱅, top down, bottom up 등등이 있음

- 모듈의 통합으로 시작
- 점차 완성된 모듈을 추가
- 통합은 개발자가 주로 담당
- 테스트는 QA팀이 주로 담당
- 단계적인 테스트 : 단위, 통합, 시스템
- 목적 중심 테스트 : 스트레스 테스트, 성능 테스트, 베타 테스트, acceptance 테스트, usability 테스트
    
    목적 중심 테스트는 갑자기 부하를 주는 것, 만명이 최대인데 만천명으로 해보거나 등등
    

시스템 테스트까지는 개발자가 하고 인수는 사용자가 하고 품질 보증 팀이 주로 함

구현 끝나고 나서는 단위 테스트, 테스팅할 떄는 통합, 시스템이고 마지막에 사용자 테스트

**6) 설치 유지보수**

설치방법이 여러개 있고 이전할 떄 한꺼번에 보낼 건지 중심만 보내서 마이그레이션 할 것이냐 등등…

- 시스템 타입에 따라 다른 설치 방법
- 이전 정책
- 설치는 개발 프로젝트의 일부, 유지보수는 별개
    
    설치가 끝나고 나면 그 떄부터 유지보수 들어감, 유지보수 비용도 따로 산정됨
    
    설치까지는 개발 비용, 그 뒤부터 유지보수 비용
    
- 유지보수
    - 결함을 고침
    - 새 기능 추가
    - 성능 추가

→ 생명주기라고 하는데 이걸 어떤 순서로 나영할 것인가에 따라서 프로세스 모델이 달라짐

# 소프트웨어 개발 프로세스 모델

여러개가 있는데 그중에 대표적인 것이 대표적인 것을 프로세스 모델이라고 한다.

- 일반적인 모델이 될만한 프로세스를 기술한 것

프로세스 모양이 폭포같다 : 폭포수 모델

프로세스는 구체적으로 멀해야하고 산출물은 머고 이런 방법론은 없음.

프로세스 중에서 대표적인 거라서 모델이라고 함

## 1. 폭포수 모델(waterfall)

요즘은 이렇게 하는데는 없음, 혼자 과제할 떄는 이렇게 할 수 있음

![Untitled](14-2%20software%20process%20512ecd8f33e24e5faf8507e85ef10d7a/Untitled%202.png)

기본 프로세스를 그대로 가는게 폭포수 모델, 얘는 다음 단계까지 밖에 못 감. 다시 계획으로 뛰어가지를 못함, 거쳐가는 것만 가능, 한단계 전만 가능하고 설계하다가 계획으로 갈 수는 없다.

- 문제는 베이스라인이 딱 있어서 계획이 끝나면 요구분석, 얘가 완전히 끝나면 넘어가는데 만약에 계획을 갈 수는 있겠지만 앞단계까지 변경이 생기면 못감 : 대형프로젝트에서는 변경이 계속 생기기 때문에 사용 불가
- 1970년대 소개, 초기에만 사용함 ex) 나사, 항공 등에서 사용
    
    당시에는 프로젝트가 크지 않았고 도메인도 잘알고, 몇명 안되어서 상관없었음
    
- 각단계가 다음 단계 시작 전에 끝나야 함
    - 순서적 : 각 단계 사이에 중복이나 상호작용이 없음
    - 각 단계의 결과는 다음 단계가 시작되기 전에 점검
    - 바로 전단계로 피드백
        
        각단계는 다음 단계 시작 전에 끝나야 하고 피드백은 바로 전단계만 가능
        
- 단순하거나 도메인을 잘 알고 있거나 변화가 작은 경우, 요즘은 사용 불가능

결과물이 미리 딱 나와야 한다. 나중에 수정할 수 없으므로 베이스라인이 정확하게 나와있어야 한다

- 결과물 정의가 중요

**장점**

- 프로세스가 단순하여 초보자가 쉽게 적용 가능
- 중간 산출물이 명확, 관리하기 좋음
- 코드 생성 전 충분한 연구와 분석 단계
    
    관리자 입장에서는 편함
    

**단점**

- 처음 단계를 지나치게 강조할 경우 코딩, 테스트가 지연
    
    앞단계로 못 가니까 완전히 끝나는게 시간이 엄청 걸림, 다음 단계로 넘어가는게 힘듦
    
- 각 단계의 전환에 많은 노력
- 프로토타입과 재사용의 기회가 줄어듦
    
    중간에 만들어서 시연 불가능, 피드백이 불가하므로 많은 노력이 필요
    
- 소용없는 다중의 문서를 생산할 수 있음. 혹시 쓰일까봐 앞을 수정할 수 없기에 만드는 것
- 변화가 적은 프로젝트에 적합 ex) 혼자 공부하다가 과제할 때 쓰는 방법

대표적으로 중요하긴 함

## 2. 프로타이핑 모델

폭포수 모델은 단계 끝나서 가야 하고 잘못될 수도 있는데 폭포수는 큰일나기 때문에 구현하기 전에 요구를 미리 해보자, 구현하기 전에 미리 프로토타입을 만들어서 개선하고 평가한다. 평가해서 고치고 고친다. 프로토타입을 여러번해서 구현해서 설치

cf. 요즘은 어떤 방법론을 쓰든 프로토타입을 만들긴 함, 대표적인 모델이라서 나온 것

폭포수는 안맞다는 것을 구현되어서 아니까 프로토타입을 만들고 프로토타입을 만들다보면 만족이 되고 그걸로 구현

![Untitled](14-2%20software%20process%20512ecd8f33e24e5faf8507e85ef10d7a/Untitled%203.png)

- 프로토타입(시범 시스템, 시제품)의 적용
    - 사용자의 요구를 더 정확히 추출
    - 알고리즘의 타당성, 운영체제와의 조화, 인터페이스의 시험 제작
    
    리스크를 미리 테스트해볼 수 있음. 프로토타입으로
    
- 프로토파이핑 도구
    
    가장 기본적인 프로토타이핑 도구는 코드를 다 만드는 게 아니라 화면만 만듦, 화면 생성기, 코지 언어, 비주얼 프로그래밍, 4세대 언어, mfc, power builder 등등 코지 언어로 화면,이벤트 위주로 만드는 것
    
- 프로토 타입은 공동의 참조모델의 역할을 함
    - 사용자와 개발자의 의사소통을 도와주는 좋은 매개체
    - 프로토타입을 만들면 개발자와 사용자와 이해당사자와 보면서 얘기 가능해서 좋음
- 프로토타입의 목적
    - 단순한 요구 추출 : 만들고 버림
    - 제작 가능성 타진 : 개발 단계에서 유지 보수가 이루어짐
    
    요구사항 찾아서 버릴 수 있는게 프로토타입이고 리스크가 요즘은  크기 때문에 리스크 관리에도 프로토타입을 많이 씀 : 시스템이 가능한가, 알고리즘에 맞게 구현해보고나서 가능한다면 업그레이드 되니까 개발단계에서 유지보수 가능, 단순히 요구추출하면 코지 언어로 사용자에게 보여주고 버리면 되는데 리스크의 경우에는 계속 고치면서 수정 가능.
    

**장점**

- 사용자의 의견 반영이 잘 됨
- 사용자가 더 관심을 가지고 참여할 수 있고 개발자는 요구를 더 정확히 도출할 수 있음

**단점**

- 오해, 기대심리 유발
    
     프로토타입을 미리 보여줬기 떄문에 오해를 살 수 있음. 구현시 안될 수도 있으니까
    
- 관리가 어려움(중간 산출물 정의가 난해)
    
    폭포수와 달리 대신 관리가 어려움. 산출물이 난해함. 산출물을 베이스라인을 완전히 만들 수 없기 때문
    

**적용**

- 개발 착수 시점에 요구가 불투명한 경우
- 실험적으로 실현 가능성을 타진해 보고 싶을 경우
- 혁신적인 기술을 사용해보고 싶은 경우

프로토타이핑 모델을 그대로 쓰는게 아니라 다 프로토타입을 만들어보기도 함.

리스크가 크기 때문에 리스크가 감당한지를 프로토타입핑하기도 함, 리스크 관리에도 사용됨

## 3. 진화적 모델

- 개발 사이클이 짧은 환경
    - 빠른 시간안에 시장에 출시하여야 이윤에 직결
        
        Time to market, 개발 사이클이 짧은 환경, 개발 시간이 짧아 시장에 빨리 진출해야하는 경우에 좋음
        
    - 개발 시간을 줄이는 방법 : 시스템을 나눠서 릴리즈
        
        전체를 다 개발하는게 아니라 부분만 개발, 점점 확대시켜 나가는 것
        

시스템을 나누어서 릴리즈함 전체가 아니라 나누어서 배포

![Untitled](14-2%20software%20process%20512ecd8f33e24e5faf8507e85ef10d7a/Untitled%204.png)

**릴리즈 구성 방법**

- 점증적 방법 : 기능별로 릴리즈, 우선순위에 따라서
- 반복적 방법 : 릴리즈 할 때마다 기능의 완성도를 높임,  핵심을 만들어놓고 더 보강하는 형식으로 할 수도 있다

기능별로 할 것인지 완성도를 높이는가

**단계적 개발**

- 기능이 부족하더라도 초기에 사용교육이 가능
- 사용자의 요구를 빠르게 반영할 수 있음
    
    사용자 요구를 빠르게 반영해서 time to market을 줄일 수 있다.
    
- 처음 시장에 내놓는 소프트웨어는 시장을 빨리 형성시킬 수 있음
- 자주 릴리스하면 가동 중인 시스템에서 일어나는 예상하지 못했던 문제를 신속 꾸준히 고쳐나갈 수 있음.
- 개발팀이 릴리스마다 다른 전문영역에 초점 둘 수 있음.
    
    개발팀이 릴리즈마다 릴리즈를 어떻게 구성하는가에 따라서 다른 전문가를 데려올 수 있다
    

출시는 이렇게 안하지만 구현관점에서는 한꺼번에서 안하고 릴리즈별로 구현해서 나중에 합치기는 함

## 4. 나선형 모델(spiral)

리스크가 큰 프로젝트에서 사용

![Untitled](14-2%20software%20process%20512ecd8f33e24e5faf8507e85ef10d7a/Untitled%205.png)

계획 -> 위험분석으로 일차 위험분석을 함-> 리스크가 발견, 자바 개발자가 없네?제일 중요한 리스크를 구현한 프로토타입을 개발 -> 만족하는지 평가 -> 평가결가를 가지고 계획, 요구 분석 -> 2차 위험 분석 -> 프로토타입 개발 -> 쓸지 말지 판단 -> 계획 짜기 → 반복

첨에 계획을 먼저 하고 위험 분석하고 개발 평가하고 다시 계획하고 위험 분석하고 하면서 진화적으로 반복

- 소프트웨어의 기능을 나누어서 점증적으로 개발
    - 실패의 위험을 줄임
    - 테스트 용이
    - 피드백
- 여러번의 점증적인 릴리스(incremental releases)

**진화단계**

- 계획수립(planning):목표,기능선택,제약조건의결정
- 위험분석(riskanalysis):기능선택의우선순위,위험요소의분석
- 개발(engineering):선택된기능의개발
- 평가(evaluation):개발결과의평가

위험분석 나오면 나선형 모델, 테스트에 용이하고 대규모, 리스크가 큰 거에 적합

전체를 한번에 테스트 하는 것이 아니라 점진적으로 하는 것

**장점**

장점은 대규모 시스템, 리스크가 큰 편인데 한 사이클에 못한 기능을 다음단계에 할 수 있다. 

- 대규모 시스템 개발에 적합
- risk reduction mechanism
- 반복적인 개발 및 테스트
- 강인성 향상
- 한 사이클에 추가 못한 기능은 다음 단계에 추가 가능

**단점**

폭포수와 반대, 베이스라인이명확하지 않아 산출물이 정확하게 나와있지 않은 편, 위험분석이 쉽지 않은 편

- 재정적 또는 기술적으로 위험 부담이 큰경우
- 요구 사항이나 아키텍처 이해에 어려운 경우

## 5. V 모델

개발단계에서 해당하는 테스팅을 염두

폭포수는 산출물 중심이라면 얘는 테스트 검증이 초점

![Untitled](14-2%20software%20process%20512ecd8f33e24e5faf8507e85ef10d7a/Untitled%206.png)

- 폭포수 모델 + 테스트 단계 추가 확장
    - 소프트웨어개발단계의순서와짝을이루어테스트를진행해나가는방법
    - 프로젝트초기단계부터테스트계획을세우고,테스트설계과정이함께진행
- 산출물 중심(폭포수 모델) vs 각 개발 단계를 검증하는 데 초점(V 모델)

**장점**

- 오류를줄일수있음

**단점**

- 반복을 허용하지 않아 변경을 다루기가 쉽지 않음

**적용**

- 신뢰성이 높이 요구되는 분야

→ 오류를 줄일 수 있지만 하지만 폭포수 모델이기에 변경을 다루기 어려워서 잘 쓰지 않음

## 6. unified 프로세스

Up 다음 나온게 uml

![Untitled](14-2%20software%20process%20512ecd8f33e24e5faf8507e85ef10d7a/Untitled%207.png)

다 넣어놓은 건데 비지니스 모델링(계획), 요구분석, 설계 등등… 이걸 여러번 점진적으로 하는 것

![Untitled](14-2%20software%20process%20512ecd8f33e24e5faf8507e85ef10d7a/Untitled%208.png)

- 앞부분은 도입단계 그다음은 정련, 구축, 전환으로 구성
- 도입단계에서는 프로젝트 관리와 요구분석과 설계를 많이하고 정련단계에서는 비지니스 모델링 등등을  걸 하고 프로젝트 관리는 전체적으로 많이 하고 형상관리는 적게 하고 등등
- 정련은 요구분석과 설계를 주로 수행
- 구축에서는 구현테스팅 설치
- 전환은 테스팅 설치를 주로 함, 형상관리를 주로함.

각 단계마다 하긴 다 하며 릴리즈가 나옴. 주로 포커스가 다른데 사실 모든 단계에서 다하고 그 때마다 릴리즈가 나온다.앞에는 리스크가 제일 크고 그다음에서는 그다음 리스크 ….

이상적인 것이였고 릴리즈가 나올 떄마다 합치는데 문서작업을 잘해야 하고 아키텍처 설게를 완전 잘해야하고 이상적이어야 한다. 아키텍서설계나 분석에 시작이 많이 걸리며 명세서가 나와야 하므로 문서작어이 많고 구현이 잘 안됨. 가장 위험성이 높은 것으 release 1, 그 다음 리스크 …

이상적이기에 구현을 하지만 앞 단계에서 많이 허덕임.  요구분석을 많이 하기 떄문에  아키텍처 설계, 분석에 시간이 많이 걸리고 문서작업이 엄청 많고 앞에가 잘되어야 하므로 구현이 잘 안됨. 엄청 거대한 프로젝 트에 해당 앞에를 고칠 수는 있지만 인건비가 드니까 잘 못함

특징은 기존의 유명한 세개를 다 합쳐놓은 것, 사용사례 중신 udd, 아키텍처 중심(그다음 단계 넘어가기  힘든 편), 반복적 점증적

- 사용 사례 중심의 프로세스
- 시스템 개발 초기에 아키텍처와 전체적인 구조를 확정
- 아키텍처 중심
- 반복적, 점증적

이거에 질려서 나온 게 에자일

- 산출물이 나와야해서 구현으로 못넘어가니까 구현하고 나서 개발 후에 문서를 만들자, 비용은 드는데 코딩해야하는데 산출물 작성해야하니까!

## 7. 에자일 프로세스

요즘은 유피즘에 에자일을 사용

- 유피를 썼더니 문서작성도 많이하고 너무 늦게 나오니까 처음부터 고객과 같이 한다
    
    대표적인 게 tdd, 옆에 끼고 이거 맞아요? 이러는 것
    
- 고객의 요구에 민첩하게 대응하고 그때그때 주어지는 문제를 풀어나가는 방법론
- 애자일의 기본가치(다 유피의 반대)
    - 프로세스와 도구 중심이 아닌 개개인과의 상호소통 중시
    - 문서 중심이 아닌 실행 가능한 소프트웨어 중시
    - 계약과 협상의 중심이 아닌 고객과의 협력 중시
    - 계획 중심이 아닌 변화에 대한 민첩한 대응 중시

빨리 빨리 사용자의 요구사항을 받아들어서 프로토타입을 보여주고 맞으면 넘어가고 아니면 버리는 형태

결국 에자일도 릴리즈를 쪼개서 하는 건 똑같은데 릴리즈 주기가 관계를 두달인 경우는 유피인데 에자일은 2주,4주, 한달 넘어가지 않음. 빨리 결과 보여주는 형태아니며 버리고 맞으면 업데이트

- 사용사례, 사용자 스토리, 피러 단위
- 테스트 중심 개발(test driven development, tdd)

![Untitled](14-2%20software%20process%20512ecd8f33e24e5faf8507e85ef10d7a/Untitled%209.png)

유피는 계획 짜고 아키텍처 설계하는데 에자일은 테스트해보면서 나아가는 편 지속적인 커뮤니케이션과 테스팅한다

조그맣제 쪼개서 커뮤니케이션하면서 피드백하고 요구를 받아들여서 프로덕트를 만듦. 유피는 팀 구성도 커지는데 구성도 짧고 빨리 적응할 수 있도록 하는 편

제일 많이 쓰는 편이지만 다른 것도 다 같이 쓰는 편

유지보수 프로세스 모델 정의와 특징 알면 됨