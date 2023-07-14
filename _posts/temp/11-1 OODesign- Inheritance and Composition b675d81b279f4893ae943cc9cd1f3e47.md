# 11-1. OODesign- Inheritance and Composition

많은 설계방법 중에서 객체지향 설계를 배울 것, 오늘은 상속과 composition에 대해서 배우고 다음시간에는 원리에 대해서 배울 것

자바도 했고 객체지향 정리를 했고 여기서는 composition, association, aggegation은 같다고 생각

이걸 이제 비교해볼 것

# 상속과 합성

### 상속

- 상위 클래스의 구현(속성과 메소드의 구현)을 하위 클래스가 물려 받아 확장하기 위한 것

### 합성

- 다른 객체들에게 자신이 해야 할 작업을 위임하여 대신 실행하게 하는 것

**→ 상속을 무분별하게 남용하지 말고 상속이 사용되는 특정 경우에 합성을 적절히 사용했을 때 더 좋은 객체지향 설계가 될 수 있음**

상속대신에 합성을 써라!! 더 유연하게 되어서 결합도가 떨어질 수 있다

## 상속

캡슐화, 클래스는 맴버별수와 그 데이터를 조작하는 함수를 묶어주는 캡슐화, 클래스가 중요하고 그 다음에 상속을 배우고 상속은 재사용할 수 있고 다형성때문에 좋은 편

- 객체지향 언어에서 가장 일반적인 재사용 수단
- 상위 클래스의 속성과 메소드를 하위 클래스가 그대로 재사용할 수 있으며 메소드 오버라이딩을 통해 클래스의 기능을 재정의할 수 있음
- 하위 클래스 나름의 새로운 메소드를 추가하여 정의함으로서 기능을 확장할 수 있음

→ 상속을 통해 개발자가 얻을 수 있는 가장 큰 장점은 다형성 구현

다형성을 지혜롭게 사용하면 쉽게 요구사항을 추가, 반영할 수 있는 유연한 프로그램 설계 가능

### 다형성

- 같은 종류의 여러 객체에게 동일한 메시지를 주었을 때 각자 다르게 행동하는 현상
- 하위 클래스가 상위 클래스의 메소드를 오버라이딩하여 하위 클 래스의 객체를 생성한 후 상위 클래스의 객체 타입으로 할당한 후 해당 메소드를 호출했을 때 하위 클래스 객체의 메소드가 호출되 어 이루어진다.
- 이것은 컴파일 시간에 호출될 메소드가 결정되는 것이 아니라 프 로그램 실행시간에 결정되기 때문에 가능하다(동적바인딩) - 동적 바인딩이 되기 떄문에 오버라이드된 함수가 불려져서 런타임에 결정됨

→ 다형성을 사용하면 유지보수하기 매우 좋은 편, 따라서 사람들이 상속과 다형성을 사용했었음. 하지만 상속을 너무 많이 사용한다면 문제점 발생, 무분별하게 남용하면 안된다. *상속 대신 합성을 쓰자!*

Ex)

![Untitled](11-1%20OODesign-%20Inheritance%20and%20Composition%20b675d81b279f4893ae943cc9cd1f3e47/Untitled.png)

프린터는 추상클래스이고 프린터는 프린트하는 함수를 추상메소드로 됨. 프린터가 될려면 프린트를 오버라이브해야 함, 다형성을 만들기 위해서 추상메소드를 만들어서 자식클래스가 오버라이딩하도록 함

밑에 있는 서브클래스들은 getid도 이미 가지고 있음

제공하는 클래스를 사용하는 클래스 : client

이렇게 다형성을 적용하게 된다면 printer.print는 어떤 프린터기가 추가되어도 영향을 받지 않게 된다

### 상속을 사용할 떄의 주의점

- 상속은 클래스들끼리 영구적으로 is-a, 즉 하위클래스는 상위클래스이다 라는 관계가 성립될 떄 적용하는 것이 좋다
- 상속이라는 의미가 통하지 않음에도 불구하고 단순히 기존의 클래스들의 속성과 메소드를 재사용하기 위해 상속을 사용하는 것은 바람직한 일이 아님→ 합성(aggregation, asoociation) 사용

→ 단지 다형성을 구현하기 위해 상속을 강제로 사용하는 것은 바람직하지 않은 일이며 **합성과 인터페이스**를 같이 사용하면 해결 가능

## 합성

