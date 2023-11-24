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
  6. servlet은 클래스를 찾아 request를 넘긴다.
  7. servlet이 클래스가 넘겨준 정답을 request 객체에 넣는다.
  8. JSP에 이 request를 JSP에 forward한다.
  9. JSP는 request 객체로부터 정답을 얻는다. 
  10. JSP는 container를 위해 HTML 페이지를 작성한다.
  11. container는 이 페이지를 user에게 넘겨준다.
2. 이번 프로젝트에서 사용할 개발 환경(development environment) 만들기
  * web app을 배포할 때는 개발환경 디렉토리의 일부를 Container가 지정하는 곳에 복사한다.  
  1. etc 폴더: 환경 설정 파일(DD)
  2. lib: 3rd party JAR files
  3. src: Java 코드는 src 디렉토리 내에 있다.
  4. src/com/example/web, model/: model component로부터 controller component를 분리했다.
  5. web: 정적이고 동적인 component가 들어간다.
3. 배포 환경(deployment environment) 만들기
  1. Beer-v1: web app의 이름. 톰캣이 URL을 분석할 때 사용하는 context root라고 한다.
  2. Beer-v1/WEB-INF: web.xml 파일은 반드시 WEB-INF 디렉토리 아래에 있어야 한다.
  3. Beer-v1/WEB-INF/classes/com: development environment에서 사용한 package structure와 완전히 동일
4. 다양한 component에 대해 반복적인 개발과 테스트 하기
  1. 
