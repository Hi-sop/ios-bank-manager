## 은행 창구 매니저
``
예금, 대출 업무를 요구하는 고객 대기열을 추가할 수 있고 대기열에 따라 업무를 처리하는 과정과 처리시간을 보여주는 앱입니다.
여러명의 은행원이 동시에 업무를 처리해야했으므로 동시성 프로그래밍을 활용했습니다.
``

---
### 목차
- [팀원](#팀원)
- [타임라인](#타임라인)
- [실행 화면](#실행-화면)
- [트러블 슈팅](#트러블-슈팅)
- [참고 링크](#참고-링크)

---
### 팀원
|Hisop|
|---|
|[GitHub](https://github.com/Hi-sop)|

### 타임라인

|날짜|내용|
|---|---|
|23.11.13|LinkedList, CustomQueue구현 / pakage 사용법 익히기|
|23.11.14|유닛테스트 구성, TestDouble|
|23.11.15|코드 분리 및 유닛테스트 일부 수정|
|23.11.17|은행과 고객 타입 설계 추가, 뱅크매니저의 호출방식 변경|
|23.11.21|Concurrency 설계(GCD)|
|23.11.22|업무를 처리하는 은행원타입 추가, 처리용 Queue추가|
|23.11.23|GCD -> Operation 리팩토링|
|23.11.24|WorkItem의 기능 일부 메서드로 분리, UI코드 작성|
|23.11.25|StackView정리 및 스크린 업데이터, 타이머 업데이터 구현, 오토레이아웃 정리|

### 실행 화면
<img width="370" height="700" src="https://github.com/Hi-sop/ios-bank-manager/assets/69287436/11e5b096-930b-4a7b-a363-cb366c74dcc6">

### 트러블 슈팅

#### Generic(associatedtype)을 채택한 Protocol
일반적으로 Test-Double 구성에는 프로토콜을 사용하기에 상속으로 구현했던 부분을 프로토콜로 구현하고자 했다
하지만 Generic을 채택한 프로토콜은 any없이 프로퍼티의 타입으로 지정해놓을 수 없었다.

제네릭 타입인 associatedtype T는 프로토콜에 정의되어있으므로 인스턴스화 되기 전까진 컴파일러가 어떤 타입인지 추론할 수 없었다.
```swift
protocol ListProtocol {} 

class Test {
  var List: any ListProtocol 
}
```
class에서도 제네릭 타입을 지정해주었지만 컴파일러는 class의 T가 프로토콜의 T와 같다고 말하지 않았다.  
따라서 any + 프로토콜을 통해 어느 타입이든 들어올 수 있게 하고, 필요할때마다 다운캐스팅을 거친 뒤 사용해야했다.  
  
Mock객체를 활용해 테스트더블을 구현하는 것이 목표였으므로 상속과 override를 통해 구현하는 쪽으로 방향을 변경했다.
```swift
final class MockLinkedList<T>: LinkedList<T> {
    private(set) var callMethodCount = 0
        
    override var checkEmpty: Bool {
        callMethodCount += 1
        
        return true
    }
}
```

#### wait과 mainThread sync
Bank의 동작들을 구현할 때 UI에서의 동작은 고려하지 않은 채 코드를 구성했다.  
```swift
private func startWork() {
  for _ in 1...employeesCount {
    DispatchQueue.global().async(group: group, execute: workItem)
  }
  group.wait()
}
```
Bank의 동작들이 consoleApp에 띄워질 때 내 코드는 메인 스레드가 큐의 처리를 기다리고 있는 형태였다.  
각각의 은행원들(스레드)는 비동기적으로 동작할 수 있었으나 정작 그들을 호출한 mainThread는 wait()명령에 가로막혀 아무것도 수행할 수 없는 상태였다.  
결과적으로 내 코드는 UI를 정상적으로 갱신할 수 없었다.  

```swift
DispatchQueue.global().async(execute: { self.bankManager.bank.open() })
```
은행의 문을 열 때 메인스레드에서 호출하지 않도록 변경하여 메인스레드가 정상적으로 UI갱신을 할 수 있도록 했다.

#### Operation의 스레드 생성
Bank의 동작을 처음 구현할 때 GCD를 사용했다. 리팩토링과정에서 코드의 간결함, 가독성을 이유로 Operation으로 리팩토링했다.
실제 동작에는 변화가 없었지만 스레드의 동작이 차이가 있었다.

```swift
let queue = OperationQueue()
queue.maxConcurrentOperationCount = 2
```
내 operation코드는 동시에 처리할 수 있는 max값을 제한시켜놓았지만 스레드는 시스템이 자동으로 생성해주고 있었다.
operation Queue는 작업을 쌓아놓을 수 있었기 때문에 처리 Queue의 상태와 상관 없이 작업들을 미리 넘겨주게 되었다.

이 때 문제가 생겼다. 큐에 여러 작업들이 쌓일 때 스레드가 미리 생성되어 쌓이고 있었던 것
나는 `스레드의 수 == 은행원의 수` 라고 생각했고 스레드가 과도하게 생성되는 것도 원하지 않았기에 GCD로 다시 변경하게 되었다. 

---

### 참고 링크
- [SwiftGenericsProtocols](https://a11y-guidelines.orange.com/en/mobile/ios/wwdc/nota11y/2022/22SwiftGenericsProtocols/#protocol)  
- [Opaque Type](https://zeddios.tistory.com/1366#google_vignette)
- [DispatchWorkItem](https://developer.apple.com/documentation/dispatch/dispatchworkitem)
- [Operation](https://developer.apple.com/documentation/foundation/operation)
- [NSLayoutConstraint](https://developer.apple.com/documentation/uikit/nslayoutconstraint)
- [arrangedSubviews](https://developer.apple.com/documentation/uikit/uistackview/1616232-arrangedsubviews)
- [Timer](https://developer.apple.com/documentation/foundation/timer)
