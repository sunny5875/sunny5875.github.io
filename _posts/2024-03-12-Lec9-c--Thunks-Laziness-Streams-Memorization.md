---
title: Lec9. c++, Thunks, Laziness, Streams, Memorization
categories: ProgrammingLanguage
date: 2024-03-12 22:39:18 +0000
last_modified_at: 2024-03-12 22:39:18 +0000
---

대부분 개념을 c++로 커버할 거임

# 1) Thunks

### Delayed evaluation in c++

![스크린샷 2023-06-10 오후 2.04.38.png](Lec9%20c++,%20Thunks,%20Laziness,%20Streams,%20Memorization%209e9e681fd00149f683e96e3e11eecc21/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_2.04.38.png)

- argument를 Evaluate → pass function → evaluate body → return
    - function body를 evalaute하기 전에 인자를 Evlaute하는데 사실 실제 연산에 arugment가 쓰이지 않는 경우 존재!!
- vec_mult를 그냥 함수 바디안에 넣으면 되자나요 → 그게 원하는 디자인이 아닐 수도 있음!

→ 이 abstraction을 유지하면서 좀 더 쉽게 해보자

### motivation code

![스크린샷 2023-06-10 오후 2.05.37.png](Lec9%20c++,%20Thunks,%20Laziness,%20Streams,%20Memorization%209e9e681fd00149f683e96e3e11eecc21/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_2.05.37.png)

**std::bind**

- `std::bind(vec_mult,a,b);`
- create a closure that more like curried
- 부르지는 않고 그냥 callable object를 생성

### Thunks(== future)

- evaluation을 delay하는 방법
    - function에 expression을 넣자!

**thunk**

- delay evaluation에 사용하는 **Zero argument function**
- ml에서는 expression을 함수안에서 불러서 나중에 evalute하는방법
    - putting that evaluation in function and later call the closure
- 그런거처럼 clousure에 argument를 캡처해놓아서 나중에 evalauation하는 것을 말함
- thunk and thunk == freeze and thaw

![스크린샷 2023-06-10 오후 2.08.45.png](Lec9%20c++,%20Thunks,%20Laziness,%20Streams,%20Memorization%209e9e681fd00149f683e96e3e11eecc21/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_2.08.45.png)

- clousre로도 만들어서 보낼 수 있고 std::bind를 이용할 수도 있음
    - clousure로 만드는 방법이 캡처 방식을 지정해주기 때문에 좀 더 명확

### Key point

delay expression by thunking

- function이 call되었을 때 `e`를 evaluate해서 resturn result
    - zero arugment function for thunking
    - `thunk = [=]() {return e;}`
- evaluate e to some thunk and then call the tunk
    - thunk()

### Thunk의 문제점

- thunk는 필요하지 않을 경우 expensive computation을 skip해주는 장점이 있음

**문제점**

![스크린샷 2023-06-10 오후 2.13.27.png](Lec9%20c++,%20Thunks,%20Laziness,%20Streams,%20Memorization%209e9e681fd00149f683e96e3e11eecc21/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_2.13.27.png)

- delay expression을 한다면 for 문안에 beta를 너무 많이 부르게 됨
    
    →  thunk more than worse
    
- 변수로 만들어서 한번만 하게 할 수도 있지만 이건 코드가 너무 많이 바뀜
- *한번이나 0번 부를 때에는 thunk가 낫지만 여러번 부를 때에는 caller에서 evaluate하는 게 나음*

### Best of both worlds

**lazy evaluation** 

- expensive computation has no side effect라면
    - 필요하기 전까지에는 compute하지 않으면서
    - 결과를 기억해서 나중에는 즉시 사용할 수 있도록 하고 싶다
- 클라이언트 코드는 그대로 유지하고 싶어!! 변수만들어서 저장하고 싶지 않아

ex) 어떤 언어는 내부적으로 thunk를 해서 delay evaluation하는 경우가 있음(헤스켈)

→ **C++** **Promise(concurrency에 관한 라이브러리)**로 해결할 수 있지만 우리는 직접 lazy evaluataion을 만들어서 사용해보자!!

### Promise class with force()

```python
template<typenmame T>
class Promise {
	public:
		bool _computed;
		std::function<T()> _eval;
		T _value;

		Promise(std::function<T()> eval): _eval(eval),_computed(false) {}
		
		T force() {
			if (!_computed) {
					 _value = _eval();
					_computed = true;
			} 
			return _value;
		}
};
```

- Promise ADT는 flag, thunk, valiue를 저장
    - _computed = false → 아직 thunk가 evaluate되지 않았ㄷ아
    - _computed = true → _value는 thunk의 결과

### Using promises

![스크린샷 2023-06-10 오후 2.22.08.png](Lec9%20c++,%20Thunks,%20Laziness,%20Streams,%20Memorization%209e9e681fd00149f683e96e3e11eecc21/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_2.22.08.png)

### Thunk vs promise

- thunk
    - 안쓰이거나 한번정도 사용될 때 좋음
    - 나머지는 worse
