---
layout: post
title: Understanding-Swift-Performance-WWDC2016-
date: 2024-03-25 23:21:24 +0900
category: Swift
---

종류: WWDC

### **dimesions of performance**

![스크린샷 2024-03-24 오전 11.00.14.png](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/1.png)

- 데이터를 할당할 때 성능과 관련된 부분
    - allocation
    - reference counting
    - method dispatch

→ 이 세가지에 대해서 알아보고 각각의 trade off를 알아보자!

# Allocation

- **stack**
    - push, pop 가능
    - 가벼운 편
    - stack pointer 값으로 allocalte/deallocate
    - O(1)으로 관리 용이
    - 스레드마다 stack을 가지고 있기에 변수가 로컬하여 thread safe함

![스크린샷 2024-03-24 오전 11.04.23.png](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/2.png)

- **heap**
    - advaned data structure
    - unused block을 찾아서 allocate
        - stack처럼 연속된 메모리 공간에 할당되는 것이 아니라 페이지가 들어갈만한 프레임을 고르는 페이징 과정 필요
        - 또한 페이지 테이블에 주소값 변환에 대한 데이터를 저장하는 작업도 필요
    - reinsert block to deallocate
    - thread 관리가 필요

![스크린샷 2024-03-24 오전 11.06.58.png](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/3.png)

struct과 달리 class로 할당하는 경우, Swift가 관리하기 위해 4개의 워드가 할당됨.

**⇒ ✅ 즉, Stack보다 heap이 무거운 연산이므로 최대한 stack을 사용하도록 할 것**

ex) key를 “\(color) \(orientation) \(tail)”로 설정하면 enum은 struct이지만 content를 만들면서 heap에 할당됨. 따라서 struct으로 감싸서 자체를 key로 설정하는 아래 코드가 더 성능상 유리

![스크린샷 2024-03-24 오전 11.17.49.png](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/4.png)

Q. 근데 항상 struct이 무거울까? 

A. NO, struct 안에 참조타입이 있는 경우 각각에 대해서 ARC관리가 필요하므로 더 안좋다 (아래에서 좀 더 설명)

# ReferenceCounting

Swift는 reference 타입에 대해서 참조 횟수를 관리하기에 0이면 알아서 deallocate해줌

- thread 관리가 필요함. atomic하게 증감하도록 관리해줘야함

**Class에서의 Reference count**

![스크린샷 2024-03-24 오전 11.22.25.png](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/5.png)

- retain: reference count 증가
- release: reference count 감소

**Struct에서의 Reference count**

- struct에서 heap 관리가 없기에 ARC 없음

**struct 안에 class가 있는 경우의 Reference count**

- 각 class마다 arc를 해주기에 두배로 더 많이 관리해줘야 함

![스크린샷 2024-03-24 오전 11.25.03.png](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/6.png)

**⇒ 정리 ✅ : refernce count는 값타입이 참조 타입보다 가볍지만 값 타입 안에 참조타입이 있는 경우 오히려 더 많이 관리해야 함.**

cf. string보다는 struct이나 enum을 사용하는 것이 용이

# Method dispatch

: 메소드의 적절한 구현을 선택하는 작업을 의미

**Static dispatch**

- 컴파일 타임에 어떤 구현을 실행하도록 결정 가능
- run time에 implementation로 바로 점프
- candidate for inlining and other optimizations

ex) struct안에 있는 함수, compile time에 implementation을 알 수 있어서 replace 가능한 경우

**Dynamic dispatch**

- compile time에는 정해지지 않고 run time에 look up implementation in table
- indirect 과정이 하나 추가되지만 더 복잡한 연산은 아님
- prevent inlining and other optimizations

ex) polymolphism: 상속의 경우, 실제로 어떤 draw함수가 불리는지 모르니까 dynamic dispatch 필요

![스크린샷 2024-03-24 오전 11.47.53.png](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/7.png)

![스크린샷 2024-03-24 오전 11.40.09.png](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/8.png)

