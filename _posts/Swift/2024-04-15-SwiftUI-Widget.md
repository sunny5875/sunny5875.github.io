---
layout: post
title: SwiftUI-Widget
date: 2024-04-15 21:16:50 +0900
category: Swift
---

종류: Swift

# 개요

- 생각해보니까 이때까지 위젯을 만들어본 적이 없어서 이번 기회에 만들어보려고 한다!

# 위젯 시작하기

1. 사용하고자 하는 앱에 target을 눌러 widgetExtension을 선택

![스크린샷 2024-04-15 오전 11.19.00.png](/assets/2024-04-15-SwiftUI-Widget/1.png)

![스크린샷 2024-04-15 오전 11.19.46.png](/assets/2024-04-15-SwiftUI-Widget/2.png)

1. 위젯 이름을 선택하고 finish버튼 클릭
    1. 여기서 live activity는 Dynamic Island와 잠금화면에 앱 데이터를 표시, 빠른 인터랙션 제공하는 새로운 위젯이라고 보면 됨(배민 주문 현황이 잠금화면에서 보이는 그런 위젯)

![스크린샷 2024-04-15 오전 11.19.58.png](/assets/2024-04-15-SwiftUI-Widget/3.png)

# 위젯의 개념

### 위젯 동작 방식

- 위젯은 항상 떠야하는데 로딩화면이 보이는 것은 UX적으로 매우 안좋음
- 따라서 항상 보일 수 있도록 애플이 구현해놓음
- 우리는 위젯을 업데이트할 시간을 담은 배열(timeline)을 widgetKit에게 주면 widgetKit은 그걸 보고 그 시간에 나와야하는 view를 위젯에게 전송해줌

→ 즉, view는 이미 준비가 되어있고 그시간마다 이미 만들어진 뷰를 표출하는 것

![Untitled](/assets/2024-04-15-SwiftUI-Widget/Untitled.png)

### WidgetBundle

- 어떤 타입의 위젯을 제공할 건지를 결정
- 위젯을 여러개 제공할 때 사용
    - 현재 liveActivity도 포함했기에 기본 코드로 제공되는 것으로 보임

```swift
import WidgetKit
import SwiftUI

@main
struct MyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyWidget()
        MyWidgetLiveActivity()
    }
}
```

### Widget 기본 구조

![Untitled](/assets/2024-04-15-SwiftUI-Widget/Untitled%201.png)

- **widget**
    - 위젯 갤러리에서 어떻게 보일지와 보이는 화면
- **configuration**
    - **StaticConfiguration**
        - 사용자 구성 가능한 속성이 없는 위젯의 경우. 예를 들어, 일반적인 시장 정보를 표시하는 주식 시장 위젯이나 트렌드 헤드라인을 표시하는 뉴스 위젯 존재
    - **IntentConfiguration**
        - StaticConfiguration과 달리 사용자가 구성할수 있는 프로퍼티가 있는, 위젯 편집을 제공하는 방식
        - 위젯편집 기능을 제공함
- **Provider(AppIntentTimelineProvider/TimelineProvider)**
    - 데이터를 불러오기 전 임시 화면
    - 샘플데이터 보여줄 때 화면
    - 언제 업데이트시킬지 timeline 전달
- **timelineEntry**
    - TimelineEntry 프로토콜을 만족
    - date라는 변수 필수로 필요

---

## 코드로 보자!

**Widget**

위젯 갤러리에서 보이는 화면 구성

```swift
struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: Provider()
        ) { entry in
            MyWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("써니의 위젯")
        .description("매분마다 새로운 이모지와 퇴근시간을 알 수 있습니다.")
        .supportedFamilies([.systemMedium, .systemSmall, .systemLarge])
    }
}
```

![IMG_AA12A28DF3A6-1.jpeg](/assets/2024-04-15-SwiftUI-Widget/IMG_AA12A28DF3A6-1.jpeg)

**WidgetConfigurationIntent**

- StaticConfiguration에는 없고 IntentConfiguration에 존재
- 어떤 데이터를 담을 건지 결정

```swift
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    @Parameter(title: "Current Emoji", default: "😃") // 위젯 편집 시 보이는 문구
    var currentEmoji: String
    // 만약에 커스텀 entity를 넣고 싶으면 AppEntity protocol을 만족해줘야 한다
}
```

![IMG_8748.PNG](/assets/2024-04-15-SwiftUI-Widget/IMG_8748.png)

**Provider**

