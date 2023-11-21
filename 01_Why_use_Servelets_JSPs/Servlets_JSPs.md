# 학습목표
## GET, POST, HEAD와 같은 HTTP 메소드에 대해
* HTTP 메소드의 장점을 설명하세요.
* HTTP 메소드의 기능을 설명하세요.
* 각각의 메소드를 사용할 경우 클라이언트에서 일어나는 일을 순서대로 열거할 수 있어야 한다.

## 웹 서버
### 웹서버는 어떤 일을 하나요?
#### 웹 서버는 클라이언트로부터 요청을 받아, 요청한 것을 넘겨주는 일을 한다.
사용자가 웹 브라우저로 서버에 있는 자원(resource)을 요청하는 것에서부터 시작한다. 요청은 웹 서버로 전달되고, 서버는 사용자가 요청한 것을 넘겨주는 것으로 작업이 완료된다.

그런데 요청한 것이 서버에 없다면? 또는 있다고 해도 주소가 틀려 서버가 찾지 못한다면 "404 Not Found" 오류 메시지가 뜬다. 이 메시지는 "요청한 자료를 서버에서 찾을 수 없습니다."를 의미한다.

### 클라이언트는 어떤 일을 하나?
#### 웹 클라이언트는 사용자가 서버에 요청을 보낼 수 있는 기능을 제공한다. 요청을 보내고 난 다음, 서버가 보낸 요청의 결과를 화면에 출력하는 일도 한다.
클라이언트라는 용어는 사용자 또는 브라우저라는 응용프로그램을 의미한다. 브라우저의 주된 역할은 HTML 코드를 읽어서(파싱) 화면에 보이게 하는 것이다.

### HTTP프로토콜 넌 누구냐
HTTP는 TCP/IP를 기반으로 하여, TCP/IP를 이용해서 한 지점에서 다른 지점으로 요청과 응답을 전송한다.
HTTP는 요청과 응답의 끊임없는 주고 받는 구조이다.
클라이언트는 요청하고 서버는 여기에 응답한다.
* 요청의 주요 구성요소
    - HTTP 메소드(실행할 액션)
    - 접근하고자 하는 페이지(URL)
    - 폼 파라미터(메소드의 매개변수와 비슷한 것)
* 응답의 주요 구성요소
    - 상태 코드(요청이 성공했는지)
    - 컨텐츠 타입(텍스트, 그림, HTML 등)
    - 컨텐츠(HTML 코드, 이미지 등)

### HTML은 사실 HTTP 응답의 일부분이다.
HTTP 응답 안에 HTML이 들어있다. HTTP 응답에는 HTML 뿐만 아니라, 헤더 정보도 들어있다.
브라우저는 헤더 정보로 컨텐츠를 어떻게 화면에 보여줄지에 대한 힌트를 얻는다.

### 내가 서버라면 요청에 들어있는 정보 중 어떤 것이 궁금할까요?
HTTP메소드로 가장 많이 사용되는 것은 GET과 POST이다.
- GET: asking the server to GET the page
- POST: giving the server what the user typed into the form

### 단순한 요청은 GET, 사용자 데이터를 보내려면 POST
GET의 핵심은 서버로부터 뭔가를 돌려 받는다(get back).
POST는 무언가를 request할 수 있고 동시에 데이터를 서버로 send할 수 있다.

### HTTP GET도 적은 데이터를 보낼 수 있다.
GET 대신 POST를 새용해야 하는 이유
1. GET으로 보낼 수 있는 글자의 수는 제한되어 있다.
2. GET의 데이터 전송 방식은 URL 주소 뒤에 붙이므로 어떤 정보든 다 노출이 된다.
3. 위의 두 가지 이유로, 사용자는 GET으로 전송하는 URL은 즐겨찾기에 등록할 수 있지만, POST는 대부분 그렇지 못한다.

### GET 해부하기
자원에 대한 경로, URL에 붙는 파라미터들은 request line에 포함된다.
```http
GET /select/selectBeerTaste.jsp?color=dark&tast=malty HTTP/1.1
Host: www.wickedlysmart.com
.
.
.
```
GET /select/selectBeerTaste.jsp?color=dark&tast=malty HTTP/1.1: 요청 라인
GET: HTTP 메소드
/select/selectBeerTaste.jsp: 웹 서버 상 자원에 대한 경로
?color=dark&tast=malty: 파라미터는 ?문자로 시작하며, request URL 첫 번째 부분에 위치한다.
HTTP/1.1: 웹 브라우저가 요구하는 프로토콜 버전
Host: www.wickedlysmart.com...: request header

### POST 해부하기
HTTP POST 요청은 브라우저가 서버에 복잡한 요청을 할 수 있게 하기 위해 설계되었다.
서버로 보내는 데이터를 message body(메시지 몸체) 또는 payload(짐)라고 부른다.
```http
POST /advisor/selectBeerTaste.do HTTP/1.1
Host: www.wickedlysmart.com
.
.
.
color=dark&tast=malty
```
color=dark&tast=malty: message body(payload)
파라미터가 밑에 있기 때문에 길이의 제한이 없다. (GET은 파라미터를 Request line에 두어야 하므로 길이 제한이 있다.)

### HTTP응답 해부하기, 그리고 MIME type란 무엇인가?
