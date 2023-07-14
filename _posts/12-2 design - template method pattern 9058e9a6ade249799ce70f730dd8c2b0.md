# 12-2. design - template method pattern

### 공통 코드의 재사용 방법

ex)엘리베이터 제어 시스템을 만들 것

- 하드웨어 모터를 조작할 수 있는 로직을 만들 것인데 현재를 현대 모터 를 이용, 클래스를 만들 것, 모터의 상태는 열거형으로 만듦
- 

![Untitled](12-2%20design%20-%20template%20method%20pattern%209058e9a6ade249799ce70f730dd8c2b0/Untitled.png)

### 문제점

- 다른 회사의 모터를 제어하는 경우 새로운 클래스를 만들면 구체적으로 동작하는 부분만 달라지고 전체적인 작동방식은 동일, 실제로 private한 함수만 다르고 공통된 부분이 같음. 모터작동방식은 동일하지만 구체적인 모터 움직임만 다름.

### 해결점

- 2개 이상의 클래스가 유사한 기능을 제공하면서 중복된 코드가 있는 경우 상속을 이용, motor를 추상 클래스로 만들어서 상속받아서 사용할 수 있도록 제공
    
    ![Untitled](12-2%20design%20-%20template%20method%20pattern%209058e9a6ade249799ce70f730dd8c2b0/Untitled%201.png)
    
- move 메소드에 공통적인 부분이 많으므로 상위클래스로 이동, 공통적인 부분이 많은 move에서 다른 부분인 실제로 직접 움직이는 moveMotor 메소드를 추상클래스로 해서 move 안에서 다른 구체적인 부분은 추상클래스 호출

![Untitled](12-2%20design%20-%20template%20method%20pattern%209058e9a6ade249799ce70f730dd8c2b0/Untitled%202.png)

메소드의 전체적인 틀,흐름은 비슷한데 이름만 다르며 어떤 부분만 조금씩 다른 편(move의 전체적인 흐름은 비슷)

## template method pattern

- 객체의 연산에는 뼈대만을 정의하고 구체적인 처리는 하위클래스로 미룬다
- 구조는 그대로 두는 체 각 단계 처리는 하위 클래스에게 재정의하도록 한다(abstract)
- 전체적인 알고리즘은 구현하면서 상이한 부분만은 하위 클래스에서 구현할 수 있도록 하여 전체적인 알고리즘 코드를 재사용하는데 유용
- 전체적으로 동일하면서 부분적으로 다른 문장을 가지는 메소드의 코드 중복을 최소화할 떄 유용

![Untitled](12-2%20design%20-%20template%20method%20pattern%209058e9a6ade249799ce70f730dd8c2b0/Untitled%203.png)

Template : move method, 틀, 규칙, 일하는 순서는 같지만 어느 시점에서 구체적으로 일하는 시점이 달라지기 때문에 클래스를 따로 만들어서 상속해서 해결, 엘지는 엘지방식대로 현대 모터는 현대방식대로 일할 수 있다.

일하는 순서를 바꿔야 한다면 하나로 합치고 구체적인 부분만은 abstract method로 만들어놔서 해결,

템플릭 메서드 : 틀

Hook method : 구체적인 방식이고 각각이 하기 위해 abstract을 만들어서 상속받아서 오버라이딩하여 다형성이 적용되도록 함

큰 규칙을가지고 어느 시점에 abstract method를 호출하는 메소드를 템플릿 메소드라고 한다, 특정시점에서 오버라이딩된 메소드르 호출 : 건다. Hook method, concrete method를 걸어서 제대로 구현되게 한다.

규칙을 갖고 있다가 특정 시점이 되면 primitive operation을 호출함

### 클래스 다이어그램

![Untitled](12-2%20design%20-%20template%20method%20pattern%209058e9a6ade249799ce70f730dd8c2b0/Untitled%204.png)

(모터 예제의 template method pattern 적용)

![Untitled](12-2%20design%20-%20template%20method%20pattern%209058e9a6ade249799ce70f730dd8c2b0/Untitled%205.png)

프레임워크에도 규칙이 존재하고 템플릿 메소드가 존재하고 있음. 어느 순간 추상화된 메소드를 우리가 오버라이드하고 템플릿메소드가 일하다가 나의 hook method를 프레임워크에서 picking되어 돌아갈 것, 규칙을 정해주는 메소드가 템플릿메소드고 틀이 있지만 안에 구체적인 동작이 다르다면 hook method로 구현.

ex)

template method : abstract display

 primitive method : open, print,close, template method을 상속받아서 구현

Swing예제 제외 command line 에제들은 고칠 수 있어야 한다. 시험에 나옴