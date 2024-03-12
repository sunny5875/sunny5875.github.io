---
layout: post
title: Weak Protocol
date: '2022-04-29 23:25:33 +0000'
category: Swift
---
# Weak Protocol

```swift
protocol MyDelegate {
    func runDelegateMethod()
}

class ClassProtocolTest: MyDelegate {
    weak var delegate: MyDelegate? // 여기서 weak를 붙이는 이유는 retain cycle을 피하기 위함
    func runDelegateMethod() {}
}
```

하지만, 에러가 발생함!!

**Note** 💡 `'weak' must not be applied to non-class-bound 'MyDelegate'; consider adding a protocol conformance that has a class bound`


### 원인

- MyDelegate는 프로토콜이고 class bound가 아니기 때문!
- **weak 키워드는 클래스 인스턴스에만 적용 가능하다**
- 프로토콜은 클래스, 구조체, 열거형이 채택하여 사용 가능
- 따라서 해당 프로토콜을 채택한 타입이 클래스 인스턴스인지 구조체인지 알 수 없게 되는 것!

⇒ 앞에서 선언한 프로토콜은 클래스에서 사용되는지 아니면 구조체나 열거형에서 사용되는지 알 수 없기 때문에 `reference count`관리를 위해 사용되는 `unowned`이나 `weak` 키워드를 사용할 수 없는 것!

→ 따라서 프로토콜이 class를 따르도록만 제한해주면 해결!

```jsx
protocol MyDelegate: class { // 이렇게 class로!!
    func runDelegateMethod()
}
```
