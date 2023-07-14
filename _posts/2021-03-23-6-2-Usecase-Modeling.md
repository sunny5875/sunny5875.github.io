---
layout: post
title: 6-2. Usecase Modeling
date: 2021-03-23 19:20:23 +0900
category: SoftwareEngineering
---
# 6-2. Usecase Modeling

# 유스 케이스 모델의 작성

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled.png)

- 유스케이스 다이어그램은 **사용자의 요구사항**을 찾을 때 사용
    - 시스템이 제공해주는 기능, 사용자들의 요구
- 프로젝트 참여 이해 당사자들의 요구들이 유스케이스 하나하나에 맵핑됨
    
    고객과 사용자 등등의 모든 이해관계자가 모여서 요구를 줄 것이고 얘를 모델링하는 것이 유스케이스 모델, 이해관계자가 엑터
    

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%201.png)

← 교수는 구매희망도서신청, 소장자료검색 등등을 할 수 있고 이렇게 그릴 수도 있고 다듬어서 좀 더 구조화된 걸 그릴 수도 있다.

# 기본개념

# 액터(Actor)

- 개발하려는 시스템과 상호작용(interaction)하는 시스템 외부 존재
- 엑터는 구현하는 범위가 아님, 우리는 시스템만 구현함

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%202.png)

우리 시스템과 관련있는 엑터 1는 시스템에 입력해서 사용하는 것, 만든 결과를 엑터 2와 3에게 주는 것

Ex) 도서관리 시스템

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%203.png)

- 상호작용하는 것들인 액터(롤네임)에는  대출 신청하는 학생, 신작 도서를 등록하는 사서
- 도서관리 시스템에서 도서대출이 가능하면 외부의 sms 시스템을 이용해서 통보, 이 또한 개발하는 것이 아님
- **액터는 개발 대상이 되는 시스템에 따라서 달라질 수 있음**

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%204.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%205.png)

atm 시스템의 액터)

Atm기에서는 atm기를 사용하는 사람, 현금보충하는 관리자 롤네임, atm기는 이체 등등을 하기 위해 계좌정보는 은행서버에 있으므로 얘한테 요청을 받는 것 여기서 은행서버는 엑터

은행서버 시스템의 액터)

우리가 개발하는게 은행서버라면? 이제는 atm 시스템이 액터가 될 것

실제 창구직원은 실제로 은행서버 시스템에 접근해서 이체 입금할 것

→ 개발하는 것에 따라서 엑터는 달라진다.

**액터를 정한다는 것 == 시스템 바운더리를 정한다는 것**

## 액터의 유형

### 사용자, 외부 시스템

액터의 기본 유형은 사용자이거나 외부 시스템임

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%206.png)

도서관리의 경우)

학생이 도서를 신청하고 등록하는 사서(이 때 구체적 이름이 아니라 롤네임을 씀) 자동대출반납기로 내면 시스템에 반납하는 것

학생은 도서 대출신청만 할 수 있고 반납은 못하게 됨. 이것은 외부환경이니까 안그려도 되지만 근데 이해하기 위해서 그린 것

도서 대출은 첨에 못했다가 신청이 되면 대출가능하다고 알려주는 것은 액터한테 직접 알려주는 것이 아니라 sms를 통해서 알려줌. 이것도 우리가 구현하는 게 아님! (되게 중요한 부분)

### 장치

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%207.png)

요즘 iot, 임베디드가 많아서 장치의 유형이 있는 경우도 존재. 사람이 목적지층을 선택하면 가동하게 되는데 모터한테 이동하라고 하던가 도착한 걸 감지하면 도착했다고. 알려주거나 문을 열거나 닫아라 등의 기능을 하는 디바이스도 액터로 사용 가능

→ 액터는 사용하고 의사소통하는 외부 시스템, 사용자, 장치를 말함

# 유스케이스(usecase)

- 개발 대상이 되는 **시스템이 제공하는 개별적인 기능**
- 액터가 개발하려는 시스템을 어떻게 사용하는지, 사용사례

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%208.png)

엑터가 개발할 시스템을 사용하는 것, 기능 동그라미 하나가 사용사례, 사용자에게 제공해야 하는 기능을 말함

- 유스 케이스로 표현된 기능은 시스템의 **사용자가 이용**

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%209.png)

