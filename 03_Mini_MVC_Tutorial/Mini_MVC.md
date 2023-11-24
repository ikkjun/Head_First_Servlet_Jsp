# 초 간단 미니 MVC 튜토리얼
## 학습목표와 주요내용
### 애플리케이션 배포
1. 다음을 포함하는 웹 어플리케이션 디렉토리 구조를 만들 수 있어야 한다. (a) 정적인 컨텐츠 (b) JSP 페이지 (c) servlet class (d) Deploy Descriptor(DD, 배포 서술자) (e) 태그 라이브러리 (f) JAR 파일 (g) 자바 클래스 파일
2. 다음 배포 서술자 항목의 용도 및 문법을 설명할 수 있어야 한다.
3. 다음 배포 서술자 항목을 정확한 구조로 만들 수 있어야 한다.
  * error-page
  * init-param
  * mime-mapping
  * servlet
  * servlet-class
  * servlet-name
  * welcome-file

## 실제 웹 애플리케이션 빌드 순서
1. 사용자 화면(브라우저가 화면에 어떤 내용을 보여줄 것인가)을 검토하고 이는 고차원적인 구조화 작업이다.
  1. 클라이언트가 form.html을 요청
  2. 요청을 받은 컨테이너가 form.html을 파일시스템에서 읽어온다.
  3. form.html을 브라우저로 넘겨준다. 화면을 보고 사용자가 자산의 취향을 입력한다.
  4. 사용자가 선택한 정보를 컨테이너로 보낸다.
  5. 컨테이너는 URL을 분석하여 담당 서블릿을 찾아 요청을 넘긴다.
2. 이번 프로젝트에서 사용할 개발 환경(development environment) 만들기
3. 배포 환경(deployment environment) 만들기
4. 다양한 component에 대해 반복적인 개발과 테스트 하기