- precomputing second argument
    - okay
- promise
    - argument가 안쓰일 때에도 그 외의 경우에도 good

→ 여러번 사용되는 경우 혹은 클라이언트 코드가 더러워지는 게 싫다면 promise를 하는 게 좋음

Q. 그냥 모두 promise를 쓰는게 낫지 않나?

A. 만드는 오버헤드가 있으므로 그 비용보다 클때만 바꾸는 게 맞음

# 2) Streams

- infinite sequence of value
    - lazyList와 매우 비슷
    - 모든 value를 만들어서 stream을 만들 수 없음
    - key idea: use a **thunk** to delay creating most of the sequence
- labor을 나누는 좋은 컨셉
    - stream producer: 어떻게 value를 만드는지 앎
    - stream consumer: 얼마나 많은 수의 value를 물어볼 건지 결정
- 예시
    - user action: action queue가 있고 processo of action 시 pop해서 처리
    - UNIX pipes:  cmd1 | cmd2
    - sequential feedback circuit으로부터 output vlaues

### OOP style

상속해서 next를 오버라이딩해서 구현

```python
#include <iostream>
template<typename T>
class Stream {
	public: virtual T next() = 0;
};

class IntStream: public Stream<int> {
public:
	int _n = 0;
	IntStream() = default;
	virtual int next() {return _n++;}	
};

int main() {
 IntStream s;
	std::cout << "int stream: ";
	for(int i = 0; i< 10;i++){
		std::cout << s.next() << ", ";
	}
	std::cout << std::endl;
    return 0;
}
```

```python
class FiboStream: public Stream<int> {
public:
int _curr = 1, _prev = 0;
FiboStream() = default;
virtual int next() {
		int res = _curr; 
		_curr = _prev + res;
		_prev = res;
		return res; // 다음 꺼를 계산하고 과거 curr을 리턴
	}
};

int main() {
	FiboStream fs;
	std::cout << "fibo stream: ";
	for(int i = 0; i< 10;i++){
		std::cout << fs.next() << ", ";
	}
	std::cout << std::endl;
    return 0;
}
```

![스크린샷 2023-06-10 오후 2.44.42.png](Lec9%20c++,%20Thunks,%20Laziness,%20Streams,%20Memorization%209e9e681fd00149f683e96e3e11eecc21/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_2.44.42.png)

### Functional style

ADT처럼 만들어서 다른 타입도 같은 타입에 사용할 수 있도록 구현(시험에 나온 insertQueue 비슷)

```python
#include <iostream>
#include <functional>

struct StreamPair {
    int val;
    std::function<struct StreamPair()> next; // 다음의 자기를 새로 생성해서 리턴
    StreamPair(int v): val(v) {}
};

int main() {
    std::function<struct StreamPair(int)> f = [&](int x) {
        struct StreamPair _p(x);
        _p.next = [=]() {
            return f(x+1);
        };
        return _p;
    };
    struct StreamPair p = f(0);
    for(int i =0; i<10; i++) {
        std::cout<< i <<"th val: "<< p.val << std::endl;
        p = p.next(); // 매번 다음 next를 자기에게 다시 할당
    }
}
```

```python

int main() { 
    std::function<struct StreamPair(int, int)> f2 = [&](int curr, int prev) {
        struct StreamPair _p(curr);
        _p.next = [=]() {
            return f2(curr+prev, curr);
        };
        return _p;
    };
    struct StreamPair p2 = f2(1,0);
    for(int i =0; i<10; i++) {
        std::cout<< i <<"th val: "<< p2.val << std::endl;
        p2 = p2.next();
    }
}
```

![스크린샷 2023-06-10 오후 2.46.31.png](Lec9%20c++,%20Thunks,%20Laziness,%20Streams,%20Memorization%209e9e681fd00149f683e96e3e11eecc21/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_2.46.31.png)

### Example using stream

```python
int numbers_until(struct StreamPair s, std::function<bool(int)> tester) {
    int count = 0;
    while(!tester(s.val)){
        s= s.next();
        count ++;
    }
    return count;
}

int main() {
	int res1 = numbers_until(f(0), [](int x){return x >= 10;});
   std:: cout << "numbers_until(intNum >= 10)" << res1 << std::endl; // 10
	int res2 = numbers_until(f2(1,0), [](int x){return x >= 100;});
    std:: cout << "numbers_until(fibo >= 100)" << res2 << std::endl; //11
}
```

```python
auto numbers_until2 = [](struct StreamPair s, std::function<bool(int)> tester){
        std::function<int(struct StreamPair, int)> f = [&](struct StreamPair _s, int ans) {
            if (tester(_s.val)) return ans;
            else return f(_s.next(), ans+1);
        };
        return f(s, 0);
    };

int res1_ = numbers_until2(f(0), [](int x){return x >= 10;});
std:: cout << "numbers_until(intNum >= 10)" << res1_ << std::endl; //10
int res2_ = numbers_until2(f2(1,0), [](int x){return x >= 100;});
std:: cout << "numbers_until(fibo >= 100)" << res2_ << std::endl; // 11
```

