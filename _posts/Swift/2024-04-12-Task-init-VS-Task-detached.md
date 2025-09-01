---
layout: post
title: Task-init-VS-Task-detached
date: 2024-04-12 17:45:06 +0900
category: Swift
---

- task로 주로 async 함수를 감싸는데 사용했었는데 task.detached라는 개념이 있다는 것을 알게 됨
- 어떤 차이가 있을까?

### Task

![Untitled](/assets/2024-04-12-Task-init-VS-Task-detached/Untitled.png)

- 비동기적으로 처리하는 하나의 작업 뭉탱이
- 중요한 점은 계층구조로 작업이 관리됨
    - 즉, 모든 task는 부모 task와 자식 task를 가질 수 있음
    - 따라서 그룹을 지어서 취소하거나 실행하는데 용이함

```swift
class TestViewController: UIViewController {
    private let userID: User.ID
    private let loader: UserLoader
    private var user: User?
    private var loadingTask: Task<Void, Never>?
    ...

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard loadingTask == nil else {
            return
        }

        loadingTask = Task {
            do {
                let user = try await loader.loadUser(withID: userID)
                userDidLoad(user)
            } catch {
                handleError(error)
            }

            loadingTask = nil
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadingTask?.cancel()
        loadingTask = nil
    }

    ...
}
```

### Task.init

- 현재 엑터에서 실행되는 구조화되지 않은 작업을 생성하는 방법

```swift
let newPhoto = // ... some photo data ...
let handle = Task {
    return await add(newPhoto, toGalleryNamed: "Spring Adventures")
}
let result = await handle.value
```

### Task.detached

- 구조화된 structured task가 아닌 비동기 작업을 만들고 실행하는 방법
- 상위 컨텍스트로부터 독립적
- 우선순위, 작업 로컬 저장소 또는 취소 동작을 상속하지 x
- 분리된 작업은 상위 작업과 완전히 독립적이고 상위 작업과 통신하거나 값을 반환할 필요가 없는 작업을 수행해야 할 때 유용!
- 상위 task를 취소해도 전혀 propagated되지 않음
- 하지만, 구조화되지 않은 동시성을 사용하기에 코드 추론에 어려움이 있어 이로 인해 문제가 발생할 수 있음을 유의해야 함

### 차이점

- task는 실행환경을 상속받고 task.detached는 실행환경과 별개로 동작함
- task는 current actor를 대신하여 실행되는 최상위 task을 생성
- task.detached는 현재 액터의 일부가 아닌 unstructured task를 생성

```swift
@MainActor func someFunction() {
	Task { ...
	// main thread에서 동작
	}
	
	Task.detached(priority: .background) {
	// 어떠한 것도 상속받지 않으므로 main thread에서 동작 x
	}
}
```

### 공통점

- 둘 다 비동기 작업을 할 수 있음

### 참고

[Improving app responsiveness | Apple Developer Documentation](https://developer.apple.com/documentation/xcode/improving-app-responsiveness)

[Task | Apple Developer Documentation](https://developer.apple.com/documentation/swift/task)