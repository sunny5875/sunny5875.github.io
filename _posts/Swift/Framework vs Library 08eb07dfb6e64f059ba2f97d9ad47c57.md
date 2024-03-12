---
layout: post
title: Framework vs Library
date: '2023-11-31 23:25:33 +0000'
category: Swift
---
# Framework vs Library

종류: Develop

**개요**

- c++ 라이브러리인 .a파일과 .h파일, 그리고 c++파일을 하나의 모듈로 만들어야 하는데 어떻게 해야할까?에서 시작한 것!

# Library

Library는 타겟(앱)에서 사용될 코드와 데이터들의 모임이다. 이후에 컴파일 시점 또는 런타임 시점에 타겟(앱)에 연결(링킹)되어 사용된다. 단, 이미지와 같은 리소스들은 포함할 수 없다.

Library 은 타겟에 어떻게 링킹하는가에 따라 2 타입으로 나누어 볼수 있다.

- Static Library (`.a`)
- Dynamic Library (`.dylib`)

**Static Library**

- Static Library 은 object file 의 묶음이다.
- `.a` 파일 익스텐션을 가지고 있음

**Dynamic Library**

- 컴파일 시점에 executable file에 복사되지 않고 필요한 시점에 동적으로 로드

# Framework

- 계층구조를 갖는 디렉토리
- dynamic library, header file, resource 등을 가지고 있음

**Q.Module이 Static인지 Dynamic인지 어떻게 선택할까?**

- build setting에서 Mach-O Type 필드로 수정 가능
- framework의 경우 dyanmic library를 포함하므로, dynamic으로 선택되지만 static으로 변경 가능
    - 단, framework 번들에는 접근할 수 없으며 framework내의 리소스도 사용할 수 없다.

Q. **Embed or Not Embed의 차이점**

- Embedding module은 해당 모듈을 최종 package에 폴더로서 추가한다. 이 폴더를 bundle class를 이용해서 런타임에 접근하여 리소스를 사용할 수 있다. 해당 폴더를 실제로 보려면 프레임워크를 포함하고, 아카이브하면 된다. static library의 경우, 포함하지 않아도 된다. 컴파일타임에 컴파일되고, 링킹되기 때문이다.

### XCFrameworks

- xcode 11부터 가능해진 새로운 framework 배포 방법
- swift와 c 코드 지원 가능

<aside>
💡 그럼 나는 dlib을 이용해서 secretSharing 모듈화를 하려고 하는데 아마도 .a파일과 .csv, .dat 등등의 파일이 섞여야 하므로 framework를 해야겠다!

</aside>
