---
layout: post
title: SwiftInject
date: 2024-03-11 23:25:33 +0000
category: Swift
---

종류: Develop

[https://github.com/Swinject/Swinject](https://github.com/Swinject/Swinject)

### DI란??(Dependency Injection)

Dependency Injection은 클래스 내부에서 필요한 객체의 인스턴스를, 클래스 내부에서 생성하는 것이 아니라 외부에서 생성한 뒤 이니셜라이저 또는 setter를 통해 내부로 주입받는 것. 이 때 이니셜라이저의 타입은 프로토콜을 활용해서 내부에서는 프로토콜 메서드를 사용

- **의존성(Dependency)**
    - B class가 바뀌면 A class도 같이 바뀌게 된다면 A는 B에게 의존성이 있다라고 함
    - 
    
    ```swift
    class AdChamp {
        let name: String /// Int가 바뀌게 되면 Player()안에서도 문제남
        init(name: String) {
            self.name = name
        }
    }
    
    // 플레이어 클래스
    class Player {
        let apMost: ApChamp
        let adMost: AdChamp
    
        // 클래스 내부에서 ApChamp, AdChamp 인스턴스를 생성하고 있다.
        init() {
            self.apMost = ApChamp(name: "아칼리")
            self.adMost = AdChamp(name: "요네")
        }
    }
    
    let a = Player()
    ```
    
- **주입(Injection)**
    - 인스턴스를 외부에서 생성해서 넣는 것
    - 
    
    ```swift
    class Player {
        let apMost: ApChamp
        let adMost: AdChamp
    
        // init 함수 수정
        init(apMost: ApChamp, adMost: AdChamp) {
            self.apMost = apMost // 이렇게 외부에 만들어서 넣으면 됨!
            self.adMost = adMost
        }
    }
    ```
    
- **의존성 분리**
    - 의존 역전의 원칙을 기반으로 분리해야 의존성 분리라고 한다

🤓 **DIP 원칙이란**

- 의존 관계를 맺을 땐, 변화하기 쉬운 것보단 **변화하기 어려운 것에 의존**
    - **변화하기 어려운 것이란 추상 클래스나 인터페이스**를 의미
    - **변화하기 쉬운 것은 구체화된 클래스**를

→ 즉, **구체적인 클래스가 아닌 인터페이스 또는 추상 클래스와 관계를 맺는다는 것**을 의미

```swift
// ApChamp 와 AdChamp 이 공통으로 준수할 프로토콜.
// 프로토콜을 사용함으로써 의존 역전이 되었다.
protocol Champ: AnyObject {
    var name: String { get }
}

// Champ 프로토콜 채택
class ApChamp: Champ {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class Player {
    let apMost: Champ // 구체적인 클래스가 아니라 프로토콜을 가지고 있음!!
    let adMost: Champ

	// 프로토콜에 대고 주입받는다.
    init(apMost: Champ, adMost: Champ) {
        self.apMost = apMost
        self.adMost = adMost
    }
}
```

Q. 여기서 name이 int로 바뀌게 된다면?? 모든 클래스가 에러를 가지게 된다.

즉, 제어 주체가 프로토콜에 있다라는 것!!!!!!!!!!!!

---

그럼 이제 IOC, 의존 역전을 구현하는 프레임워크인 IOC Container, SwiftInject을 알아보자!

**Swinject** : Swift 에서 DI (의존성 주입)을 위한 프레임워크. 객체 자체가 아니라 **프레임워크에 의해 객체의 의존성이 주입되도록 한다**.

```swift
//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

import Swinject

/*:
 ## Basic Use
 */

// 프로토콜 1
protocol Animal {
    var name: String? { get set }
    func sound() -> String
}

class Cat: Animal {
    var name: String?

    init(name: String?) {
        self.name = name
    }

    func sound() -> String {
        return "Meow!"
    }
}

// 프로토콜 2
protocol Person {
    func play() -> String
}

class PetOwner: Person {
    let pet: Animal

    init(pet: Animal) {
        self.pet = pet
    }

    func play() -> String {
        let name = pet.name ?? "someone"
        return "I'm playing with \(name). \(pet.sound())"
    }
}

// 1. Create a container and register service and component pairs.
// Container: 클래스 외부에서 의존성 주입을 하기 위해 Appdelegate에서 Container를 선언
// - register: Conainer에 사용할 프로토콜을 등록
let container = Container()
container.register(Animal.self) { _ in Cat(name: "Mimi") }
container.register(Person.self) { r in PetOwner(pet: r.resolve(Animal.self)!) }

// - resolve: 클래스를 사용
// The person is resolved to a PetOwner with a Cat.
let person = container.resolve(Person.self)!
print(person.play())

```

### 그럼 프로젝트에서 해보자!

- container를 생성

```swift
import Foundation
import Swinject

// container 생성
let container: Container = {
    let container = Container()

    container.register(Repositoriable.self, name: "CryptoRepository") { _ in
        CryptoRepository()
    }
    container.register(Repositoriable.self, name: "NFTRepository") { _ in
        NFTRepository()
    }
    container.register(SwinjectViewModel.self) { resolver in
        SwinjectViewModel(
            cryptoRepository: resolver.resolve(Repositoriable.self, name: "CryptoRepository")!,
            nftRepository: resolver.resolve(Repositoriable.self, name: "NFTRepository")!
        )
    }
    return container
}()
```

- viewModel에 inject해주기

```swift
let viewModel = container.resolve(SwinjectViewModel.self)!
```

```swift
protocol Repositoriable {
    func fetch() -> String
}

struct CryptoRepository: Repositoriable {
    func fetch() -> String {
        "Crypto"
    }
}

struct NFTRepository: Repositoriable {
    func fetch() -> String {
        "NFT"
    }
}

class SwinjectViewModel {
    
    private let cryptoRepository: Repositoriable
    private let nftRepository: Repositoriable
    
    init(cryptoRepository: Repositoriable, nftRepository: Repositoriable) {
        self.cryptoRepository = cryptoRepository
        self.nftRepository = nftRepository
    }
    
    func onAppear() {
        dump(cryptoRepository)
        dump(nftRepository)
    }
}
```