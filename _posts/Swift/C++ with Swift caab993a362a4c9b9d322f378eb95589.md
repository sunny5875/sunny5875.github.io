---
layout: post
title: C++ with Swift
date: '2023-11-12 23:25:33 +0000'
category: Swift
---
# C++ with Swift

### 개요

- 기존 코드: c++ 라이브러리(.a)를 호출하는 object-c++ → 브릿지 헤더 → swift에서 사용

→ xcode 15(2023년 6월)부터 C++을 바로 swift에 링킹 및 관련 header를 import해서 사용할 수 있게 되어 이에 맞춰서 수정하고자 한다.

### WWDC 영상

[Mix Swift and C++ - WWDC23 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2023/10172/)

---

### 기존 C++ 연결하던 방식

- .a 파일 생성
- .a 안의 함수를 부르는 object- c++ 파일 작성
- project setting의 header search path, library serach path 설정
- bridging header 생성
- swift에서 bridging header 안에 존재하는 함수 헤더들 이용하여 호출

### C++ 바로 연결

**참고**

- swift의 타입이 필요한 경우 import <UIKit/...>해주면 c++에서 사용 가능
- c++의 타입이 필요한 경우 import Cxx하면 swift에서 사용 가능

**과정**

- object c++로 되어 있는 코드를 c++로 변경
- project setting의 interporability를 c++로 변경

문제점1) cpp 헤더를 찾지 못함

솔루션) 대부분의 레퍼런스가 c++을 바로 swift에서 호출하는 것이 아닌 c++ framework를 만들어서 부르는 방식이어서 해당 방식으로 변경

솔루션1) #include를 #import로 바꿔볼까?

> **`#import`**는 중복 포함을 방지하고 Objective-C와 Objective-C++에서 사용할 수 있는 확장된 프리프로세서 지시어입니다. **`#include`**는 C 및 C++의 표준 지시어로, 중복 포함을 방지하기 위해 추가 작업이 필요하며, 경로를 지정해야 합니다. - ChatGPT 선생
> 

<aside>
💡 따라서 난 C++을 쓰니까 #include는 맞다

</aside>

솔루션2) 필요한 헤더를 직접 넣을까?

```swift
#include "dlib/image_processing.h"
#include "dlib/image_io.h"
#include "dlib/dnn.h"
#include "dlib/clustering.h"
#include "dlib/string.h"
#include "dlib/image_processing/frontal_face_detector.h"
```

너무 많지 않아서 현실적으로 불가능

솔루션3) project setting 값 변경

솔루션4) bridging header를 만들어서 해당 헤더를 인식하도록 변경

→ 해당 방식으로 해결은 되었으나 바로 briding header를 이용했기에 direct하게 연결하지 못했다고 생각되며 아직 레퍼런스가 많이 부족해 한계점이 존재하여 여기까지만 하고 마무리 짓고 추후에 다시 시도하기로 결정