# 3) Memorization

- side effect가 없고 mutable memory를 읽는 function이라면 같은 argument를 여러번 해도 같은 겨로가가 나올 것
    - keep cache of previous results
    - 인자와 결과를 테이블에 캐싱해서 같은 아규먼트로 부르면 그냥 테이블에 있는 값을 리턴하는 건 어떨까???
    - 나은 조건
        - recomputing보다 maintaining cache가 더 싼 경우
        - cache의 결과가 재사용
- promise와 비슷하지만 argument를 가지기 때문에 mutliple previous result를 가지고 있음
- recursive function + memorization
    - exponentially faster program
    - dynamic programming과 같은 복잡도와 알고리즘이 됨
        - 라지 테이블이 있고 build up the table
        - result computation이 multiple time이니까 computaion을 여러번 하지 말고 그냥 한번만 하기위해 테이블에 넣어서 사용

Q. 같은 복잡도 이게 무슨 소리일까욤

A. 다이나믹 프로그래밍에서 제일 많이 쓰이는 게 matrix mult chain 예시인데 (((A * B) * C) * D) E 이렇게도 할 수 있지만 순서를 맘대로 막 다르게 해도 cost가 달라짐. 그 모든 케이스를 다 보고 cost를 결정하고 싶은데 B C D E 랑 B C하고 A,D 순서로 하고 싶으면 B,C는 같은 거니까 테이블에 넣어서 빨리 계산할 수 있도록

Q. floating point을 넣어서 계산하는 거에도 memorization을 쓰면 좋겠네?

A. takes floating point arugment해서 계산하는 거에는 좋지 않음!!  어쩄든 function의 결과를 쓰는 코드 입장에서는 캐시에서 저장된 값을 가져와서 계산하는 거랑 다시 계산해서 나온 거랑 다르다?? 왜??? arugment로 같은 값을 쓸 일이 없다래… floating point는 정확히 같은 arugment로 올 가능성이 낮음. 일반적으로는 그럴 일 이 없음. floating point를 정확히 같은 값을 넣을 가능성이 낮음. 왜냐면 근사값을 넣기 때문. less likely integer.  같은프로그램에서 integer를 받는다도 한다면 floating point보다 훨씬 더 같은 아규먼트를 부를 확률이 높음.

### See Example

- 모든 call이 cache를 share하기 위해 함수 밖에 선언해야 함

![이 예시를 memorizaiton으로 바꿔보자!](Lec9%20c++,%20Thunks,%20Laziness,%20Streams,%20Memorization%209e9e681fd00149f683e96e3e11eecc21/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_3.21.10.png)

이 예시를 memorizaiton으로 바꿔보자!

### C++ naive version - slow

![스크린샷 2023-06-10 오후 3.21.36.png](Lec9%20c++,%20Thunks,%20Laziness,%20Streams,%20Memorization%209e9e681fd00149f683e96e3e11eecc21/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_3.21.36.png)

### Fib2

![스크린샷 2023-06-10 오후 3.21.47.png](Lec9%20c++,%20Thunks,%20Laziness,%20Streams,%20Memorization%209e9e681fd00149f683e96e3e11eecc21/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2023-06-10_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_3.21.47.png)

- nested function은 인자에 2개의 이전과 이이전값과 index를 받아서 i가 n이면 curr+ prev를 리턴하고 n이 아니면 recursion
- fibo return pair와 아주 비슷하지만 이건 그냥 약간의 varaiation이라고 볼 수 있음

memorizaiton으로 해보자!

### Fib3

```python
int fib3(int n) {
	**static std::map<int,int> idxVal;**
	if(idxVal.count(n) > 0 ) return idxVal[n];
	else {
		if(n== 0 || n == 1) return n;
		else {
			int res = fib3(n-1) + fib3(n-2);// fib3(n-1)하면서 n-1까지는 다 memorization될 것
			idxVal[n] = res;
			return res;
		}
	}
}
```

- fib2, fib3이 굉장히 빠른 편이고 fib은 느린 편
    - fib2가 fib3보다 빠름
        - fib3의 map은 look up시간이 길기 때문
        - 물론 fib2의 람다함수 생성하는 오버해드가 존재하긴 함

Q .tail recursive는 별도의 공간이 아닌 추가적인 argument로 해결했는데 왜 굳이 memorization을??

A. 빠른 것도 있지만 반복해서 계산하니까 필요한거임…. 

tail recursion이랑 memorization은 다른 개념

- tail recursion은 코드가 약간 복잡해지는거랑 속도가 빨라지는 trade off
- memorization은 메모리를 더쓰냐 computation을 더쓰냐 trade off
    - 같은 인자에서 자주 부르는 경우에 memorization이 좋음
- tail recursion이랑 memorization은 orthogonal개념이니까 동시에 적용 가능
    - fib2는 재귀할 때 옛날 꺼 쓰는 거고 fib3은 그 개념 포함하면서 똑같은 인자를 여러번 불러도 빨리 되도록