---
layout: post
title: KeychainServicable 로직 리팩토링
date: 2025-05-15 21:16:50 +0900
category: Swift
---
# KeychainServicable 로직 리팩토링

### **기존 구조**

```jsx
protocol Servicable {
  func testfunction()
  func testfunction2()
  func testfunction3()
  func testfunction4()
}

class Service: Servicable {
  func testfunction() {}
  func testfunction2() {}
  func testfunction3() {}
  func testfunction4() {}
}

protocol Accessable {
  var a: Servicable { get set }
}

protocol Repositable: Servicable, Accessable {}

class Repository: Repositable {
  var a: Servicable
  
  init(a: Servicable) {
    self.a = a
  }
  
  func testfunction() {
    a.testfunction()
  }
  func testfunction2() {
    a.testfunction2()
  }
  func testfunction3() {
    a.testfunction3()
  }
  func testfunction4() {
    a.testfunction4()
  }
}
```

- 문제점
    - Servicable의 함수들을 모두 Repository가 따로 구현해줘야해서 boilerplate가 많았다

### 해결방안

```jsx
protocol Servicable {
  func testfunction()
  func testfunction2()
  func testfunction3()
  func testfunction4()
}

class Service: Servicable {
  func testfunction() {}
  func testfunction2() {}
  func testfunction3() {}
  func testfunction4() {}
}

protocol Accessable: Servicable {
  var a: Servicable { get set }
}

extension Accessable {
	
	var a: Servicable = Service()
  
  func testfunction() {
    a.testfunction()
  }
  func testfunction2() {
    a.testfunction2()
  }
  func testfunction3() {
    a.testfunction3()
  }
  func testfunction4() {
    a.testfunction4()
  }
}

protocol Repositable: Servicable, Accessable {}

class Repository: Repositable {
  var a: Servicable
  
  init(a: Servicable) {
    self.a = a
  }
}
```

⇒ 중복된 코드가 줄면서도 여전히 DI는 가능한 구조여서 훨씬 나은 구조가 된 상태이다.

(참고) 요상한 구조인데 이것도 되길래 신기해서 남겨놓음…ㅎㅎ

```jsx
protocol Servicable {
  func testfunction()
}

class Service: Servicable {
  func testfunction() {
    print("hi")
  }
}

protocol Accessable {
  var a: Servicable { get set }
}

extension Accessable {
  var a: Servicable {
    return Service()
  }
   
  func testfunction() {
    a.testfunction()
  }
}

protocol Classable: Servicable, Accessable {}

class TempClass: Classable {
  var a: Servicable = Service()
  init() {}
}
```
