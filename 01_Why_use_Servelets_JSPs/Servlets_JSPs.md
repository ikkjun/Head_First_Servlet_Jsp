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
지금까지 배운 것: 브라우저에서 서버로 보내는 요청(request)
지금부터 배울 것: 서버에서 응답(response)을 보내는 것
HTTP response에는 header와 body가 있다.
header 정보는 사용한 프로토콜에 대한 정보, 요청이 성공적이었는지, 그리고 body안에 어떤 종류의 정보가 들어있는지 알려준다.
body는 브라우저가 화면에 보여줄 HTML과 같은 내용을 포함하고 있다.

### 한 페이지로 다 보기
1. 사용자가 URL을 입력
2. 브라우저가 HTTP GET request를 만든다.
3. HTTP GET이 서버로 보내진다.
4. 서버는 요청한 페이지를 찾는다.
5. HTTP response를 보낸다.
6. HTTP response는 브라우저로 보내진다.
7. 브라우저는 HTML을 보여준다.
8. 클라이언트는 화면을 본다.

### <span style="color:red">URL</span>
URL: Uniform Resource Locators
웹 상에서 모든 자원들은 고유한 주소를 URL형태로 가지고 있다.

http://www.wickedlysmart.com:80/beeradvice/select/beer1.html

- http://: Protocol: 서버에게 어떤 communications protocal이 사용될지 알려준다.(여기서는 http)
- www.wickedlysmart.com: server: 질제 서버의 유일한 이름. 이 이름은 유일한 IP address와 대응된다. IP주소는 숫자로 구성되며 "xxx.yyy.zzz.aaa"의 형태를 갖는다. 그러나 서버 이름이 더 기억하기 쉽다.
- 80: Port: 이 부분은 선택적이다. 하나의 서버는 많은 ports를 가지고 있다. port를 명시하지 않으면 기본값인 80이 들어간다. 0~1023은 잘 알려진 서비스들을 위해 예약되어 있으므로 이 범위의 port는 사용하지 말자!ㄴ
- beeradvice/select: Path: 서버 상에서 요청되는 자원의 위치에 대한 경로
- beer1.html: 요청되는 content의 이름. HTML page, sevlet, image, PDF, music, video 등이 들어갈 수 있다. 이 optional 부분이 없다면 기본값으로 index.html을 넘겨준다.

### 웹 서버는 정적인 웹 페이지를 serve한다.
정적인 페이지는 diretory안에 있는다. 서버는 정적인 페이지를 찾아서 client에게 그대로 제공한다. 

### 하지만 웹 서버 그 이상을 원하는 순간이 있다.
web server application은 페이지를 serve한다. 
하지만 서버상의 다른 application은 동적으로 변하는 값을 제공할 수 있다.

### 웹 서버 혼자서 할 수 없는 두 가지
#### 1. Dynamic content
web server applicaion은 동적인 페이지만 제공하지만, 분리된 helper application은 동적인 just-in-time page를 만들 수 있다.

#### 2. Saving data on the server
user가 뎅터를 제공한다면 웹 서버는 helper application에게 도움을 요청하면 웹 서버는 파라미터를 helper app에게 넘겨주고 client에게 response를 생성하라고 한다.

### web server helper app을 CGI program이라고 한다.
1. 사용자는 정적인 페이지가 아닌 CGI proram URL을 클릭한다.
2. 웹 서버는 request가 helper app을 위한 것임을 보고 웹 서버는 helper app 실행
3. helper app은 새로운 페이지를 구성하고 HTML을 서버로 다시 보낸다. 서버가 helper app으로부터 받은 HTML은 정적인 페이지이다.
4. helper application이 종료되고, client은 HTML 페이지를 돌려받게 된다.

## 핵심 정리
* HTTP는 하이퍼텍스트 전송 프로토콜(HyperText Transfer Protocol)의 약자이다. HTTP는 웹에서 사용하는 네트워크 프로토콜이며 TCP/IP 위에서 돌아간다.
* HTTP는 request / response 모델을 사용한다. 즉 client는 HTTP request를 만들고 web server는 HTTP response를 돌려보낸다. 
* 서버로부터 온 response가 HTML page라면 HTML page는 HTTP response에 첨부된다.
* HTTP request는 request URL, HTTP method, form parameter data가 있다.
* HTTP response는 status code, content-type(MIME), response의 실제 content가 들어있다.
* GET request는 form data를 URL의 끝에 추가한다.
* POST request는 form data를 request의 body에 포함시킨다.
* MIME type은 browser에게 어떤 종류의 데이터를 browser가 받을 것인지 알려준다.
* 