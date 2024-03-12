---
layout: post
title: Bluetooth LE
date: '2024-03-04 23:25:33 +0000'
category: Swift
---
# Bluetooth LE

종류: Develop

### 리서치 주제

- Bluetooth 관련 테스트 handshaking 과정이 필요 없이 바로 가능한지? (바로 가능한지)
    
    ex) 만나자마자 이름 정도만 확인 고 파일 전송 - > 바로 검증
    
- 1(검증자) 대 다(대상자) 블루투스 연결이 가능한지 ?

### 리서치 결과

- handshaking없이 나오는 기기 리스트마다 connect를 코드로 진행한다면 충분히 가능
    - 이 때 기기 리스트는 serviceUUID를 기준으로 검색하기 때문에 유니와플 앱을 가진 사람들에 한해서 리스트가 나옴
- 1:다 블루투스 연결
    - 위의 결과를 통해서 일대다도 가능
    - 단, 전송하는 데이터가 길어진다면 꼬일 가능성이 있기 때문에 추후에 넣을 때에는 일단은 1:1이 유리할 것으로 생각됨

### 리서치 세부사항

- [https://github.com/sunny5875/BLE_Practice](https://github.com/sunny5875/BLE_Practice) 해당 레포에서 진행
- apple 공식 레퍼런스에 있는 예시에서 원하는 부분을 수정하면서 진행
- 진행한 예시는 Bluetooth low energy를 이용해서 진행
    - 기존 블루투스보다 저전력으로 연결이 가능한 기술
- **블루투스 기본 구조**
1. central: 연결할 기기들을 스캔하고 연결하는 중앙 디바이스
    1. 이 때 연결할 기기는 특정 service(UUID)를 가진 디바이스 리스트이므로 유니와플 앱만 가진 기기만을 검색할 수 있음
2. peripheral: 블루투스로 연결할 주변기기, central에게 연결을 요청하는 형태
- **주고 받는 방식**
    - peripheral에서 데이터를 작성한 후에 끝에 EOM같은 메세지가 끝나는 의미의 토큰을 전달한다면 central에서는 메세지를 전부 받았다라고 인식하여 그 때 메세지를 가지고 검증 하면 됨
    - 메세지 포맷은 현재 Byte array이므로 파일도 가능할 것으로 보이긴 하나 용량에 따른 테스트 필요
- **과정**
    - 검증할 사람은 검증할 화면(기기들을 스캔하는 화면)을 킨다
    - 검증데이터를 보낼 사람은 보낼 데이터를 세팅한 후에 요청버튼을 누른다
    - 검증할 사람은 나오는 주변 기기 리스트중에 하나를 선택한다(or 내부적으로 알아서 모두 연결 가능)
    - 검증데이터를 보낼 사람은 연결된 상태라면 데이터를 전송한다
    - 검증할 사람은 해당 데이터를 수신한다
    - 후에 검증 과정을 실행하면 될 것으로 보임

### 참고 자료

[https://developer.apple.com/documentation/corebluetooth/transferring_data_between_bluetooth_low_energy_devices](https://developer.apple.com/documentation/corebluetooth/transferring_data_between_bluetooth_low_energy_devices)

- 1(검증자) 대 다(대상자) 블루투스 연결이 가능한지 ?

### 리서치 결과

- handshaking없이 나오는 기기 리스트마다 connect를 코드로 진행한다면 충분히 가능
    - 이 때 기기 리스트는 serviceUUID를 기준으로 검색하기 때문에 유니와플 앱을 가진 사람들에 한해서 리스트가 나옴
- 1:다 블루투스 연결
    - 위의 결과를 통해서 일대다도 가능
    - 단, 전송하는 데이터가 길어진다면 꼬일 가능성이 있기 때문에 추후에 넣을 때에는 일단은 1:1이 유리할 것으로 생각됨

### 리서치 세부사항

- [https://bitbucket.org/waffle-hanyang/bluetoothtest_ios/src/master/](https://bitbucket.org/waffle-hanyang/bluetoothtest_ios/src/master/) 해당 레포에서 진행
- apple 공식 레퍼런스에 있는 예시에서 원하는 부분을 수정하면서 진행
- 진행한 예시는 Bluetooth low energy를 이용해서 진행
    - 기존 블루투스보다 저전력으로 연결이 가능한 기술
- **블루투스 기본 구조**
1. central: 연결할 기기들을 스캔하고 연결하는 중앙 디바이스
    1. 이 때 연결할 기기는 특정 service(UUID)를 가진 디바이스 리스트이므로 유니와플 앱만 가진 기기만을 검색할 수 있음
2. peripheral: 블루투스로 연결할 주변기기, central에게 연결을 요청하는 형태
    1. peripheral은 여러개의 servic를 가질 수 있고 하나의 service는 characteristic을 가질 수 있다.
    2. service: peripheral이 가지고 있는 하나의 기능
    3. characteristic: peripheral이 실질적으로 가지고 있는 데이터
    
    ![Untitled](/assets/2024-03-04-Bluetooth LE/Untitled.png)
    
- **주고 받는 방식**
    - peripheral은 특정 characteristic를 세팅하고 해당 characteristic을 service를 만든 후 advertise 해서 central이 찾을 수 있도록 한다.
    - central이 특정 service UUID를 가지고 있는 peripheral 리스트를 scan한다.
    - peripheral을 찾으면 central은 handshaking을 요청한다
    - peripheral과 연결되면 central은 service에 데이터를 보내고 받는다.
- **테스트 앱 과정**
    - 검증할 사람(Central)은 검증할 화면(기기들을 스캔하는 화면)을 킨다
    - 검증데이터를 보낼 사람(Peripheral)은 보낼 데이터를 세팅한 후에 요청버튼을 누른다
    - 검증할 사람은 나오는 주변 기기 리스트중에 하나를 선택한다(or 내부적으로 알아서 모두 연결 가능)
    - 검증데이터를 보낼 사람은 연결된 상태라면 데이터를 전송한다
    - 검증할 사람은 해당 데이터를 수신한다
    - 후에 검증 과정을 실행하면 될 것으로 보임

### iOS, Android 크로스 테스트할 때 유의할 점

- 공통 유의점
    - serviceUUID와 characterisiticUUID를 무조건적으로 같게 세팅해야 한다. 아니면 검색 불가
    - Characteristic만들 때 property와 permission을 세팅할 때, 같은 값으로 세팅해야 문제없이 안드로이드와 iOS 모두 검색 가능하다.
    - 원래의 경우, 페어링 된 기기에만 이름이 표출되고 아닌 경우 이름이 나오지 않는데 android, ios 서로의 기기는 상관없이 unnamed로 나온다.
    - 기기 스캔 시, RSSI 값이 같이 나오는데 해당 값은 전력신호를 의미하여 기기간의 전력 세기를 알 수 있어 위 값에 따라 감지할 정도를 정할 수 있다.
- 안드로이드 유의점
    - 안드로이드와 iOS의 프로토콜이 형식 달라 android는 GATT라는 서비스를 open해야 iOS에서 검색 가능
- iOS 유의점
    - info plist에 기본적인 Privacy - Bluetooth Always Usage Description, Privacy - Bluetooth Peripheral Usage Description도 추가 필요

### 참고 자료

[https://developer.apple.com/documentation/corebluetooth/transferring_data_between_bluetooth_low_energy_devices](https://developer.apple.com/documentation/corebluetooth/transferring_data_between_bluetooth_low_energy_devices)

---

**안드로이드와 iOS 끼리의 블루투스 테스트**

- 아이폰
    - 테스트앱에는 버즈, 갤럭시 워치 다보이는데 안드로이드 폰이 안보임
    - 설정앱에서 기기를 연결한 상태에서는 기기목록에 보임

**⇒ 해결한 방법: 안드로이드와 아이폰 끼리 service를 만들때 property와 permission을 잘 설정해줘야 함.  상대방의 입장에서의 property와 permission을 설정해줘야한다는 점!! 그거 땜에 다르면 주고받는게 안되는 거였음 ㅠㅠ 각자 설정한 값이 다르다보니 안드로이드 코드 다 읽어보고 해결함…ㅎ… 유의해서 할 것!!!**
