---
layout: post
title: Instruments
date: 2024-04-12 17:45:08 +0900
category: Swift
---

### 정의

- 성능 분석 및 테스트 도구
- iOS앱이나 프로세스, 디바이스 장치를 프로파일링해서 성능을 보다 더 잘 최적화할 수 있도록 도와줌
- 다양한 측면에서 데이터를 수집하여 나란히 볼 수 있음
- 누수나 버려진 메모리 좀비와 같은 메모리 문제를 찾을 수 있음

### 종류

1. **Activity Monitor**: 앱의 CPU 사용률, 메모리 사용량, 에너지 소비 등과 같은 활동을 모니터링하여 성능과 리소스 사용을 분석합니다.
2. **Allocations**: 메모리 할당과 해제를 추적하여 메모리 누수(leak)나 메모리 사용량 등을 검사합니다.
3. **Animation Hitches**: 애니메이션 실행 중 발생하는 부드러운 움직임(히치) 문제를 감지하고 해결합니다.
4. **App Launch**: 앱의 시작 과정에서 발생하는 지연 시간을 측정하여 앱 실행 성능을 개선합니다.
5. **Audio System Trace**: 오디오 관련 시스템 동작을 추적하여 오디오 성능과 문제점을 분석합니다.
6. **Core ML**: Core ML 모델의 로딩, 실행, 성능 및 메모리 사용을 테스트하여 머신 러닝 모델의 최적화를 지원합니다.
7. **CPU Counters**: CPU 사용량, 코어별 활동, 명령어 수행 등 CPU 성능을 모니터링합니다.
8. **CPU Profiler**: 앱에서 CPU 사용률이 높은 부분을 식별하여 성능 문제를 해결합니다.
9. **Data Persistence**: 데이터 유지와 관련된 파일 I/O 작업을 분석하여 데이터 저장 및 검색에 대한 성능을 평가합니다.
10. **File Activity**: 파일 읽기/쓰기 작업에 대한 성능과 사용량을 모니터링합니다.
11. **Game Memory**: 게임에서의 메모리 사용량과 성능을 분석하여 게임 최적화를 돕습니다.
12. **Game Performance**: 게임의 전반적인 성능을 평가하고 병목 현상을 찾아내어 게임 실행을 최적화합니다.
13. **Leak**: 메모리 누수를 감지하고 메모리 관리를 개선합니다.
14. **Logging**: 앱의 로그를 수집하고 분석하여 앱 동작과 문제를 파악합니다.
15. **Metal System Trace**: Metal API 호출을 추적하여 GPU 사용 및 성능을 모니터링합니다.
16. **Network**: 네트워크 활동을 모니터링하여 네트워크 성능 및 문제점을 분석합니다.
17. **SceneKit**: SceneKit을 사용하는 앱의 3D 그래픽 렌더링 및 성능을 평가하고 최적화합니다.

### 흐름

![Untitled](/assets/2024-04-12-Instruments/Untitled.png)

- 원하는 instrument와 설정을 포함하여 trace document를 생성
- 프로파일링할 앱과 기기를 타겟팅
- 앱 프로파일링 시작해서 캡쳐된 데이터를 분석
- 그걸로 개발자 코드 수정

cf. debig navigator gauges로 간단한 cpu, 메모리, 에너지 사용량을 볼 수 있지만 자세한 부분을 보고 싶으면 instrument를 사용하면 됨!

![스크린샷 2024-04-08 오후 5.18.13.png](/assets/2024-04-12-Instruments/1.png)

### 사용법

![스크린샷 2024-04-09 오후 12.40.54.png](/assets/2024-04-12-Instruments/2.png)

xcode에서 instrument를 선택

![스크린샷 2024-04-09 오후 12.41.25.png](/assets/2024-04-12-Instruments/3.png)

여러개를 프로파일링하고 싶다면 blank를 선택

![스크린샷 2024-04-09 오후 12.41.52.png](/assets/2024-04-12-Instruments/4.png)

버튼을 눌러서 다양한 프로파일을 추가해서 확인 가능

<aside>
💡 만약 너무 많이 프로파일을 추가하게 되면 경고가 계속 뜰 수 있음! 그럴 때에는 아래처럼 deffered mode로 바꿔서 record를 다한 후에 analyze를 하는 방식으로 바꾸면 됨

</aside>

![스크린샷 2024-04-09 오후 12.43.45.png](/assets/2024-04-12-Instruments/5.png)

![스크린샷 2024-04-09 오후 12.44.02.png](/assets/2024-04-12-Instruments/6.png)

### Hangs

- 위의 instrument 고를 때 swiftUI라는 것도 존재함
- 이는 메인스레드 관련 체크나 hang이 일어나는지를 체크하는 역할을 함
- 여기서 hang이란?
    - 잠깐 지체하게 하는 문제, 장애를 의미
    - 사용자의 반응에 instant하게 앱이 반응해야하는데 즉각적인 반응이 없어 잠시 멈쳐보이는 현상을 말하는 것 같음

![스크린샷 2024-04-09 오후 1.48.18.png](/assets/2024-04-12-Instruments/7.png)

위에서 빨간색으로 표시되는 것이 바로 hang! 해당 hang은 딥러닝 모델을 학습하는 부분에서 발생하는 곳이다! 

![Untitled](/assets/2024-04-12-Instruments/Untitled%201.png)

- hang의 종류
    - 메인 스레드가 바쁜 경우
    - 리소스를 사용할 때까지 메인스레드가 차단되는 경우

### Memory Profiling

- heap allocation이 계속해서 누적되는 것이 아닌 줄었다가 낮아지는지 체크

![Untitled](/assets/2024-04-12-Instruments/Untitled%202.png)

![Untitled](/assets/2024-04-12-Instruments/Untitled%203.png)

### Leak

- 초록색 마크가 난오면 메모리 누수가 없는 것이고 빨간색 마크가 나온다면 누수가 발생함을 의미
- leak가 나는 부분에서 cycle & root를 고른다면 순환참조 발생 유무를 가시적으로 확인 가능

![스크린샷 2024-04-11 오전 10.34.38.png](/assets/2024-04-12-Instruments/8.png)