- 특정 메소드의 기능을 수행하기 위해 다른 클래스의 유사하거나 같은 기능의 메소드를 사용하기 위해 클래스들끼리 대등한 관계 로 “결합"된 것을 의미한다. 맴버변수로 가지고 있는 것
- 한 객체가 특정한 일을 수행할 때 자신이 직접하지 않고 다른 객체 에게 그 일을 대신 실행하도록 “위임(delegation)”할 때 바로 “합성”을 사용한다.

![Untitled](11-1%20OODesign-%20Inheritance%20and%20Composition%20b675d81b279f4893ae943cc9cd1f3e47/Untitled%201.png)

우리가 오른쪽 부분을 서비스하기 위해서 만들었고 이걸 사용하느게 클라이언트인데 만든 서비스가 변경된다고 클라이언트가 영향을 받으면 안된다, 클라이언트가 영향을 제일 적게 받는 것이 중요

클라이언트는 backclass를 쓸건데 그 앞에 front class를 줌

Front class에 메소드가 있고 실제 일은 back class가 한다

Client는 front class밖에 안보임, Front는 연결된 back에 위임

### 상속과 합성

![Untitled](11-1%20OODesign-%20Inheritance%20and%20Composition%20b675d81b279f4893ae943cc9cd1f3e47/Untitled%202.png)

왼쪽은 상속, 결합도가 높아짐

오른쪽은 집합으로 맴버변수로 레이저 프린터를 알고 있다

- 왼쪽에 쓰면 모든 프린터의 기능을 쓸 수 있고 오른쪽에 있으면 프린터는 레이의 퍼블릭한 변수와 기능을 접근할 수 이다 : 둘다 접근 가능

### 상속에서 상위클래스가 변경되면

상속을 사용하면 결합도가 커지기에 하위 클래스가 엄청 영향을 받음

- 상속인 경우 LaserPrinter 는 Printer 클래스의 속성과 메소드를 자연스럽 게 물려받아 사용한다.
- 합성에서 Printer 는 LaserPrinter 객체에 대한 레퍼런스를 갖고 그것의 각 종 메소드를 호출한다.
- PrinterExample의 main()의 8라인에서 각 객체의 getID()를 호출하는데, 이 메소드는 상위 클래스인 Printer클래스에 있는 것을 그대로 재사용한 것이다.
    
    → 만약 추후에 Printer 클래스의 getID()의 반환형이 String에서 int로 변경 될 경우, Printer 클래스를 상속받은 하위 클래스들이 영향을 받는다.
    

⇒ 이렇듯 상속의 경우 상위클래스의 내용이 변경되면 이를 물려받는 하위 클래스와 상위 클래스를 사용하는 클라이언트의 코드에 영향을 미친다.

- 상속의 경우, 하위 클래스는 상위 클래스의 데이터와 기능을 물려받아 한 몸을 이룬 것 ⇒ 높은 결합도(한 몸, 하나의 코드)
- 합성의 경우, 두 클래스가 대등한 관계로 묶여있는 별도의 존재

상속을 쓰는 이유는 프린트에있는 pubic한 것을 쓰기 위함인데 맴버변수로 가져도 똑같이 사용 가능

- 합성의 경우 언제라도 뒤에 있는 위임 받는 클래스를 프로그램을 실행하는 중간에 교체할 수 있기에 결합도가 떨어짐
- but, 상속은 하위클래스를 프로그램을 실행하던 중에 상위 클래스를 교체할 수 없음

상속은 컴파일 타임에 결정되지만 합성은 런타임 시 동적으로 바인딩,  연결됨

![Untitled](11-1%20OODesign-%20Inheritance%20and%20Composition%20b675d81b279f4893ae943cc9cd1f3e47/Untitled%203.png)

외부에 보이는 건 printer임

얘는 껍데기인데 실제 일을 하는 건 printerimpl이라는 애가 할 것(합성)

단지 구현하는게 잉크젯, 도트, 레이저 방식일 수 있으므로 추상메소드로 작성

구현을 위임하기에 위임할 것

상속이 아닌 래퍼런스(맴버변수)를 갖고 메소드를 호출한다

클라이언트가 알고 있는 클래스는 printer, 실제 일을 하는 것은 printerimpl, 얘는 내부기능을 구체적으로 정의

상속에서 원하는 효과는 다 볼 수 있다

클라이언트에서는 영향을 안받음

지금처럼 설계하면 printerimpl 클래스의 메소드가 변경되어도 영향받지 않는다