```swift

struct Provider: AppIntentTimelineProvider {
    // 데이터를 불러오기 전(getSnapshot)에 보여줄 placeholder
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    // 위젯 갤러리에서 위젯을 고를 때 보이는 샘플 데이터를 보여줄때 해당 메소드 호출
    // API를 통해서 데이터를 fetch하여 보여줄때 딜레이가 있는 경우 여기서 샘플 데이터를 하드코딩해서 보여주는 작업도 가능
    // context.isPreview가 true인 경우 위젯 갤러리에 위젯이 표출되는 상태
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    // 홈화면에 있는 위젯을 언제 업데이트 시킬것인지 구현하는 부분, 위젯편집 후 홈에 돌아갔을 때에도 다시 불림
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // 1분, 2분뒤 ... 로 entry 값으로 업데이트하라는 코드
        let currentDate = Date()
        for minuteOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

```

**Entry View**

실제로 위젯에 보이는 화면

```swift
struct MyWidgetEntryView : View {
    var entry: Provider.Entry // 위젯을 업데이트할 시기를 widgetKit에 알리는 역할

    var body: some View {
        VStack(spacing: 12 ) {
            HStack {
                Text(entry.configuration.favoriteEmoji)
                Text(entry.date, style: .time)
                    .dynamicTypeSize(.medium)
                Spacer()
            }
            Text(checkWorkStatus())
                .font(.caption)
                .frame(maxWidth: .infinity)
        }
    }
}
```

### 앱과 위젯간의 데이터 공유를 위한 사전작업

- 앱과 위젯은 같은 프로젝트 내에 있지만 다른 타겟이여서 userDefault에 넣어놔도 가져오지는 못한다
- 따라서 appGroup을 추가해주고 UserDefault 가져올 때 userdefault.standard가 아닌 UserDeafult(suiteName:)을 호출하여 사용할 것

![스크린샷 2024-04-15 오후 3.22.45.png](/assets/2024-04-15-SwiftUI-Widget/4.png)

```swift
extension UserDefaults {
    static let groupUserDefault: UserDefaults = UserDefaults(suiteName: "group.sunny.widgetGroup")! // widget과 함께 쓰기 위해 app group용 userdefault 생성
}
```

### Intent을 이용하여 위젯 만들기

- IntentConfiguration과 Intent를 GUI로 만든다는 거 외에는 다른점 x
- 그리고 프로토콜에 App을 빼면 동일

![스크린샷 2024-04-15 오후 5.35.07.png](/assets/2024-04-15-SwiftUI-Widget/5.png)

![스크린샷 2024-04-15 오후 5.35.25.png](/assets/2024-04-15-SwiftUI-Widget/6.png)

```swift

struct IntentWidget: Widget {
    let kind: String = "IntentWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration( // AppIntent어쩌고가 아님!
            kind: kind,
            intent: WidgetThemeIntent.self,
            provider: IntentProvider()
        ) { entry in
            IntentWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("써니의 컬러위젯")
        .description"이모지와 색상을 골라보세요!")
        .supportedFamilies([.systemMedium, .systemSmall, .systemLarge])
    }
}

struct IntentEntry: TimelineEntry {
    let date: Date
    let configuration: WidgetThemeIntent
}

struct IntentProvider: **IntentTimelineProvider** { // AppIntent어쩌고가 아님!
    func placeholder(in context: Context) -> IntentEntry {
        IntentEntry(date: Date(), configuration: WidgetThemeIntent())
    }
    ...
}

struct IntentWidgetEntryView : View {
    var entry: IntentEntry
    ...
}
```

### 예시

[https://github.com/sunny5875/WidgetPractice](https://github.com/sunny5875/WidgetPractice)

### 참고

[[iOS - SwiftUI] 1. 위젯 Widget 사용 방법 개념 (WidgetKit, WidgetFamily)](https://ios-development.tistory.com/1131)

[iOS 14+ ) Widget](https://zeddios.tistory.com/1077)

[[swift]Widget 둘러보고 간단히 만들어보기(1)](https://velog.io/@okstring/swiftWidget-둘러보고-간단히-만들어보기)

[WidgetKit (2) - TimelineEntry / TimelineProvider / TimelineReloadPolicy](https://zeddios.tistory.com/1089)

[Sharing Object Data Between an iOS App and Its Widget](https://michael-kiley.medium.com/sharing-object-data-between-an-ios-app-and-its-widget-a0a1af499c31)

[[SwiftUI] Widget 위젯만들기](https://nsios.tistory.com/156#google_vignette)