도서관리 시스템(바운더리를 정해야 하고 이게 매우 중요함, 그 안만 구현함)-> 도서관리 시스템은 도서대출신청과 같은 사용사례들이 여러개 묶여 있고 액터와 인터렉션함

사서라는 액터는 신착도서 등록라는 사용사례를 이용한다 이때 신착도서 기능은 sms 시스템을 사용한다

여기서 Sms가 학생한테 보내는 것은 구현하지 않음

- 유스케이스 다이어그램에서는 유스케이스의 기능과 이를 이용하는 액터를 **연관관계(association)**을 이용해서 명시적으로 표현

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2010.png)

시스템이 해야하는 기능은 4가지이고 여기서 세개의 기능은 atm사용자은 유스케이스와 연관관계가 있다. atm사용자가 이 기능을 activate한다(활성화한다, 사용한다). 기능 세가지를 하다 보면 외부에 있는 은행서버 시스템에게 요청하게 된다. 그리고 Atm 관리자는 현금보충 기능을 사용한다.(방향유의)

유스케이스 기능을 엑터가 사용하거나 의사소통한다.

이 세가지 기능은 결국 외부 시스템에게 요청 하는 등 인터렉션이 있다

→ 액터와 유스케이스는 연관관계가 있다

- **시스템의 전체 기능적 요구사항은 표현된 유스케이스로 구성됨**
    - 유스케이스 다이어그램에서 **유스케이스로 표현되지 않은 것은 시스템이 제공할 기능 범위에서 제외**
        
        ![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2011.png)
        

바운더리로 표현된 것만 구현, 신착도서, 도서대출만 구현하면 된다 반납은 없으니까 구현하면 안된다.

요구사항 찾게 되면 유스케이스 다이어그램과 명세서가 나오게 되면 사용자와 해서 도장찍는다 매우 중요

## 액터와 유스케이스 간의 관계

- 액터와 유스케이스 간의 연관 관계는 둘 간의 상호작용을 뜻함

엑터와 유스케이스 사이의 관계 : 연관관계이며 보통 방향이 존재

선이 이어진 두 관계끼리만 관계가 존재

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2012.png)

- 액터는 유스케이스와의 연관관계를 통하여 시스템과 다양한 상호작용을 한다

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2013.png)

연관관계에서는 출금기능을 사용한다는 것은  선은 하나지만 다양한 interaction이 일어난다. 이걸 하나의 선으로 표현한 것 -> 얘는 유스케이스 명세서에 명세될 것

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2014.png)

Ex) 엘리베이터 도어에는 두가지 기능이 존재하는데 목적지층으로 이동과 엘리베이터 요청 두가지가 있는데 목적지층은 탑승자가 요청하고 대기자는 엘리베이터를 요청함. 각 유스케이스는 엑터와 의사소통하는데 도착센서(외부 장치 시스템)이 먼가를 주기도 함. 이런식으로 읽을 수 있으면 된다.

## 액터와 유스케이스 간의 연관 관계의 유형

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2015.png)

### 유형 1) 활성화

- 액터는 유스케이스의 기능을 활성화시킨다
- 유스케이스가 나타내는 기능이 액터의 입력 이벤트에 의해서 수행된다.
- 엑터가 유스케이스를 사용하는 것

### 유형 2) 수행결과 통보

- 유스케이스로 나타내는 시스템의 기능이 수행된 결과가 액터에게 전달/ 통보되는 상호작용을 뜻한다
- 유스케이스가 엑터에게 결과를 통보하는 유형

### 유형 3) 외부 서비스 요청

- 시스템이 해당 유스케이스의 기능을 완수하기 위해 또 다른 액터가 제공하는 서비스를 이용하는 상호작용을 의미
- 유스케이스가 외부 시스템에게 서비스를 요청

ex) atm 시스템

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2016.png)

atm 사용자와 관리자는 각각의 기능을 사용하고 그 중 세가지 기능은 시스템에게 서비스를 요청해야 한다. 외울 필요 없음

ex) 엘리베이터제어 시스템

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2017.png)

엘리베이터 제어 시스템의 경우 탑승자와 대기자가 유스케이스를 사용, 목적지층으로 이동하려면 외부 디바이스 엑터에게 요청, 그런데 도착센서(외부 시스템 엑터)가 목적지층에게 정보를 요청

