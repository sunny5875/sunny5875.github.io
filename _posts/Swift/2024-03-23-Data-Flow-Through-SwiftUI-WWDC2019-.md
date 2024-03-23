---
layout: post
title: Data-Flow-Through-SwiftUI-WWDC2019-
date: 2024-03-23 22:08:32 +0900
category: Swift
---

종류: SwiftUI

### Data

- UI에 주는 모든 데이터
    - ex) stating UI, represent model data

# Principles of Data Flow

### SwiftUI에서의  guiding prinicple

- **data access as a dependency**
    - view와 data는 dependency를 가지고 있음
    - data가 바뀌면 view가 바뀌어야 하기 때문
- **모든 view에서 있는 data는 single Source of truth를 가진다**
    - 다른 source of truth가 있다면 sync에 유의할 것

UI principle

1. view의 hierachy를 바꾸면 안된다

![스크린샷 2024-03-23 오후 9.24.45.png](Data%20Flow%20Through%20SwiftUI(WWDC2019)%203ce71879ba174e8e9fd19e598fd37549/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.24.45.png)

![스크린샷 2024-03-23 오후 9.25.00.png](Data%20Flow%20Through%20SwiftUI(WWDC2019)%203ce71879ba174e8e9fd19e598fd37549/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.25.00.png)

- 값을 바꿀 경우 아래처럼 state property wrapper를 추가해야 함
- @State를 통해서 view는 persistent storage를 만들고 track dependency해서 뷰를 랜더링함
- State를 사용하는 경우 private를 해서 view에서만 관리할 수 있도록 하는 것이 좋음

![스크린샷 2024-03-23 오후 9.27.38.png](Data%20Flow%20Through%20SwiftUI(WWDC2019)%203ce71879ba174e8e9fd19e598fd37549/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.27.38.png)

- isPlaying이 false에서 true로 변경되면 해당 property를 보고 있는 뷰와 하위뷰까지 다시 랜더링됨
    - 이 때, 달라진 부분만을 다시 그림

> *Every @State is a source of truth
Views are a function of state, not a sequence of events*
> 

**단방향으로 움직이는 Flow**

![스크린샷 2024-03-23 오후 9.30.41.png](Data%20Flow%20Through%20SwiftUI(WWDC2019)%203ce71879ba174e8e9fd19e598fd37549/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.30.41.png)

- @Binding을 사용하는 경우 @State를 넘겨서 ownership은 없지만 읽고 update할 수 있는 propertyWrapper이므로 초기값 필요 없음

**SwiftUI VS UIKit**

![스크린샷 2024-03-23 오후 9.35.13.png](Data%20Flow%20Through%20SwiftUI(WWDC2019)%203ce71879ba174e8e9fd19e598fd37549/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.35.13.png)

- UIKit의 경우 controller가 뷰의 모든 data에 대한 sync관리하기 때문에 massive해짐

![스크린샷 2024-03-23 오후 9.35.27.png](Data%20Flow%20Through%20SwiftUI(WWDC2019)%203ce71879ba174e8e9fd19e598fd37549/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.35.27.png)

- SwiftUI에서는 framework 자체에서 관리해주기에 용이
- 기본적인 view들은 모두 binding을 받고 있음.
    - 즉, framework가 source of truth를 관리해준다는 의미

```swift
 Button(action: {
	 **withAnimation** {self.isPlaying.toggle()} //  withAnimation으로 쉽게 애니메이션 줄 수 있음
 }) {
	 Image(systemName: isPlaying ? "pause.circle" : "play.circle")
 }
```

# Working with External Data

Q. 타이머, notification같은 것들은 어떻게 할까?

- user interaction과 동일하게 동작함!

![스크린샷 2024-03-23 오후 9.41.24.png](Data%20Flow%20Through%20SwiftUI(WWDC2019)%203ce71879ba174e8e9fd19e598fd37549/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.41.24.png)

### Publisher

- 무조건 메인 스레드에서 omit해야 함
- receive on으로 무조건 메인스레드로 설정하면 됨

![스크린샷 2024-03-23 오후 9.43.28.png](Data%20Flow%20Through%20SwiftUI(WWDC2019)%203ce71879ba174e8e9fd19e598fd37549/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.43.28.png)

- managment없이 쉽게 관리 가능

### BindableObject Protocol(현재는 ObservableObject)

- refernce type으로 생성 가능

![스크린샷 2024-03-23 오후 9.46.57.png](Data%20Flow%20Through%20SwiftUI(WWDC2019)%203ce71879ba174e8e9fd19e598fd37549/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.46.57.png)

- bindableObject을 채택하면 publisher가 제공됨.
- data의 change을 알려줌

**Creating dependencies on bindableObject**

![스크린샷 2024-03-23 오후 9.49.25.png](Data%20Flow%20Through%20SwiftUI(WWDC2019)%203ce71879ba174e8e9fd19e598fd37549/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.49.25.png)

- dependency를 추가하기 위해서는 objectBinding이 필요

```swift
struct MyView: View {
	@ObjectBinding var model: MyModelObject // 현재는 ObservedObject!
}
```

**Note ✅ :  reference type을 쓸 때에는 무조건 ObjectBinding을 써야 swiftUI가 달라진 것을 인지 할 수 있음**

**Creating dependencies indirectly**

- environmentObject를 이용한다면 indirect하게 dependency 생성 가능
- 여러 뷰에 참조 가능하고 automatic하게 sync됨
- bindableObject로 모든 뷰에 전달할 수 있지만 enviromentObject를 쓴다면 좀 더 편하게 indirect하게 전달 가능
- 다크모드, 라이트모드같은 혹은 글읽는 방향 등도 enviroment로 설정 가능!

### Sources of truth

- 관리하는 방법
    - State
        - view local, value type, manged by framework
    - BindableObject
        - external, reference, developer managed

### Building reusable component

- read only만 하는 경우
    - swift property, enviroment
    - ex) view같은 것, framework가 알아서 자동으로 데이터가 바뀌면 다시 랜더링해줌
- Read, Write하는 경우
    - Binding
        - first class reference to data
    - 어디서 왔는지 알 필요 없이 값을 읽고 바꾸기만 하면 됨!
- State의 경우에는 external data에는 맞지 않음, observableObject를 쓰는 것이 용이

### 참고

[Data Flow Through SwiftUI - WWDC19 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2019/226/)