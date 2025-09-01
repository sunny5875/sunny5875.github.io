---
layout: post
title: Main-Actor--Global-Actor
date: 2024-04-12 17:45:07 +0900
category: Swift
---

# Main Actor

- 메인스레드에 너무 많은 작업을 처리하게 되면 hang이 발생할 수 있기에 이때까지는 백그라운드 스레드에서 돌리고 메인스레드에서 해야하는 것만 DispatchQueue.main.async로 UI를 업데이트했었음

### 그래서 나온 개념이 바로 MainActor!

- 메인 스레드에서 동작하는 global actor임!

```swift
actor Actor {
    let id = UUID().uuidString
    // property 에 붙으면, 해당 property 는 main thread 에서만 접근 가능
    @MainActor var myProperty: String
    
    init(_ myProperty: String) {
        self.myProperty = myProperty
    }
    
    // method 에 붙으면, 해당 메서드는 main thread 에서만 호출 가능
    @MainActor func changeMyProperty(to newValue: String) {
        self.myProperty = newValue
    }
    
    func changePropertyToName() {
        Task { @MainActor in
            // block 안에 들어있는 코드도 main actor 에서 실행
            myProperty = "sunny"
        }
    }
}
```

- MainActor는 **자동으로 UI관련 API(UIView, UIViewController 내 정의된 기본 API)가 메인 스레드에서 적절하게 디스패치 되도록 제공해주는 속성**
- 즉, Swift의 Concurrency를 사용하고 MainActor가 표시된 컨텍스트 내에서 비동기 코드를 작성하면 **실수로 백그라운드 큐에서 UI 업데이트를 해주는 오류에 대해 더이상 걱정할 필요가 x**
- 하지만 여전히 main Actor도 actor니까 너무 오래걸리는 작업은 actor나 detached task에 넣어줘야 함
- 기본적인 view들은 MainActor가 이미 붙여져 있는 상태
    - UILabel, UIViewController 등등
- 단, Swift Concurrency를 사용할 때만 @MainActor가 적용되고 completion handler나 combine을 사용하면 아무 소용 x

Q. main Actor가 global actor인 이유?

A. UI는 무조건 메인 스레드에서만 실행되어야 하기 때문에 글로벌 actor임

- shared를 사용하는 싱글톤 인스턴스로 사용해야 함
    - 그렇다고 해서 객체가 싱글톤인 게 아니고 UI요소를 업데이트를 공유된 컨테스트를 가지고 메인스레드에서만 업데이트되도록 한다는 의미임 헷갈리지 말 것!
    - **즉 Swift의 Concurrency를 사용할 때 해당 클래스의 모든 속성과 메서드가 메인 큐에서 자동으로 설정 및 호출/접근 된다는것을 의미**

# Global Actor

```swift
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public protocol GlobalActor {

    /// The type of the shared actor instance that will be used to provide
    /// mutually-exclusive access to declarations annotated with the given global
    /// actor type.
    associatedtype ActorType : Actor

    /// The shared actor instance that will be used to provide mutually-exclusive
    /// access to declarations annotated with the given global actor type.
    ///
    /// The value of this property must always evaluate to the same actor
    /// instance.
    static var shared: Self.ActorType { get }

    /// The shared executor instance that will be used to provide
    /// mutually-exclusive access for the global actor.
    ///
    /// The value of this property must be equivalent to `shared.unownedExecutor`.
    static var sharedUnownedExecutor: UnownedSerialExecutor { get }
}
```

- represent a globally unique actor that anywhere in the program
- shared를 사용하는 싱글톤 인스턴스로 사용해야 함

```swift
@globalActor
public struct SomeGlobalActor {
  public actor MyActor { }

  public static let shared = MyActor()
}
```

## MainActor VS DispatchQueue

```swift
Task { @MainActor in // 해당 안의 코드가 모두 메인스레드에서 동작하게 됨
	self.isUnlocked = true
}

DispatchQueue.main.async {
	self.isUnlocked = true
}
```

