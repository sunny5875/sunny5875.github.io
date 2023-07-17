---
title: CleanArchitecture
subtitle: 
categories: Swift
tags: 
date: 2023-07-17 17:29:33 +0000
last_modified_at: 2023-07-17 17:29:33 +0000
---

종류: Architecture

개요

- 기존 앱 0.3.0 기준 0.1.0에서는 MVC였는데 0.2.0에서 MVVM으로 변경했었음.
- 근데 viewModel이 너무 비대해지기 때문에 새로운 아키텍처 도입이 필요하다고 여겨서 작성하게 됨!!

### MVVM Pattern ( UniWaffle v0.3.0 Architecture )

![스크린샷 2023-07-17 오후 5.01.53.png](CleanArchitecture%204cf142e506c041308c73ed59b0564c2b/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-07-17_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.01.53.png)

**View**

- 사용자에게 보여지는 영역 (UI)
- ViewController

**ViewModel**

- View와 Model 사이 비즈니스 로직을 처리하는 영역

**Model**

- 어플리케이션에서 관리하는 데이터와 그 데이터를 처리하는 영역

### 문제점

![스크린샷 2023-07-17 오후 5.21.14.png](CleanArchitecture%204cf142e506c041308c73ed59b0564c2b/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-07-17_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_5.21.14.png)

- 현재 반복되는 UI가 많으나 화면 흐름이 달라 따로 작성되어 있어 재사용성이 낮음
- 비대한 viewModel
- viewModel끼리의 연관성이 있는 코드도 존재하여 중복되는 점

# 1. Clean Architecture

![Untitled](/assets/images/2023-07-17-CleanArchitecture/Untitled.png)

![Untitled](/assets/images/2023-07-17-CleanArchitecture/Untitled%201.png)

- 개념
    - Domain layer과 Presentation Layer, Data Layer로 나누어서 개발
    - 주요 개념: dependency rule(소스코드 종속성은 안쪽으로만 향할 수 있다)

### 핵심 포인트: the Dependency Rule

![Untitled](/assets/images/2023-07-17-CleanArchitecture/Untitled%202.png)

- outer circle: mechanism
- inner circle: 정책
- 개념: 소스코드 종속성은 안쪽으로만 향할 수 있다
    - 안쪽 레이어에 있는 애들은 바깥 레이어에 있는 것들을 몰라야 함
    - 즉, 안쪽 레이어에서 바깥쪽에 의존하면 안됨~~
    - ex) outer circle에 선언된 이름은 Inner circle에서 언급하면 안됨!!

### 개념

**entities**

- Enterprise wide business rule을 캡슐화
- 변경될 가능성이 가장 적음
- 가장 높은 수준의 규칙을 캡슐화
- 특정 도메인에서 사용되는 struct
- ex) 영화 검색앱에서의 엔티티: movie

```swift
struct Movie: Equatable, Identifiable {
    typealias Identifier = String
    enum Genre {
        case adventure
        case scienceFiction
    }
    let id: Identifier
    let title: String?
    let genre: Genre?
    let posterPath: String?
    let overview: String?
    let releaseDate: Date?
}

struct MoviesPage: Equatable {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}
```

**use cases**

- Application businness rules
- 시스템의 동작을 사용자의 입장에서 표현한 시나리오
    - actor가 원하는 entity를 얻어내는 로직을 의미
- 모든 use case를 캡슐화하고 구현
- 엔티티와의 데이터 흐름을 조정하고 해당 엔티티가 use case의 목표를 달성할 수 있도록 지시
- ex) 영화앱에서의 use case: 검색 기능

```swift
protocol SearchMoviesUseCase {
    func execute(requestValue: SearchMoviesUseCaseRequestValue,
                 cached: @escaping (MoviesPage) -> Void,
                 completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable?
}

final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {

    private let moviesRepository: MoviesRepository
    private let moviesQueriesRepository: MoviesQueriesRepository

    init(moviesRepository: MoviesRepository,
         moviesQueriesRepository: MoviesQueriesRepository) {

        self.moviesRepository = moviesRepository
        self.moviesQueriesRepository = moviesQueriesRepository
    }

    func execute(requestValue: SearchMoviesUseCaseRequestValue,
                 cached: @escaping (MoviesPage) -> Void,
                 completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable? {

        return moviesRepository.fetchMoviesList(query: requestValue.query,
                                                page: requestValue.page,
                                                cached: cached,
                                                completion: { result in

            if case .success = result {
                self.moviesQueriesRepository.saveRecentQuery(query: requestValue.query) { _ in }
            }

            completion(result)
        })
    }
}

struct SearchMoviesUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}
```

**Interface Adapter(controllers, gateway, presenters)**

- entity, usecase에서 적합한 format에서 외부 프레임워크에 적합한 format으로 변환
- viewModel, ViewController 등을 포함

**Frameworks & Drivers**

- DB, 프레임워크, API

![Untitled](/assets/images/2023-07-17-CleanArchitecture/Untitled%203.png)

ex) 영화 검색앱의 아키텍처

[https://github.com/kudoleh/iOS-Clean-Architecture-MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)

![Untitled](/assets/images/2023-07-17-CleanArchitecture/Untitled%204.png)

![Untitled](/assets/images/2023-07-17-CleanArchitecture/Untitled%205.png)

presentation: viewcontroller, viewmodel 존재

domain: entity, usecase, interface 존재

data layer: db, network

- 장점
1. 프레임워크와 독립적
2. 테스트 가능
    1. 비즈니스 규칙은 UI, 데이터베이스, 웹 서버 또는 기타 외부 요소 없이 테스트할 수 있음
3. UI와 독립적
    1. 시스템의 나머지 부분을 변경하지 않고도 UI를 쉽게 변경할 수 있음
4. 데이터베이스와 독립적
    1. Oracle 또는 SQL Server를 Mongo, BigTable, CouchDB 등으로 교체할 수 있음
5. 외부 기관과 독립적
    1. 사실 비즈니스 규칙은 단순히 외부 세계에 대해 전혀 알지 못함

# 2. MVVM - C

- 화면 전환하는 부분은 viewController가 결정하는 것이 아닌 coordinator에게 전담하는 패턴

![Untitled](/assets/images/2023-07-17-CleanArchitecture/Untitled%206.png)

### coordinator

- 화면의 흐름을 제어해주는 역할
1. coordinator 프로토콜 작성

```swift
protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var nav: UINavigationController { get set }
    
    func start()
}
```

1. MainCoordinator 구현

```swift
class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc = MainViewController.instantiate(storyboardName: "Main")
        vc.coordinator = self
        nav.pushViewController(vc, animated: false)
    }
    
    func showSecondVC() {
        let vc = SecondViewController.instantiate(storyboardName: "Main")
        vc.coordinator = self
        nav.pushViewController(vc, animated: true)
    }
}
```

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let nav = UINavigationController()
        **coordinator = MainCoordinator(nav: nav)
        coordinator?.start()**
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }
}
```

### 결론

- MVVM-C + Clean architecture을 도입한다면 viewcontroller을 최대한 재사용하면서 코드사이의 의존성도 줄일 수 있을 것으로 기대됨