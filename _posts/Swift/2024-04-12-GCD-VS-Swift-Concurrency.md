---
layout: post
title: GCD-VS-Swift-Concurrency
date: 2024-04-12 17:47:03 +0900
category: Swift
---

## GCD

GCD를 사용하면 `async`로 작업을 수행하고 나서 completion handler를 통해 해당 작업이 끝났을 때의 처리하는 방식

### Swift Concurrency

WWDC 2021에서 소개된 동시성 프로그래밍 APi

### GCD와 다른 Swift Concurrency의 장점

- 가독성이 훨씬 좋음
- 컨테스트 스위칭 수가 훨씬 적음

| QoS(GCD) | TaskPriority(Swift Concurrency) |
| --- | --- |
| Userinitiated | High |
| Default | Medium |
| Utility |  |

### GCD와 다른 Swift Concurrency의 단점

- Swift Concurrency가 작동할 수 있는 스레드 개수는 한정적이기 때문에 GCD 코드가 스레드를 많이 생성해서 실행하는 환경이라면 GCD 코드보다 더 느릴 수 있음
- Swift concurrency는 우선순위별로 실행되므로 작업이 생성된 순서로 실행되지 않음을 알아야 함

### 참고

[Swift Concurrency 성능 조사](https://engineering.linecorp.com/ko/blog/about-swift-concurrency-performance)