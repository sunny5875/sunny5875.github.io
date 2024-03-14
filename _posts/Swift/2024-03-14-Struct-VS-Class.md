---
layout: post
title: 2024-03-14 13:14:45 +0900
date: 2024-03-14 13:14:45 +0900
category: Swift
---

종류: Swift

# 값 타입(value type)

- 스택에 저장되는 타입
- 메모리에 할당된 값 타입의 데이터를 다른 변수, 상수에 복사하면 각각의 인스턴스는 유일한 복사값을 가지게 됨
- 따라서, 복사된 인스턴스 값을 수정해도 기존의 인스턴스에는 영향 x
- 컴파일타임에 언제 사라질 지 알기 때문에 stack에 할당
    - stack이 힙보다 빠른 편
- ex) int, string
- cow기법으로 무분별한 값복사메모리가 낭비되지 않도록 해줌!
    - 단, Swift에서 기본적으로 COW가 구현되어 있는 타입은 Standard Library의 가변 길이를 가진 컬렉션 프로토콜을 준수하는 타입인 Array, Dictionary, Set, String 등이다. (공식문서에 명시되어 있지 않은 컬렉션 타입들도, COW의 목적에 비춰볼때 구현되어 있다고 생각함이 타당한듯)
    - Struct는 기본적으로 COW 동작이 구현되어 있지 않아서, 필요하다면 커스텀하게 구현해 주어야 한다.
- 신기하게 string은 struct 값타입이지만 collection이지만 스택과 힙 모두에 저장됨

### 종류

표준 라이브러리 값 타입은 enum을 제외한 모든 타입이 struct으로 구현됨

- `struct`, `enum`
- `Int`, `Double`, `String`과 같은 기초 타입(Fundamental types)
- `Array`, `Set`, `Dictionary`와 같은 컬렉션 타입(Collection types)
- 값 타입으로 구성된 `tuple`

# 참조 타입(reference type)

- 힙에 저장되는 타입
- 데이터를 가리키는 주소값은 스택에 저장
- 데이터를 참조해서 사용하기 때문에 값 타입과 달리 복사하지 않고 참조값을 사용하기에 복사된 인스턴스에서 값을 바꾸면 기존 인스턴스도 영향받게 됨
- arc로 메모리 관리를 함
- 같은 클래스 인슥턴스를 할당한 후에 값을 변경시키면 모든 변수에 영향을 받는다
- 상속 가능
- deinit으로 메모리 해제가능
    - 여러곳에서 같은 클래스를 참조하게 된다면 참조카운트가 남아있게 되어 deinit이 되지 않아 retain cycle이 생길 수 있음!! → weak로 해결 가능
- 참조가 어떻게 될지 모르기때문에 heap에 할당
    - 컴파일 타임에 사이즈를 정확히 알기 어렵기 때문에 Heap에 할당 후 적절히 저장 공간을 조절하는 것입니다.

### 종류

- class
- closure

## 값 타입 VS 참조 타입

![Untitled](/assets/2024-03-14-Struct-VS-Class/Untitled.jpeg)

### 성능 측면

- 할당된 곳
    - 스택할당: 한방향으로 데이터를 넣고 빼는 구조이므로 스택 포인터로 빠르게 접근 가능
    - 힙 할당: 메모리 공간이 있는지 확인 후에 할당을 처리하는 동적인 구조
        - 오버헤드가 큰 편

→ 일반적으로 좋은 성능의 코드를 작성하기 위해서는 값 타입을 사용하는 것이 좋다

### **공통점**

- 값을 저장할 프로퍼티를 선언할 수 있다
- 함수적 기능을 하는 메서드를 선언 할 수 있다
- 내부 값에. 을 사용하여 접근할 수 있다
- 생성자를 사용해 초기 상태를 설정할 수 있다
- extension을 사용하여 기능을 확장할 수 있다
- Protocol을 채택하여 기능을 설정할 수 있다

**cf. class 인스턴스 print와 struct 인스턴스 print는 다르다?**

