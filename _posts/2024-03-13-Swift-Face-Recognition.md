---
layout: post
title: Swift Face Recognition
date: 2024-03-11 23:25:33 +0000
category: Swift
---

종류: Develop

### 개요

- sss에서 얼굴이 나오면 특정된(feature extraction) 128개의 float 배열이 나오도록 하기 위해 시작한 스터디!!

### 얼굴인식 구현 방법

[Real-time Face Detection on iOS](https://www.bombaysoftwares.com/blog/real-time-face-detection-on-ios/)

- AVKit와 Vision Framework, VNDetectFaceLandmarksRequest api를 사용해서 얼굴인식 좌표 구함 → 그 후 각 normalized point들과 원점사이의 거리를 계산해여 배열로 계산

### AVKit VS AVFoundation

- 둘 다 프레임워크이지만 AVFoundation이 좀 더 로우레벨의 framework인 것으로 보임

![Untitled](/assets/2024-03-13-Swift-Face-Recognition/Untitled.png)

1. AVFoundation
    1. 미디어 프레임워크, 주기능은 미디어 재생에 관한 기능
2. ABKit
    1. AVFoundatin 위에 있는 보조 프레임워크

Q. 근데 지금은 얼굴에 있는 점들이 나오는데 매번 같은 얼굴이면 같은 점들이 나오는게 아닌데 어떻게 해야할까?

A. 나만의 모델이 있어야할 것 같은데 creat ML만드는 법이 있는데 문제는 ios에서 만드는 게 아니라 xcode에서 만들고 만들어진 모델로 ios에 넣는 걸로 보임(아래 참고)

[Swift(스위프트): Core ML + Create ML 기초 요약 上 (기계학습 모델 만들기) - BGSMM](http://yoonbumtae.com/?p=4889)

- subinClassifer.mlmodel을 만들어서 해봤는데 맥북 캠으로 실시간으로 나인지 체크할 수 있음
- swift로도 만들 수 있는데 ios 15버전부터 지원됨 또한 안드로이드와 함께 써야하기 때문에 이 방법은 적절하지 않다고 판단

```swift
//
//  TraningModel.swift
//  faceRecognition
//
//  Created by 현수빈 on 2023/02/03.
//
import CreateML
import Foundation

class SwiftFaceRecognitionML {
    
    func createModel(filePath: URL)
    {
        
        do {
            // specify data
            let trainDirectory = filePath//URL(fileURLWithPath: filePath)
            let testDirectory = filePath//URL(fileURLWithPath: filePath)
            
            
            // create model
            if #available(iOS 15.0, *) {
                let parameter = MLImageClassifier.ModelParameters(
                    featureExtractor: .scenePrint(revision: 1),
                    validationData: nil,
                    maxIterations: 20,
                    augmentationOptions: [.crop])

                let model = try MLImageClassifier(trainingData: .labeledDirectories(at: trainDirectory), parameters: parameter)
                
                // evaluate model
                let evaluation = model.evaluation(on: .labeledDirectories(at: testDirectory))
                
                // save model
//                try model.write(to: URL(fileURLWithPath: "~/Desktop/FruitClassifier.mlmodel"))
                saveModel(model: model)
                
            } else {
                // Fallback on earlier versions
            }
           
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @available(iOS 15.0, *)
    func saveModel(model: MLImageClassifier) -> Bool {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HH:mm:ss"
        let convertCreateStr = dateFormatter.string(from: nowDate)
        
        let file = "subinClassifier.mlmodel"
        let fileManager = FileManager.default
        
        do {
            // create folder
            let folderPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Training")
            if !fileManager.fileExists(atPath: folderPath.path) {
                try fileManager.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
            }
            // create file
            let fileURL = folderPath.appendingPathComponent(file)
            // write file
            try model.write(to: fileURL)
            print("=== success export share file ===")
            
            return true
        } catch let error {/* error handling here */
            print(error.localizedDescription)
            return false
        }
    }
}
```

→ [https://medium.com/codex/ios-real-time-face-recognize-application-base-on-facenet-9114c818dc73](https://medium.com/codex/ios-real-time-face-recognize-application-base-on-facenet-9114c818dc73) 참고하면

1. mlmodel로 테스트 → 3명부터 이상해진다고 함
2. turi로 테스트 → 10명까지만 된다고 함, 512의 벡터가 나오긴 함
3. faceNet을 앱에 넣어서 사용 → `pod 'TensorFlow-experimental'로 설치`
    1. 이 때 modelFacenet.pb 파일 찾아서 다운로드 해서 넣어줘야함!!!

### 문제점

- 너무 옛날 예시인지 호환이 전혀 되지 않아 돌아가지를 않음 유지보수를 위해서라도 이건 아니라고 생각됨
- tensorflow swift가 현재 아카이빙되어있는 상태인데 음 이게 개발이 완료되었다는 말보다는 더이상 지원을 안하겠다는 입장이 많아 쓰면 부적절
- mlmodel이 그나마 많은데 문제는 아직 트레이닝되지 않은 128개의 벡터가 나오는 얼굴인식 모델이 구글링해도 없음 대부분 face detect가 많은 편

cf. **Face Recognition 과정**

1. **Face Detection**: The first step in the face recognition pipeline is to detect all the faces in the image. This can be done using a face detector such as Haar cascades, Histogram of Oriented Gradients (HOG), or deep learning-based face detectors. In this tutorial, we will use the HOG face detector provided by Dlib.
2. **Face Alignment using facial landmarks (optional)**: The second step in the pipeline is to align or normalize the face using facial landmarks. This step is optional but it can improve the accuracy of the face recognition system. For simplicity, we will skip this step in this tutorial.
3. **Face Encoding**: In this step, we pass the face image to the model and extract the facial features.
4. **Face Recognition**: This is the last step in the pipeline where we compare the extracted face features with a database of known face features and try to find a match. This can be done using a variety of different algorithms, including K-Nearest Neighbors (KNN), Support Vector Machine (SVM), Random Forest, etc.

---

### 재시도

관련 딥러닝 라이브러리(xcode에서 지원할 수 있는 라이브러리 위주로)

- tensorflowlite
    - .tflite 모델을 사용할 수 있음
    - 더 작은 바이너리 크기를 가지고 있음
    - training 하는 예시가 없음
- ~~tensorflow experimental~~
    - 지원은 하지만 용량이 큰 편, pod로 설치할 경우 450메가 정도 됨
    - 더이상 지원안하는 걸로 보임
- opencv
    - c++ 라이브러리
    - 옛날 예시가 많은 편
- dlib
    - c++ 라이브러리
    - 옛날 예시가 많은 편
- face sdk
- coreml
    - .mlmodel 모델 사용 가능
    - .pb를 .mlmodel로 변환하여 사용
    - star이 많은 편
- MLKit with firebase
    - firebase에 들어있는 라이브러리로 .itfilite 모델을 인터페이스로 사용 가능

1. **아래 링크로 ui 구성**
- [https://github.com/hosituan/clockon-clockoff-face-recognition/tree/master/PersonRecognize/ViewController/View Face](https://github.com/hosituan/clockon-clockoff-face-recognition/tree/master/PersonRecognize/ViewController/View%20Face) 참고

[iOS Real-time Face Recognize Application base on FaceNet](https://medium.com/codex/ios-real-time-face-recognize-application-base-on-facenet-9114c818dc73)

1. **아래 링크로 dlib 연결**

[Getting started with dlib on iOS](https://medium.com/@prabhu_irl/getting-started-with-dlib-on-ios-5e66d77380d)

1. **dlib연결은 했으나 feature extract 관련 함수 작성 시 undefined symbol 에러 발생**

⇒ 위의 글에 따라서 열심히 해본 결과 위에를 하면 x86_64(mac os)로 빌드되어서 feature extractor부분 함수에서 자꾸 undefined symbol 에러가 떴었고 [https://stackoverflow.com/questions/34591254/how-to-build-dlib-for-ios](https://stackoverflow.com/questions/34591254/how-to-build-dlib-for-ios) 에 따라서 해보니 에러가 사라지고 빌드는 됨!(arm64로 해줘야함)

**4. dat 파일과 이미지 파일을 c++에서 찾아야 하는데 찾지 못하는 에러 발생**

- xcode 내에 있는 .dat 파일을 찾지 못한다
- phone 내에 있는 내 사진을 찾지 못한다

→ Dlib 예시는 상대경로를 이용하는 것으로 보였지만 아래처럼 url을 친히 다 만들어주니 된다

```swift
NSURL *datUrl = [[NSBundle mainBundle] URLForResource:@"shape_predictor_5_face_landmarks" withExtension:@".dat"];
        NSLog(@"shape 주소: %@", datUrl.path);
        if (datUrl.path)    {
            char const *pPath = [datUrl.path cStringUsingEncoding:NSASCIIStringEncoding];
            if (pPath) {
                deserialize(pPath) >> sp;
            }
        }
```

1. face feature extract 코드
    1. [https://github.com/zweigraf/face-landmarking-ios/tree/master/DisplayLiveSamples](https://github.com/zweigraf/face-landmarking-ios/tree/master/DisplayLiveSamples) 링크 참고해서 만듦
2. mapper train 코드
    1. [https://github.com/Pororo-droid/binary-mapper/blob/master/binary_mapper.cpp](https://github.com/Pororo-droid/binary-mapper/blob/master/binary_mapper.cpp) 진우님 코드 참고
3. 단점 발생
- 시간이 오래걸림 15초정도 소요

---

참고

### Dlib 링킹 시 연결안될때 시도해볼 만한 방법

- search Path나 framework path path를 건들여본다
    - **Header Search Path**는 컴파일러가 헤더 파일(즉, 클래스 구현에서 포함하는 ".h" 파일)을 찾는 곳입니다.
    - **Library Search Path**는 링커가 컴파일 및 링크되는 코드 내에서 참조되는 컴파일된 개체 파일(또는 해당 컴파일된 개체 파일이 포함된 아카이브 파일)을 찾는 위치입니다. 라이브러리 파일 찾는 곳
- dlib에서 path에 dlib을 직접적으로 지정해주면 넣지 마라고 에러뜨므로 이를 유의해서 상위 폴더로 path 세팅할 것