Print함수는 문제가 없고 이전 문제는 getid가 바뀌어서브클래스와 client모두 영향을 받았었는데 printerimpl의 반환이 int가 되므로 client가 영향을 받았는데 껍데기의 id는 int로 바뀌더라도 printer안에서 알아서 바꿀 수 있음

구현체가 client에 바로 노출되었지만 지금은 구현체 위에 레이어가 하나 더있기 떔분에 껍데기에서 알아서 수정 가능

### 합성이 좋은 이유

- 각 프린트들이 Printer클래스를 상속받는 것이 아니라 Printer클래스는 PrinterImpl 객체에 대한 레퍼런스를 갖고 해당 메소드를 호출한다.
- 여기서 FrontClass는 Printer, BackCalss는 PrinterImpl이다.
- PrinterImpl의 하위 클래스들인 InkjetPrinterImpl, DotPrinterImpl, LaserPrinterImpl 등에서 각 프린터의 내부 기능을 구체적으로 정의한다.
- Printer 클래스의 print() 및 getID()를 정의하고 이 메소드 안에서 PrinterImpl객체의 print, getID 메소드를 호출한다.
- 상속을 통해 getID()를 재사용하지 않았지만 이것 또한 PrinterImpl클래 스의 getID()메소드를 재사용한 효과이다.

→ 상속에서 원하는 효과를 다 보면서 결합도는 낮출 수 있다

- 합성의 경우 재사용의 대상인 PrinterImpl 클래스의 메소드가 변 해도 클라이언트의 코드가 변경되지 않는다.
- 왜냐하면 클라이언트 코드가 직접 PrinterImpl을 사용하는 것이 아니라 Printer의 메소드를 거쳐서 간접적으로 사용하기 때문이다.→ 결합도가 떨어짐

![Untitled](11-1%20OODesign-%20Inheritance%20and%20Composition%20b675d81b279f4893ae943cc9cd1f3e47/Untitled%204.png)

합성으로 구현 시 client는 구현체가 수정 시 바로 영향을 받았지만 합성으로 구현한다면 printerimpl(구현체)이 바뀌더라도 printer를 수정해주면 clinet 코드는 영향을 받지 않게 된다.(구현체가 client에 바로 노출되지 않고 앞에 front class가 존재하기 때문)

- 따라서 PrinterImpl 클래스의 메소드가 변경되는 경우에 대응되는 Printer메소드의 내부코드를 수정하여 클라이언트 코드가 변경되지 않도록 할 수 있다.

## 상속과 합성

- 대부분 상속이 필요하다면 합성으로 대체 가능
- 상속을 오용 시 합성을 사용해야 함

상속을 너무 많이 쓸 경우 결합도가 너무 커지기에 합성을 사용해야 한다

상속 – is a 관계가 명확하고 절대로 바뀌지 않을 경우 사용

다형성을 구현하기 위해 일부로 묶은 경우에는 인터페이스와 합성으로 다형성 사용

합성 – is a 관계가  아니지만 재사용할 클래스가 있는 경우 사용, 

시간에 따라서 변할 수 있는 역할을 표현 시 사용

ex) Lion이 tiger로 바뀔 가능성이 없을 때에는 상속 사용 가능

![Untitled](11-1%20OODesign-%20Inheritance%20and%20Composition%20b675d81b279f4893ae943cc9cd1f3e47/Untitled%205.png)

ex) 야생동물이 동물원 동물로 바뀔 수 있으므로, 즉 상태/역할이 바뀔 수 있음. 상속에서는 막 바뀔 경우가 없으므로 합성과 인터페이스를 만들어야 한다, client는 animal만 알고 있으며 바뀌어도 컨트롤이 가능함. 또다른 룰이 생겨도 문제가 없게 된다

![Untitled](11-1%20OODesign-%20Inheritance%20and%20Composition%20b675d81b279f4893ae943cc9cd1f3e47/Untitled%206.png)

(정리)

상속 시에는 Client가 바로 봤었는데 위임을 통해 구현한다면 바로 보지 않게 되어서 animal에 동적으로 넣어주면 된다. 상속 자체는 결합도가 높지만 하나의 레이어를 더 추가해서 결합도가 떨어져야 다른 애가 영향을 덜 받게 된다-> 유지보수하기 쉽다

Cf. 상속 자체가 is a 관계인데 변하고 프로젝트를 진행하게 되면 사실상 합성을 쓰는 게 아닐까요?? 네… 상당히 많이 보일 것… 똑같은 효과를 얻게 디므로 제일 많이 사용하게 될 것

기본 패턴 23가지 전부 기본모양이이럴 것