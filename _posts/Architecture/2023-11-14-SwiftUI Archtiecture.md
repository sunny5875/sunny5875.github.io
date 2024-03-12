---
layout: post
title: SwiftUI Archtiecture
date: '2023-11-14 19:20:23 +0900'
category: Architecture
---
# swiftUI Architecture

종류: Architecture

# SwiftUI에서의 아키텍처

model - view

![스크린샷 2022-10-13 오후 1.36.11.png](/assets/2023-11-14-SwiftUI Archtiecture/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-13_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_1.36.11.png)

```swift
struct ChatListView: View {
    let chatService: ChatService

    var body: some View {
        NavigationView {
            List(chatService.fetchChats()) { chat in
                NavigationLink(
                    destination: ChatDetailView(chat: chat, chatService: self.chatService)
                ) {
                    ChatCell(chat: chat)
                }
            }
            .navigationBarTitle("Chats")
        }
    }
}
```

```swift
struct ChatDetailView: View {

    private let chat: Chat
    private let chatService: ChatService
    
    @ObservedObject private var keyboardObserver = KeyboardObserver.shared
    
    @State private var newMessage = ""
    @State private var messages: [Message] = []

    /* ... */

    var body: some View {
        VStack {
            List(messages) { message in
                MessageView(message: message,
                            isMine: self.chatService.currentUser == message.sender)
            }

            Divider()

            HStack {
                TextField("New message",
                          text: $newMessage,
                          onCommit: sendMessage)
                Button(action: sendMessage) {
                    Text("Send")
                }
            }
            .padding([.leading, .top, .trailing])
        }
        .padding(.bottom, keyboardObserver.height)
        .navigationBarTitle(Text(chat.title), displayMode: .inline)
        .animation(.easeInOut)
        .onAppear { self.reloadMessages() }
    }

    private func sendMessage() {
        chatService.addMessage(newMessage, to: chat)
        newMessage = ""
        reloadMessages()
    }

    private func reloadMessages() {
        self.messages = chatService.fetchMessages().filter { $0.chatId == chat.id }
    }

}
```

- 장점
    - 빠르게 개발 가능
    - 실제로 변경된 경우에만 업데이트되므로 적게 업데이트된다
- 단점
    - 복잡해지면 보기가 어려워질 수 있다
    - 재사용성이 낮다

# MVVM

- 기존의 uikit에서의 mvvm과 동일

```swift
import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var counterVM: CounterViewModel
    
    init() {
        counterVM = CounterViewModel()
    }
    
    var body: some View {
        VStack {
            
            Text(counterVM.premium ? "PREMIUM" : "")
                .foregroundColor(Color.green)
                .frame(width: 200, height: 100)
                .font(.largeTitle)
            
            Text("\(counterVM.value)")
                .font(.title)
            Button("Increment") {
                self.counterVM.increment()
            }
        }
    }
}
```

```swift
import Foundation
import SwiftUI

class CounterViewModel: ObservableObject {
    
    @Published private var counter: Counter = Counter()
    
    var value: Int {
        counter.value
    }
    
    var premium: Bool {
        counter.isPremium
    }
    
    func increment() {
        counter.increment()
    }
}
```

# Redux

![스크린샷 2022-10-13 오후 1.38.17.png](/assets/2023-11-14-SwiftUI Archtiecture/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-13_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_1.38.17.png)

# Flux

리엑트에서 주로 사용하는 아키텍처

![스크린샷 2022-10-13 오후 1.46.23.png](/assets/2023-11-14-SwiftUI Archtiecture/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-13_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_1.46.23.png)

- action이 발생하면 dispatcher에 의해 store에 변경된 사항이 저장되고 저장된 사항에 따라서 view가 변경되는 단방향패턴
- dispatcher는 action을 정리해주고 store은 어플리케이션의 데이터들이 저장되는 장소
- mvc의 구조의 단점을 보완하는 단방향 데이터 흐름 구조
    
    ![Untitled](/assets/2023-11-14-SwiftUI Archtiecture/Untitled.png)
    