두 코드의 차이점이 뭘까?

- 위의 코드는 concurrency 모델을 사용한 것으로 해당 블록이 메인 스레드에서만 호출되도록 컴파일 타임에 보장
- 아래 코드는 GCD의 기능을 사용하여 메인 큐에 비동기적으로 보냄. 런타임 타임에 해당 작업이 메인 큐에서 실행됨을 보장

```swift
Task { @MainActor in 
...
}

await MainActor.run { 
...
}
```

- 위의 두 코드의 차이점
    - 위의 코드는 async한 함수를 호출할 수 있으나 아래의 코드에서는 sync함수만 호출 가능

### Actor vs Global Actor

- 둘다 동시성 제어를 하지만 actor는 해당 인스턴스에 대해서 task들 관리를 진행
- global actor는 해당 타입에 대해서 task 관리함

```swift
import Foundation

 actor Counter {
    
    var value = 0
    let name: String 
    
    nonisolated var computedProperty: String {
        return "Counter 이름: \(name)"
    }
    
     var computedProperty2: String {
            return "Counter2 이름: \(name)"
        }
    
    init(name: String) {
        self.name = name
    }
    
    func increment() -> Int {
        value += 1
        return value
    }
    
}
Task.detached {
    let counter = Counter(name: "그냥 counter")
    print(counter.name)
    print(await counter.increment())
}
Task.detached {
    let counter = Counter(name: "그냥 counter")
    print(counter.name)
    print(await counter.increment())
}

/*
그냥 counter
그냥 counter
1
1
*/
```

```swift
import Foundation

@globalActor actor GlobalCounter {
    
    static var shared = GlobalCounter(name: "sunny")
    var value = 0
    let name: String 
    
    nonisolated var computedProperty: String {
        return "Counter 이름: \(name)"
    }
    
     var computedProperty2: String {
            return "Counter2 이름: \(name)"
        }
    
    init(name: String) {
        self.name = name
    }
    
    func increment() -> Int {
        value += 1
        return value
    }
    
}

Task.detached {
    let counter = GlobalCounter.shared
    print(counter.name)
    print(await counter.increment())
}

Task.detached {
    let counter = GlobalCounter.shared
    print(counter.name)
    print(await counter.increment())
}
/*
sunny
sunny
1
2
*/
```

→ 따라서 전역적으로 동시성을 제어를 하는 경우에 globalActor를 사용

1. **특정 작업이 특정 스레드에서만 실행되어야 하는 경우**
    1. UI 업데이트는 메인 스레드에서만 수행해야 하므로, UI 업데이트와 관련된 코드를 메인 스레드에서 실행하기 위해 사용
2. **특정 자원에 대한 접근 제어**
    1. 데이터베이스 또는 파일 시스템과 같은 자원에 대한 액세스를 제한하려는 경우, 해당 자원에 대한 모든 액세스를 특정 actor에서만 수행하도록 사용
3. **전역적인 동시성 관리**
    1. 프로그램 전체에서 특정 작업에 대한 동시성을 보장하려는 경우

### 결론

- global actor는 싱글톤으로 구현되며 특정 액터를 글로벌 스레드를 통해서 사용할 수 있는 방법
- actor는 특정 객체의 동시성을 관리하고, globalActor는 특정 타입의 전역 동시성을 관리
- globalActor는 앱의 전반적인 동작을 제어하고, actor는 객체 내의 상태와 동작을 보호
- mainActor는 global actor의 하나로 UI업데이트를 무조건적으로 main thread에서 실행되어야하는 코드에 적용

### 참고

[swift-evolution/proposals/0316-global-actors.md at main · apple/swift-evolution](https://github.com/apple/swift-evolution/blob/main/proposals/0316-global-actors.md)

[[Swift] Actor 뿌시기](https://sujinnaljin.medium.com/swift-actor-뿌시기-249aee2b732d)

[Swift Concurrency - @MainActor 사용하기](https://green1229.tistory.com/343)

[[Swift] actor](https://eunjin3786.tistory.com/573)