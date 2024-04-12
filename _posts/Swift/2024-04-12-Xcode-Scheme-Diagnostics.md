---
layout: post
title: Xcode-Scheme-Diagnostics
date: 2024-04-12 17:45:08 +0900
category: Swift
---

![스크린샷 2024-04-09 오후 12.51.19.png](Xcode%20Scheme%20Diagnostics%2044b2db2d0f734fbea9dc69170359d3f8/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-04-09_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_12.51.19.png)

### Sanitizer

- 살균제, 소독제
- **thread sanitizer**
    - race condition을 탐지해줌
    - 실기기에서는 동작하지 않음 오직 시뮬레이터에서만 동작!
    - 성능 오버헤드가 많이 증가해서 속도저하가 크기 때문에 테스트할 때만 키는 게 좋다!
- **address sanitizer**
    - 배열 인덱스 넘어가는 상황을 탐지해줄 수 있음

cf. 위의 중에서 어떤 항목을 눌렀는가에 따라서 다른 항목이 비활성화되는 경우가 있는데 이는 동시에 사용하지 못해서 그런 것!

### Runtime API Checking

- **main thread checker**
    - UI작업은 무조건 메인 스레드에서 동작해야하므로 기본값이 on!
- **thread performance checker**
    - detects priority inversions and non-UI work on the main thread

### Memory Management

- malloc scribble
    - 동적 메모리 할당시 더미 값으로 초기화한 후에 해제되기 전까지 해당 공간에 쓰기 작업이 발생하는지 감지하는 기능
    - 즉, 선언하지 않은 포인터나 배열 범위를 벗어나는 등 감지
- malloc guard edges
- guard malloc
- zombie object
    - 할당 끝난 오브젝트 접근 감지
- malloc stack logging