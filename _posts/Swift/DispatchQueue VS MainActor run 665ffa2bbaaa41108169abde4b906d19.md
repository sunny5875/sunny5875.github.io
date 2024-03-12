---
layout: post
title: MainThread
date: '2024-01-12 23:25:33 +0000'
category: Swift
---
# DispatchQueue VS MainActor.run

종류: Swift

- 메인 스레드에서 api에서 받아온 값을 published 변수에 설정할 때 보라색 에러가 자주 뜬당

```swift
Publishing changes from background threads is not allowed; 
make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
```

이런 에러인데 즉, publish하는 작업은 메인스레드에서 해야한다는 뜻인데 무조건 메인 쓰레드에서 수행된다는 보장이 없어서 발생하는 것!!

## 해결방법

### 1. DispatchQueue 이용하기

- 가장 고전적인 방법!

```swift
Task {
    do {
        let alarmsResult = try await network.getAlarms()
        DispatchQueue.main.async { [weak self] in
            self?.alarms = alarmsResult
            self?.fetchFinished = true
				}
     } catch {
          // 예외 처리
     }
 }
```

### 2. MainActor 이용하기

- MainActor는 싱글톤 actor로써, 이것의 executor는 항상 메인 큐에서 실행되도록 하는 것임!

```swift
Task {
    do {
        let alarmsResult = try await network.getAlarms()
        await MainActor.run {
			    self.alarms = alarmsResult
			    self.fetchFinished = true
				}
     } catch {
          // 예외 처리
     }
 }
```

혹은 Task 자체에 MainActor를 붙일 수도 있다

```swift
Task { @MainActor in
    do {
        let alarmsResult = try await network.getAlarms()
        self.alarms = alarmsResult
			  self.fetchFinished = true
				
     } catch {
          // 예외 처리
     }
 }
```

- 단, 위의 방식은 await [MainActor.run](http://MainActor.run) 안에서 async 클로저를 보낼 수 없고 sync 클로저만 가능하다!
- 하지만, 아래의 방식은 async 클로저도 가능하다!

<aside>
💡 2번방식으로 하면 클로저가 새로 생성되기에 컴파일러 쪽에서 생성되는 SIL 코드가 15프로 증가한다고 한다!

</aside>

### 3. 특정 코드에 MainActor를 붙이자!

```swift
func fetch() {
    Task {
        do {
            let alarmsResult = try await network.getAlarms()
            await self.updateProperties(with: alarmsResult)
        } catch {
            // 예외처리
        }
    }
}

@MainActor func updateProperties(with alarms: [Alarm]) {
    self.alarms = alarms
    self.fetchFinished = true
}
```

<aside>
💡 솔직히… MainActor.run을 넣거나 DispatchQueue.main을 넣든 @MainActor in을 넣어도 여전히 보라색이 뜨는데… 도저히 모르겠다

</aside>

```swift

final class HomeViewModel: ViewModelable {
    
    // MARK: - Status and Datas
    @Published var favoriteObjects: [ObjectEntity] = []
    @Published var baskets: [BasketEntity] = []
    
    
    var cancellable: Set<AnyCancellable> = []
    var hasLoad = false
    @Published var symbolList: [SymbolInfoEntity] = []
    
    
    // MARK: - Dependencies
    weak var coordinator: HomeCoordinator?
    
    private let container: DependencyContainer
    private var getBasketListUseCase: GetBasketListUseCase { container.resolve() }
    private var getFavorites: GetFavoriteObjectListUseCase { container.resolve() }
  
    init(coordinator: HomeCoordinator? = nil,
         container: DependencyContainer = .live) {
        self.coordinator = coordinator
        self.container = container
       
    }
}

extension HomeViewModel {
    
    enum Action {
        case loadDatas
    }
    
    @MainActor func reduce(_ action: Action) {
        switch action {
            
        case .loadDatas:
            Task { @MainActor in
                self.baskets = await getBasketListUseCase.execute()
                self.favoriteObjects = await getFavorites.execute()
                
                hasLoad = true
            }
				}
    }
}

```

### cf. RunLoop.main VS DispatchQueue.main

가장 큰 차이점은 DispatchQueue는 즉시 실행되는 것이고 반면에 RunLoop은 busy할지도 모른다.

만약 `DispatchQueue.main`을 스케줄러로 사용할 때는, 스크롤하면서 동시에 UI가 업데이트 된다.

반면에 `RunLoop.main`은 스크롤이 마친 이후에 UI가 업데이트 된다.

즉, main run loop에 의해 scheduled된 클로저는 유저 Interation이 발생하면 즉시 실행되지 않고 끝나야 실행된다.
