---
layout: post
title: DependencyContainer 코드 줄이기
date: 2025-03-15 21:16:50 +0900
category: Swift
---
# DependencyContainer 코드 줄이기

### 이전 코드

- 매번 computed Property로 resolve해줘야 함

```swift
final class ViewModel {

    func reduce() {
        Task {
            try await self.usecase.execute()
        }
    }
   
}

extension ViewModel {
   var usecase: GetUserDataUseCase { DepdendencyContainer.live.resolve() }
}
```

→ **PropertyWrapper**와 **DynamicMemberLookUp**으로 좀 더 줄여보자

### 해결방안 결과

```swift
@propertyWrapper
struct Resolve<T> {
    var wrappedValue: T {
        get {
            DependencyContainer.live.resolve()
        }
    }
}

@dynamicMemberLookup
final class ViewModel {
    private let dependency = UseCases()

    func reduce() {
        Task {
            try await self.usecase.execute()
            try await self.usecase2.execute()
        }
    }
   
}

private extension ViewModel {
    struct UseCases {
        @Resolve var usecase: GetUserDataUseCase
        @Resolve var usecase2: GetUserDataUseCase
    }
    
    
    subscript<T>(dynamicMember keyPath: KeyPath<UseCases, T>) -> T {
        dependency[keyPath: keyPath]
    }
}
```
