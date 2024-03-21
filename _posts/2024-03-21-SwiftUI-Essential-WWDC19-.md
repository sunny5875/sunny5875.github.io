---
layout: post
title: SwiftUI-Essential-WWDC19-
date: 2024-03-21 09:54:50 +0900
category: Swift
---

종류: SwiftUI

# Views and Modifiers

### View

- define a piece of UI
- swiftUI의 뷰의 구조와 동일하게 코드 작성 가능
- 바로 명령형이 아니라 선언형이기 때문!

![스크린샷 2024-03-21 오전 8.42.55.png](SwiftUI%20Essential(WWDC19)%20066c53a412dd4e678720a37e8a6abda8/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-21_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_8.42.55.png)

ex) 아보카도 토스트

- 명령형으로 작성해보기
    - 재료 준비 → 재료 모으기 → 빵굽기 → … → 아보카도 토스트
- 선언형으로 작성해보기
    - how는 빼고 만들고싶은 거만 나열
    - 나는 butter, sea salt, red pepper가 있는 아보카도 토스트 원해

### **view container**

- closure처럼 생긴 viewBuilder

ex) VStack

![스크린샷 2024-03-21 오전 8.49.02.png](SwiftUI%20Essential(WWDC19)%20066c53a412dd4e678720a37e8a6abda8/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-21_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_8.49.02.png)

### Binding

- automatically create and manage persistent state behind the scene
- expose value
- $를 이용하여 pass a binding 가능 instead of real only value!

### Modifier

- existing view로 새로운 viwe를 생성

![스크린샷 2024-03-21 오전 8.55.19.png](SwiftUI%20Essential(WWDC19)%20066c53a412dd4e678720a37e8a6abda8/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-21_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_8.55.19.png)

**Note: 근데 뷰가 많으면 성능에 문제가 있지 않을까??**

→ efficient render system을 통해서 해결했기에 chaining modifier에는 상관 없음!

**swiftUI의 원칙**

1. **prefer smaller single purpose view**

ex) VStack안에 뷰들에 opacity를 모두 줘야할 때 VStack 자체에 opacity를 설정하면 안의 뷰에 모두 적용 가능 

1. **Build larger views using composition**

# Building custom views

**UIkit vs SwiftUI**

![스크린샷 2024-03-21 오전 9.03.33.png](SwiftUI%20Essential(WWDC19)%20066c53a412dd4e678720a37e8a6abda8/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-21_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_9.03.33.png)

![스크린샷 2024-03-21 오전 9.03.55.png](SwiftUI%20Essential(WWDC19)%20066c53a412dd4e678720a37e8a6abda8/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-21_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_9.03.55.png)

- 상속이 아닌 modifier로 custom view를 만들 수 있게 됨

Q. body 안에 body, body 안에 body… 이렇게 재귀적으로 계속 부르게 되지 않을까???

A. Primitive view를 제공!

### Primitive view

- content가 없는 원시적인 building block을 가짐
- ex) text, color, spacer ,image, shape, divider

- swiftUI는 이전 리스트와 지금 리스트 차이를 자동적으로 감지해서 그에 맞는 애니메이션을 제공
- list vs forEach
    - foreach는 collection of data와 viewBuilder를 받아서 한다는 점에서 동일
    - visual effect이 없고 add its own contents to its container만 함

# Composing contraols

![스크린샷 2024-03-21 오전 9.18.59.png](SwiftUI%20Essential(WWDC19)%20066c53a412dd4e678720a37e8a6abda8/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-21_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_9.18.59.png)

Q. 두 화면의 가장 큰 차이점?

A. container around the controls themselves가 가장 다른 점!

### Form

- container이지만 heterogenous section control 가능

**Adaptive controls**

- visual이 아닌 purpose를 기술
- smarter default behavior
- 높은 재사용성
- 더 강력하게 customization 가능

ex) Button(action: , label: ): 해당 API를 통해 어떤 모양의 button이든지 쉽게 만들 수 있음.

![스크린샷 2024-03-21 오전 9.31.27.png](SwiftUI%20Essential(WWDC19)%20066c53a412dd4e678720a37e8a6abda8/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-21_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_9.31.27.png)

- 위의 처럼 pickerView를 사용하는 경우 알아서 다음 뷰로 넘어가서 하나를 고르면 해당 값으로 binding이 됨

### Environment

 `@Environment`라는 프로퍼티 래퍼는 읽기 전용으로 특정 뷰에서 `EnvironmentValues`의 특정 요소를 읽어와 뷰 구성에 반영할 때 사용

![스크린샷 2024-03-21 오전 9.37.05.png](SwiftUI%20Essential(WWDC19)%20066c53a412dd4e678720a37e8a6abda8/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-21_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_9.37.05.png)

![스크린샷 2024-03-21 오전 9.38.27.png](SwiftUI%20Essential(WWDC19)%20066c53a412dd4e678720a37e8a6abda8/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-21_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_9.38.27.png)

- custom으로 만들 수도 있음

```swift
private struct CaptionColorKey: EnvironmentKey {
  static let defaultValue = Color(.secondarySystemBackground)
}

extension EnvironmentValues {
  var captionBackgroundColor: Color {
    get { self[CaptionColorKey.self] }
    set { self[CaptionColorKey.self] = newValue }
  }
}

// 사용하는 쪽
ContentView()
  .captionBackgroundColor(.yellow)
```

[https://ios-development.tistory.com/1042](https://ios-development.tistory.com/1042) 참고

# Navigating your app

![스크린샷 2024-03-21 오전 9.40.18.png](SwiftUI%20Essential(WWDC19)%20066c53a412dd4e678720a37e8a6abda8/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-21_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_9.40.18.png)

- 현재에는 NavigationLink, NavigationStack을 사용

**참고 영상**

[SwiftUI Essentials - WWDC19 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2019/216/)