- dynamic dispatch는 컴파일 단계에서 런타임 단계에서 implementation을 검색하는 vtable을 클래스마다 만들어서 해당 클래스와 함께 heap에 저장, 그리고 런타임에 호출되면 컴파일 타임에 만든 vtable을 참조

**⇒ 정리 ✅: static, dynamic 연산 자체는 비용이 비슷하지만 체이닝이 될 수 있어 optimization을 prevent하기에 static을 사용하는 것이 성능에 용이, 따라서 class가 더이상 속하지 않을 경우 final 키워드를 쓰면 static dispatch가 되므로 성능에 용이**

# Protocol types

struct도 상속같은 걸 하고 싶은데 어떻게 해결 할 수 있을까? 바로 POP(protocol oriented programming)으로!

- polymorphism without inheritance or reference semantics

![Untitled](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/Untitled.png)

### **Protocol witness table (프로토콜 메소드 관리)**

- class였던 경우 vtable을 만들어서 그걸로 메소드를 찾아서 실행했지만 protocol의 경우 공통 상속관계가 필요하지 않으므로 protocol witness table이 필요
- 타입마다 존재하고 해당 테이블은 실제 implemenation을 링킹함

![Untitled](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/Untitled%201.png)

Q. 아래처럼 만약 프로토콜을 채택한 타입들의 배열의 경우 각 타입마다 메모리 사이즈가 다르면 어떻게 할당할까?

![Untitled](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/Untitled%202.png)

A. **Existential container라는 특수한 storage layout을** 사용! 3개의 워드 크기의 value buffer가 있는데 만약 그거 보다 할당할 크기가 더크면 heap allocation을 해서 주소를 저장

Q2. 그러면 Point랑 Line이 다르게 저장되는 건데 그걸 어떻게 관리할까?

A2.

### Value witness table (저장 프로퍼티 관리)

![스크린샷 2024-03-24 오후 12.03.09.png](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/9.png)

- 타입마다 존재
- 해당 테이블에는 allocate, copy, destruct, deallocate가 존재
- allocate에 Existential container를 가리키고 있음

**정리 ✅**

![Untitled](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/Untitled%203.png)

- 타입마다 Existential container가 만들어지고 그 안에 vwt(value witness table)과 pwt(protocol witness table)에 대한 레퍼런스를 저장
- vwt에서는 저장 프로퍼티를 관리하고 pwt에서는 프로토콜 메소드를 관리

ex) Swift 프로토콜 타입 동작방식 수도코드

![스크린샷 2024-03-24 오후 12.09.39.png](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/10.png)

![스크린샷 2024-03-24 오후 12.12.17.png](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/11.png)

⇒ 정리

![Untitled](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/Untitled%204.png)

![Untitled](/assets/2024-03-25-Understanding-Swift-Performance-WWDC2016-/Untitled%205.png)

# Generic code

아래의 두 함수는 같은 거 아닐까? 뭐가 다를까?

```swift
func draw<T: Drawable>(local: T) {
...}

func draw2(local: Drawable) {
...
}
```

- Generic 코드는 parametric polym

# 결론
- **struct vs class**
    - struct
        - 내부의 참조타입에 대한 오버헤드를 줄이는 방식으로 가야 하고
        - thread safe하고 메모리 leak 없어서 대부분의 경우 안전
    - class
        - 동적 디스패치에 대한 오버헤드를 final을 통해 줄이는 방식으로 가야함
        - 인스턴스 복사시 같은 객체를 가리키고 싶을 때 사용
        - 크기가 큰 인스턴스
- least dynamic runtime type requirement(런타임에 타입이 최소한으로 결정되는 요구사항)인 abstraction을 선택해야 함
    - struct: value semantics
    - class: identity or OOP style polymorphism
    - generics: static polymorphism, struct이 더 빠른 편
    - protocol: dynamic polymorphism, struct이 더 빠른 편
### 참고

[Understanding Swift Performance - WWDC16 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2016/416/)

[[Swift] Struct와 Class를 메모리 원리부터 자세하게 비교해보자](https://hasensprung.tistory.com/181)

[Swift ) (2) Understanding Swift Performance (Swift성능 이해하기)](https://zeddios.tistory.com/597)
