---
layout: post
title: Data-Essentials-in-SwiftUI-WWDC2020-
date: 2024-03-23 17:24:26 +0900
category: Swift
---

종류: SwiftUI

# **SwiftUI에서 뷰를 그릴 때 필요한 요소**

ex) 각 북클럽이 읽는 책이 어느정도 진행되었는지 표시하는 앱

![스크린샷 2024-03-23 오후 4.27.32.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_4.27.32.png)

- **해당 뷰에서 어떤 데이터가 일을 하는지? (What data does this view need?)**
    - ex) book, progress
- **어떻게 뷰가 해당 데이터를 조작하는지? (How will it use that data?)**
    - 여기서는 바뀌지 않으니까 let
- **데이터가 어디서 오는지? (Where does the data come from?)**
    - **source of truth**
    - superview에서 인스턴스화할 때 true data를 전달

- 가장 간단한 source of truth: State
- state로 하게 된다면 렌더링 후 지워지지 않고 계속 유지 가능

![스크린샷 2024-03-23 오후 4.32.22.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_4.32.22.png)

![스크린샷 2024-03-23 오후 4.33.26.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_4.33.26.png)

- single source of truth가 필요하므로 두번째 사진처럼 binding을 가져야 함. 첫번째 이미지의 경우 카피하기에 single source of turth가 되지 않음

# Designing your model

### ObservableObject

![스크린샷 2024-03-23 오후 4.39.29.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_4.39.29.png)

- UI 로직과 구분해서 로직을 짜게 되는데 이 때 필요한 요소가 바로 ObservableObject!
- class restrainted protocol이므로 reference type에만 적용 가능
- objectWillChange라는 publisher를 가지고 있고 해당 오브젝트가 바뀌기 전에 emit함
- ObservableObject를 통해 source of truth를 만들 수 있어 ObservableObject가 objectwilloChange.send()를 통해서 변했다라고 알려주면 뷰가 보고 해당 모델의 변화에 따라 랜더링 가능

### Published

- publisher를 expose해서 property를 observable하게 해주는 property wrapper
- 매번 send를 보내기 힘드니까 자동으로 값이 바뀌면 objectWillChange.send를 호출
- observableObject와 automatically work 가능
- willset에서 value가 바뀔 때 publish
- projectedValue = publisher

**ObservabledObject**

- observableObject를 트래킹함
- doesn’t own the instance!
- source of truth를 의미

![스크린샷 2024-03-23 오후 4.47.41.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_4.47.41.png)

- swiftUI는 observedObject를 통해서 observableObject의 objectWillChange를 구독하고 있다가 observableObject에서 값을 willSet에서 방출하면 그때 뷰를 다시 랜더링한다.

Q. 그럼 왜 didset이 아니라 willset에서 방출할까?

A. swiftUI는 머가 바뀌는지 미리 알아야 하나의 update로 합쳐서 change할 수 있기 때문

**Binding from observableObject**

- single source of truth를 유지하면서 read, write가 가능하도록 함
- binding을 하고 싶다면 observableObject에 있는 value type 어떤 것이든 $를 붙이면 가능

### StateObject

- initial value가 필요하고 해당 값으로 인스턴스만듦
- view의 lifeCycle동안 유지
- source of truth
- 뷰가 만들어질 때 인스턴스화되지 않고 body run하기 전에 만들어지고 view life cycle동안 유지됨

→ 그럼 하나의 observableObject를 만들어서 모든 뷰가 가지고 있어야하거나 하위 뷰에 접근하고 싶은 경우가 있음

### EnvironmentObject

![스크린샷 2024-03-23 오후 4.57.24.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_4.57.24.png)

- view modifier
- parent view에서 주입해준 후 하위 뷰에서 property wrapper로 선언해서 사용하면 됨

**Note: ObservableObject는 data dependency를 생성, StateObject는 observableObject를 view life cycle에 tie, EnvironmentObject는 observableObject를 여러뷰에서 좀 더 편하게 접근하기 위한 도구**

# Techniques for your app

### Update life cycle

- view는 piece of UI를 정의
- SwiftUIa는 view의 identity와 lifetime을 관리
- 가볍고 무겁지 않아야 함

### SwiftUI의 update life cycle

![스크린샷 2024-03-23 오후 5.04.24.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.04.24.png)

위의 그림처럼 UI가 있고 해당 UI에 event가 발생하면 source of truth를 수정하게 되고 이로 인해 view가 업데이트됨

- 계속해서 위의 사이클이 반복될 거임
- 따라서 너무 비용이 너무 비싸면 slow update가 될 수 있음

**slow update를 막기 위한 방법**

- 초기화가 가벼워야 함
    - body는 pure function이어야 하고 side effect가 없어야 함
    - dispatch 하지말고 뷰를 describe만 해야함
    - heap allocation을 피해야 함

ex) 두번째 사진처럼 StateObject로 변경한다면 ObservableObject를 right time에 인스턴스화하기 때문에 heap allocation이 필요없게 됨

![스크린샷 2024-03-23 오후 5.07.54.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.07.54.png)

![스크린샷 2024-03-23 오후 5.08.00.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.08.00.png)

### Event sources

- user interaction
- onReceive
- onChange
- onOpenURL
- onContineUserActivity

위의 modifier에서는 핸들러를 파라미터로 받는데 메인 스레드에서 동작하므로 비싼 동작의 경우 dispatch background해서 실행할 것

### Data lifetime

- apps
    - 전체앱에서 관리하는 source of truth
    - State를 선언하면 됨
        
        ![스크린샷 2024-03-23 오후 5.13.53.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.13.53.png)
        
- scenes
    - windowGroup안에 있는 window에서 source of truth
        
        ![스크린샷 2024-03-23 오후 5.14.11.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.14.11.png)
        
- views
    - State, StateObject를 통해서 tie data lifetime to view lifetime 가능

**Note: State, StateObject, Constant는 앱이 강제종료되면 날라가지만 sceneStorage, appStorage를 통해서 영구적으로 저장 가능!**

### Extended lifetime

1. **SceneStorage**
    1. property wrapper
    2. scene scope
    3. view 안에서만 접근 가능
    4. 가벼운 뷰 정보 저장하기에 적합(selection같은 것들)
        
        ![스크린샷 2024-03-23 오후 5.17.14.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.17.14.png)
        
2. **AppStorage**
    1. app scoped
    2. ex) userdefault같은 것들
    3. 어디서든지 사용 가능
        
        ![스크린샷 2024-03-23 오후 5.18.14.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.18.14.png)
        

**source of truth lifetime**

![스크린샷 2024-03-23 오후 5.19.44.png](Data%20Essentials%20in%20SwiftUI(WWDC2020)%2091effa634f9e48978f0d8963e56b5abf/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.19.44.png)

### 참고

[Data Essentials in SwiftUI - WWDC20 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2020/10040/)