- 장점 : 단방향으로 흐르기 때문에 훨씬 파악하기가 쉽고 코드의 흐름이 예측가능

# Redux

리엑트에서 주로 사용하는 아키텍처

- 
- Flux와 달리 리덕스는 dispatcher라는 개념이 존재하지 않는다.
- 리덕스는 다수의 store도 존재하지 않는다. 대신 리덕스는 하나의 root에 하나의 store만이 존재한다.
- 순수함수(pure functions)에 의존한다. (state의 불변성)

![스크린샷 2022-10-13 오후 3.06.38.png](/assets/2023-11-14-SwiftUI Archtiecture/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-13_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.06.38.png)

![Untitled](/assets/2023-11-14-SwiftUI Archtiecture/Untitled 1.png)

---

# SwiftUI와 Combine

- Combine은 시간의 흐름에 따라 값을 처리하기 위한 Declarative Swift API를 제공하는 프레임워크인 것이다.

![Untitled](/assets/2023-11-14-SwiftUI Archtiecture/Untitled 2.png)

## Publisher

- 게시자

```swift
class IntPublisher: Publisher {

    typealias Output = Int
    typealias Failure = Never

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {

    }
}
```

- output : 어떤 타입의 데이터 스트림을 보낼 수 있는지를 나타냄
- failure : 실패할 경우 어떤 타입을 보낼 것인지
- 해당 publisher를 구독하는 subsciber는 input, failure가 publisher의 output, failure와 일치해야 함
- receive : 해당 publisher를 구독하는 subsriber를 등록할 때 호출되는 메소드

## Subscriber

- publisher를 구독하는 객체 subscriber가 publisher가 발행하는 데이터 스트림을 받아 처리할 수 있다

```swift
class IntSubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never

    func receive(subscription: Subscription) {

    }

    func receive(_ input: Int) -> Subscribers.Demand {
        return .unlimited
    }

    func receive(completion: Subscribers.Completion<Never>) {

    }
}
```

- input : 어떤 타입의 데이터 스트림을 받을 수 있는지를 나타냄
- failure : 실패할 경우 어떤 타입의 형태로 처리되는지
- receive(sub -) : publisher에 대한 구독이 성공했을 때 subscription이라는 객체를 전달받는데 이 때 호출되는 메소드
- receive(input) : 구독중인 publisher에 대하여 value를 전달 받았을 때 호출되는 메소드
- receive(completon) : 구독중인 Publisher로부터 completion을 전달 받았을 때 호출되는 메소드

### Subscription

- 구독을 대변하는 객체
- publisher와 subscriber를 이어줌

```swift
class TestSubscription: Subscription {
    func request(_ demand: Subscribers.Demand) {

    }

    func cancel() {

    }
}
```

- request : subscriver가 얼마나 데이터를 전달받을지를 결정
- cancel : 구독을 취소

### combine 객체들의 상호작용

![Untitled](/assets/2023-11-14-SwiftUI Archtiecture/Untitled 3.png)

1. 먼저 Subscriber 객체가 Publisher에 구독을 시작한다. (Subscriber의 `receive<S>(subscriber: S)` 메서드 실행)
2. Publisher가 Subscription 객체를 생성한다.
3. Publisher가 이를 Subscriber 객체에게 전달한다. (Subscriber의 `receive(subscription: )` 메서드 실행)
4. Subscriber가 Subscription에게 values를 요청한다.
5. Subscription이 values를 가져온다.
6. Subscription이 Subscriber에게 values를 전달한다. (Subscriber의 `receive(_ input: )` 메서드 실행)
7. Subscription이 Subscriber에게 completion을 전달한다. (Subscriber의 `receive(completion: )` 메서드 실행)

<aside>
💡 결론!! 일단은 uikit쓰자…. swiftUI는 너무 시기상조이다… 대신 storyboard code base로 해보자!!

</aside>
