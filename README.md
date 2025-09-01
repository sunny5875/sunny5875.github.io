
# 노션 -> 깃헙 블로그 올리는 방법

### 1️⃣ 노션에 블로그 작성

### 2️⃣ 실행 권한 부여
- 스크립트를 처음 사용할 때는 실행 권한을 부여합니다.
```
chmod +x notion_to_github_pages.sh
```
### 3️⃣ Notion ZIP 파일 준비
- Notion에서 Markdown + CSV 형식으로 Export

생성된 ZIP 파일을 레포지토리 루트에 위치

예: Exported-Portfolio.zip

스크립트에서 exported_zip_reg="*.zip"로 지정되어 있으므로, .zip 파일이면 자동 감지됩니다.

### 4️⃣ 스크립트 실행
```
./notion_to_github_pages.sh
```

#### 실행 과정:
ZIP 파일 자동 압축 해제 -> Markdown 파일 메타데이터 생성 -> 이미지 경로 수정 -> _posts와 assets 폴더로 이동 -> Git add + commit -> ZIP 및 임시 폴더 삭제 -> 실행 중에 title, category 입력을 요구할 수 있습니다.

### 5️⃣ GitHub에 commit 후 Push

```
git commit -m "메세지"
git push origin
```

---
## ⚠️ 주의 사항

- 파일/폴더 이름에 공백이나 특수문자가 있으면 %20 처리됨
- macOS BSD sed 전용(sed -i '') → Linux 환경에서는 sed -i로 변경 필요
- ZIP 파일 이름 규칙(*.zip) 확인
- _posts와 assets 폴더 존재 여부 확인
- GitHub Pages 브랜치 설정 확인(main 또는 gh-pages)