# 기본원칙

# 액터

- 액터는 시스템 외부의 존재
    - **개발범위에 포함 x**

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2018.png)

볼 때는 모르는데 프로젝트 시에서 가장 헷갈려 하는 것, 엑터는 개발범위가 아니다!! 바운더리를 못찾음

의료시스템을 하는데 간호사를 개발범위에 넣고 막 그런다… 학사관리 시스템을 만드는데 학생을 구현하는…

바운더리를 잘 정하고 엑터는 개발하는 것이 아니다 특히 sms 전송 시스템

도서관리에는 두가지 기능이 존재, 사서는 신착도서를 등록하면 학생에게 알려줄 건데 그건 우리가 구현하는 게 아니라 외부의 시스템에게 요청하는 것, 요청하는 인터페이스만 만들 것

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2019.png)

이렇게 그려놓고 요구사항 명세서에 sms로 통보해야한다고 적혀있다면 신착도서 등록 기능안에 학생에게 알려주는 기능도 구현해야 한다

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2020.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2021.png)

수강신청 시스템에서 세가지 기능이 존재, 교과목 관리 시스템을 사용할 건데 얘는 디비로 직접 읽어오는 게 아니라 인터페이스로 가지고 와야 함, 개발 범위가 아니다(교과목관리 시스템 대신 디비를 그려놓으면 안된다)

교수가 성적을 등록하면 학생에게 통보, 교과목 관리 시스템이 없으면 구현해야함(파일이나 디비 형태로) 

- 장치 유형의 액터의 표현 여부는 표준 플랫폼에 의한 지원에 따라 달라진다.

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2022.png)

수강신청 시스템에 장치를 쓰는게 아니라 사람의 롤네임이나 인터렉션하는 외부 시스템을 써야 한다. 단,  임베디드의 경우에는 장치를 쓸 수 있음.

- 임베디드 시스템을 구성하는 장치들은 액터로 표현되어야 한다.

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2023.png)

임베디드에는 쓸 수 있지만 보통의 경우에는 사용 안함. 상호작용하지 않는 애들은 적을 필요 없음

엘리베이터 버튼이 유스케이스를 사용 모터보고 가라고 하고 등등 엑터가 있다면 반드시 사용되어야하고 연관관게가 없는거는 표현하지 말 것

- 액터는 **시스템과 상호작용**을 해야 한다

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2024.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2025.png)

- 액터는 시스템 관점에서 바라본 **사용자의 역할**을 뜻해야 한다.

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2026.png)

왼쪽의 경우는 모든 사용자가 세가지 기능을  다 할 수 있다는 의미

ex) 학생이 성적을 등록할 수 있다.

## 유스케이스

- **유스케이스는 사용자가 인지할 수 있는 하나의 기능 단위**
    - 유스케이스는 기능의 단위, 사건의 단위, transaction단위, 너무 작은 기능은 표시하지 않음. Ui의 버튼이나 메뉴 하나에 해당된다고 보면된다, 하지만 정말 조그만한 시스템이라면 기능이 작아질 수 있음

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2027.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2028.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2029.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2030.png)

만약에 문 버튼이 있어서 이게 중요한 기능이라면 기능을 넣을 수 있음

- 유스케이스는 **구체적(concrete)**이어야 한다. 즉, 유스케이스는 실제로 현실에서 발생하는 기능이어야 한다.

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2031.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2032.png)

Transaction하나여야 한다. 두개를 하나로 묶으면 안됨.

- 왼쪽처럼은 안되지만 오른쪽처럼 유스케이스 패키지로 묶어서는 사용이 가능

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2033.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2034.png)

- **하나의 독립적인 기능을 구성하는 다양한 세부상황은 하나의 유스케이스로 표현**되어야 한다

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2035.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2036.png)

- 유스케이스는 **모든 활성화 액터에게 동일한 기능을 제공**해야 한다.

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2037.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2038.png)

온라인 쇼핑몰 시스템 안에 유스케이스가 두가지가 존재하고 회원관리 안에는 세가지 기능이 있다면 회원과 관리자 모두 그 기능을 갖게 됨

→ 회원은 회원 등록만 할 수 있고 관리자는 회원탈퇴를 한다,이 때 회원등록과 회원수정이 들어있는지 유스케이스 다이어그램으로는 볼 수 없으므로 명세서와 같이 봐야한다. 