- [https://jayb-log.tistory.com/269?category=925157](https://jayb-log.tistory.com/269?category=925157) 참고
- class는 print시 해당 (앱이름이나 __11db_expr).class이름 이렇게 출력됨
    - 안에까지 보고싶다면 **dump로** 출력해볼것!!
- struct은 print해도 안에 property까지 다 출력됨

**Note: 하지만 value type이라고 무조건 stack, reference type이라고 무조건 heap에 저장되는 게 아님!!**

## Value type → Heap에 할당되는 경우

- 가변길이의 Collection들은 컴파일 타임에 사이즈를 정확히 알 수 없기에 내부 데이터를 heap에 저장함
- 예시
    - *Array, Dictionary, Set, String*
- But, Array, String은 value type이기 때문에 인스턴스마다 unique한 데이터를 가져야 함. 하지만 매번 공간을 할당하고 복사하는데 어려워짐

**→ COW(Copy on write)라는 최적화 기법으로 해결!**

**`copy on write`** 기법이란, 값을 새로운 변수에 할당할 때 바로 복사본을 만드는 것이 아니라, **수정(write)이 발생할 때 복사본(copy)을 만드는 것. 수정 전**까지는 기존 element가 저장된 **메모리 주소를 참조**하는 방식으로, 변수간 같은 **instance를 공유**

## Reference type → Stack에 할당되는 경우

- reference type의 사이즈가 고정되어 있거나 lifetime을 예측할 수 있을 때 stack에도 할당할 수 있음

## String

- string은 값 타입이지만 위의 경우처럼 사이즈를 알 수 없어 heap에 할당함
- 따라서 String은 값 타입이지만 힙 할당이 발생됨

```swift
enum Emotion { case happy, sad, angry }
var cachedEmoji = [String: UIImage]()

func getEmoji(_ emotion: Emotion) -> UIImage {
	let key = "\(emotion)" // 힙할당 발생
	if let image = cachedEmoji[key] {
        return image
  }
    ..
}
```

위의 코드에서 String은 값 타입이지만 힙 할당이 발생하므로 우리는 String 대신에 구조체를 만들어서 리팩토링 한다면

```swift
enum Emotion { case happy, sad, angry }
struct Attributes: Hashable {
    var emotion: Emotion
}
var cachedEmoji = [Attributes: UIImage]()

func getEmoji(_ emotion: Emotion) -> UIImage {
	let key = Attributes(emotion: emotion)
	if let image = cachedEmoji[key] {
        return image
  }
    ..
}
```

## 값 타입 안에 참조 타입

```swift
class HighSchool: CustomStringConvertible {
    var description: String {
        return "\(name) High School"
    }

    var name: String

    init(name: String) {
        self.name = name
    }
}

struct Student { // 값 타입 안에 참조 타입을 변수로 가짐
    var highSchool: HighSchool
}

let swiftHighSchool = HighSchool(name: "Swift")

let student1 = Student(highSchool: swiftHighSchool)
let student2 = Student(highSchool: swiftHighSchool)

student2.highSchool.name = "Next"

print(student1.highSchool) // Next High School
print(student2.highSchool) // Next High School
```

- 참조타입인 클래스는 할당 시 값을 복사하지 않고 참조를 통해 값을 접근하기에 모두 바뀐 값으로 출력이 됨

## 참조 타입 안에 값 타입

```swift
struct Company {
    var name: String
}

class Product { // class 안에 struct 넣기
    var name: String
    var company: Company

    init(name: String, company: Company) {
        self.name = name
        self.company = company
    }
}

let apple = Company(name: "Apple")

let iPhone = Product(name: "iPhone12", company: apple)
let macbookAir = Product(name: "Macbook Air", company: apple)

macbookAir.company.name = "Microsoft"

print(iPhone.company.name)     // Apple
print(macbookAir.company.name) // Microsoft
```

- 값 타입인 구조체는 할당 시 값을 복사하여 유일한 값을 가지기 때문에 서로 다른 값이 출력됨

**참고**

[[iOS] Swift의 Type과 메모리 저장 공간](https://sujinnaljin.medium.com/ios-swift의-type과-메모리-저장-공간-25555c69ccff)

[Reference and Value types in Swift - 야곰닷넷](https://yagom.net/courses/reference-and-value-types-in-swift/)

[값이냐 참조냐, 그것이 문제로다](https://velog.io/@eddy_song/value-reference-decision)