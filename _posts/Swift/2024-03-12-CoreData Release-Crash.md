---
layout: post
title: CoreData Release Crash
date: '2024-03-12 23:25:33 +0000'
category: Swift
---
# CoreData Release Crash

### 문제 상황

- **예전 코드**
    - create함수 안에서 CoreData의 User변수를 초기화하고 바로 save를 진행했었음

```swift
class CoreDataRepository { 
	private let container = NSPersistentContainer(name: "CoreData") 
	private var context: NSManagedObjectContext { 
		container.viewContext 
	} 
	func create() { 
		let user = User(context: self.context) 
		user.id = 1 
		user.name = "sunny"
		user.age = 12 
		
		try? self.context.save() 
	} 
}

create()
```

⇒ 하지만, 위의 코드로 했을 때 여러개의 User변수를 한꺼번에 만드는 경우 Race condition이 발생하여 제대로 값이 저장되지 않는 현상이 발생

- **변경 코드**
    - actor를 붙여주고 save하는 함수를 따로 만들어서 여러개가 만들어져도 마지막에만 save하는 방식으로 변경

```swift
actor CoreDataRepository { 
	private let container = NSPersistentContainer(name: "CoreData") 
	private var context: NSManagedObjectContext { 
		container.viewContext 
	} 
	func create() { 
		let user = User(context: self.context) 
		user.id = 1 
		user.name = "sunny"
		user.age = 12 
	} 
	func save() { 
		try? self.context.save() 
	} 
}

create()
save()
```

⇒ 그 후 race condition이 발생하지 않아 테스트플라이트에 릴리즈버전을 올렸는데 CoreData쪽에서 릴리즈 버전만 앱이 죽는 현상 발생

- DataSource 모듈에서 CoreData model에 접근해서 데이터 저장하는 로직에서 debug scheme에는 문제가 없었으나 Release scheme에서 빌드 시 앱이 크래시

### 원인

- 변경 코드한 부분을 보면 create에서 context를 파라미터로 받아 User를 만들었지만 바로 save하지 않았기에 User를 참조하는 곳이 없음.
- 이로 인해 ARC가 참조 카운트를 0으로 감소되기 때문에 메모리에서 인스턴스를 해제하게 됨.
- ARC는 최적화레벨에 상관없이 일관적이어야 하지만 CoreData의 경우 로직이 복잡한 시스템이므로 순서에 따라 영향을 받을 수 있음
- 기존 debug scheme에는 optimization level이 optimization level이 -none에는 문제가 없었지만 release scheme의 경우에는 optimization level이 -o로 세팅되어 있어 ARC 카운트에 따른 인스턴스를 바로 내려버려서 크래시가 난 것

### 해결 방법

- build setting 속, optimization level을 release의 경우에도 -none으로 설정

**Note** 💡 이 때, apple clang, compiler 각각에 대한 optimization이 있으므로 이를 유의해서 swift optimization level의 최적화 레벨을 변경해야 함


### 참고자료

### **[Optimization Level](https://developer.apple.com/documentation/xcode/build-settings-reference#Optimization-Level)**

**Setting name:** `GCC_OPTIMIZATION_LEVEL`

- **이 환경 변수는 주로 C 및 C++ 코드 컴파일에 사용**

Specifies the degree to which the generated code is optimized for speed and binary size.

- *None:* Do not optimize. [-O0] With this setting, the compiler’s goal is to reduce the cost of compilation and to make debugging produce the expected results. Statements are independent—if you stop the program with a breakpoint between statements, you can then assign a new value to any variable or change the program counter to any other statement in the function and get exactly the results you would expect from the source code.
- *Fast:* Optimizing compilation takes somewhat more time, and a lot more memory for a large function. [-O1] With this setting, the compiler tries to reduce code size and execution time, without performing any optimizations that take a great deal of compilation time. In Apple’s compiler, strict aliasing, block reordering, and inter-block scheduling are disabled by default when optimizing.
- *Faster:* The compiler performs nearly all supported optimizations that do not involve a space-speed tradeoff. [-O2] With this setting, the compiler does not perform loop unrolling or function inlining, or register renaming. As compared to the `Fast` setting, this setting increases both compilation time and the performance of the generated code.
- *Fastest:* Turns on all optimizations specified by the `Faster` setting and also turns on function inlining and register renaming options. This setting may result in a larger binary. [-O3]
- *Fastest, Smallest:* Optimize for size. This setting enables all `Faster` optimizations that do not typically increase code size. It also performs further optimizations designed to reduce code size. [-Os]
- *Fastest, Aggressive Optimizations:* This setting enables `Fastest` but also enables aggressive optimizations that may break strict standards compliance but should work well on well-behaved code. [-Ofast]
- *Smallest, Aggressive Size Optimizations:* This setting enables additional size savings by isolating repetitive code patterns into a compiler generated function. [-Oz]

### **[Optimization Level](https://developer.apple.com/documentation/xcode/build-settings-reference#Optimization-Level)**

**Setting name:** `SWIFT_OPTIMIZATION_LEVEL`

- **swift 컴파일에 필요**
- *None:* Compile without any optimization. [-Onone]
- *Optimize for Speed:* [-O]
- *Optimize for Size:* [-Osize]
- *Whole Module Optimization:* [-O -whole-module-optimization]