- 유스케이스는 트랜잭션 성격을 가져야 한다 : 너무 큰 단위를 유스케이스 하나로 표현하면 안된다.

Transaction : 하나의 사건, 완전이 일어나고 중간에 오류가 난다면 롤백해야하는 하나의 단위

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2039.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2040.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2041.png)

## 액터와 유스케이스 간의 연관관계 유형

- **연관관계는 반드시 시스템이 제공하는 기능이어야 한다.**

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2042.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2043.png)

i)수강신청 시스템은 세가지 기능이 있는데 회색은 없다는 것, 학생은 두가지 기능이 있고 그 기능은 교과목관리시스템을 이용할 것, 근데 성적이 등록되고 나서 저 화살표가 없으면 등록되었다는 것을 알려주지 않음. 얘는 실세계에서 구현되어야 함 시스템상에서 구현하지 않는다. 

→ 없으면 끝남, 학생은 모르고 성적 조회해보면 안다

ii)오른쪽의 그림처럼 되어있다면 외부에 있는 시스템에게 요청하고 sms 시스템이 문자를 보내줄 것. 여기서 우리는 성적등록에서 sms 시스템까지 보내달라고 하는 거는 구현해야 한다

→ 성적등록하고 나서 외부 시스템에게 서비스를 요청해서 인터페이스로 정보 날라감

iii)성적등록에서 학생으로 가는 연관관계가 존재한다면 성적등록했다는 것을 학생에게 알려주는 어떤 기능을 구현해야 한다.

→ 성적 등록 기능 안에서 푸시 메시지, 메일을 보내던지 등등으로 구현

- **연관관계의 방향은 데이터 흐름이 아니라 제어흐름을 뜻해야 한다.**

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2044.png)

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2045.png)

화살표 방향 헷갈리면 안된다. 학생은 성적조회를 할 수 있다/ 사용한다. 학생이 수강신청 기능을 사용한다. 방향으로 가야 한다. 수강신청할 때는 시스템에게 요청한다고 왔다갔다가 아니라 요청이니까 단방향이어야 한다

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2046.png)

# 실용 지침

유스케이스와 엑터를 찾아서 바운더리 잘 정하고 화살표 방향 잘 정하면 되는데 프로젝트마다 달라질 수 있음

## 유스케이스

- 데이터(정보)에 대한 CRUD는 하나의 유스케이스로 표현한다.
    - Crud(create, read,update,delete)는 업무의 기본
    - 데이터를 생성하고 업데이트하고 읽고 삭제하고 등등  정보처리의 기본
- CRUD는 하나의 유스케이스로 해서 운행관리를 읽고 생성하고 업데이트하고 삭제하고 등등 기능을 한다.

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2047.png)

- 유스케이스의 선/후행관계는 **엑티비티 다이어그램을 이용해서 표현할 수 있다**

![Untitled](6-2%20Usecase%20Modeling%20ef75ed585d234e27b649c32a34229ea4/Untitled%2048.png)

Ex) 신용대출시스템에서 고객은 대출신청 끝나고 심사하고 집행하고 그 뒤 상환하는데 뒤에 유스케이스 사이의 관계를 하게되면 헷갈려함 

-> 바운더리를 정하고 제공해줄 기능만 찾아내고 누가 사용하는지 누구랑 인터렉션하는지 그 기능이 한 일을 누구에게 알려주는지 그것만 찾아야한다. 흐름은 안쓰고 필요하다면 엑티비티 다이어그램으로 표현

- 바운더리와 유스케이스 사이의 흐름 표현 안하는 것, 외부시스템에 자꾸 디비 그리는 거 서버 그리는 거 그리지 마라!!

시스템의 유스케이스 다이어그램이 나오고 엑터가 나오고 등등.. 이 나오는데 구체적으로 멀하는 지 모르기에 각각의 유스케이스에 대해서 명세서가 필요

유스케이스가 10개면 유스케이스 명세서가 10개 있어야 한다. 다이어그램 + 유스케이스 명세서 같이 봐야 함

정확히 어떤 포맷이 있는게 아님(uml은 명세서에 대한 양식은 없음)

→ Artifacture가 문서를 만들어 주고 그거에 따라서 만들면 된다.