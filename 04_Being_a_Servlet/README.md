# 서블릿이 되어 보자
## 학습목표와 주요 내용
1. GET, POST, HEAD와 같은 HTTP 메소드에 대해 메소드의 목적과 HTTP 메서드 프로토콜의 기술적인 특징을 설명할 수 있어야 한다.
   client가 메서드를 이용하려고 할 때 발생하는 작업들이 무엇인지 나열할 수 있어야 한다. 
   그리고 HTTP 메서드에 대응하는 HttpServlet 메서드를 설명할 수 있어야 한다.
2. HttpServletRequest 인터페이스로 HTML폼, HTTP request header 정보, request로부터 cookies 정보를 읽어올 수 있어야 한다.
3. HttpServletResponse 인터페이스로 HTTP Resonse 헤더를 설정하는 법, Response에 컨텐츠 타입을 설정하는 법, 텍스트 스틂 또는 바이트 스트림을 얻는 법, HTTP Request를 다른 URL로 전송 방향을 돌리는(redirect) 법, response에 cookies를 설정하는 법 등을 작성할 수 있어야 한다.
4. servlet 생명주기의 목적과 이벤트 생성주기에 대해 설명할 수 있어야 한다.  
    (1) servlet class loading  
    (2) servlet instantiation  
    (3) call the init()  
    (4) call the serice() method  
    (5) call the destroy() method  

## 서블릿의 요청과 응답
### 컨테이너가 servlet을 관리하는 과정
1. 사용자가 서블릿에 대한 링크(URL)를 클릭한다.
2. 컨테이너는 요청된 request가 servlet이라는 것을 알고 다음 두 개의 객체를 생성한다.  
   (1) HttpServletResponse  
   (2) HttpServletRequest  
3. 접수한 요청의 URL을 분석하여 어떤 서블릿을 요청했는지 파악한다(여기서 DD를 참조한다). 그 다음 해당 서블릿 스레드를 생성하여 request, response 객체 참조를 넘긴다.
4. 컨테이너는 서블릿 service() 메소드를 호출한다. 브라우저에서 지정한 방식에 따라 doGet()을 호출할지 doPost()를 호출할지 결정한다. 클라이언트가 HTTP GET 메소드를 날렸다면 service() 메소드는 서블릿의 doGet() 메소드를 호출한다. 호출할 때 Request와 Response 객체를 인자로 넘긴다. 
5. servlet은 클라이언트에게 응답을 작성하기 위하여 response 객체를 사용한다. 이 작업을 완료하면, response에 대한 제어는 컨테이너에게 넘어간다. 
6. service() 메소드가 끝나면, 스레드를 소멸하거나 컨테이너가 관리하는 스레드 풀로 돌려 보낸다. 그 다음 request와 response 객체는 가비지 컬렉션이 될 준비를 하며, 이 객체에 대한 참조는 범위를 벗어나기 때문에 사라진다.  
마지막으로 클라이언트는 서버로부터 응답을 받게 된다.

## **servlet의 lifecycle**
servlet의 lifecycle은 단순하다. servlet은 초기화라는 오직 하나의 중요한 상태를 가진다.<br>
서블릿이 초기화되지 않았다는 말은 초기화 되는 중(생성자를 실행하거나 init() 메소드를 실행하거나)이거나, 소멸되는 중(destory() 메소드를 실행)이거나 존재하지 않은 것 중 하나이다.
1. Load class
2. Instantiate servlet(생성자 실행)
3. init(): servlet의 life에서 오직 한 번만 호출되고 Container가 service()를 호출하기 전에 완료되어야 한다.
4. service(): servlet이 가장 많은 시간을 보내는 곳이다. doGet(), doPost()와 같은 client의 request를 다룬다. 각각의 request는 독립된 thread에서 수행된다.
5. destroy(): Container가 servlet에게 servlet을 종료하기 전 정리할 기회를 마지막으로 단 한 번 준다.

### 서블릿 API
Servlet interface(javax.servlet.Servlet)<br>
**service(ServletRequest, ServletResponse)**<br>
**init(ServletConfig)**<br>
**destory()** &#8594; 생명주기 메소드<br>
getServletConfig()<br>
getServletInfo()<br>
<hr>

GenericServlet 클래스(javax.servlet.GenericServlet)<br> 
**service(ServletRequest, ServletResponse)**<br>
**init(ServletConfig)**<br>
init()<br>
**destory()**<br>
getSevletConfig()<br>
getServletInfo()<br>
getIniParameter(String)<br>
geInitParameterNames()<br>
geServletContext()<br>
log(String)<br>
log(String, Throwable)<br>
추상 클래스이다. 필요한 대부분의 서블릿 메소드를 구현햇다.<br>
대부분 서블릿의 서블랫 행위라고 하는 것들이 이 클래스로부터 나왔다.<br>
servlet 클래스는 javax.servlet 또는 javax.servlet.http 둘 중 하나의 패키지에 속한다.<br/>
GenericServlet 클래스는 servlet 인터페이스를 구현한다.<br/>
<hr>

HttpServlet 클래스(javax.servlet.http.HttpServlet) 
**service(HttpServletRequest, HttpServletResponse)**<br>
service(ServletRequest, ServletResponse)<br>
doGet(HttpServletRequest, HttpServletResponse)<br>
doPost(HttpServletRequest, HttpServletResponse)<br>
doOption(HttpServletRequest, HttpServletResponse)<br>
doPut(HttpServletRequest, HttpServletResponse)<br>
doTrace(HttpServletRequest, HttpServletResponse)<br>
doDelete(HttpServletRequest, HttpServletResponse)<br>
getLastModified(HttpServletRequest, HttpServletResponse)<br>
(추상 클래스) HttpServlet는 servlet의 HTTP적인 측면을 반영하기 위해 service()를 재정의한다.<br>
이는 service() 메소드가 오래된 servlet의 request와 response를 받지 않고, HTTP request와 response만 받는다는 의미이다. <br/>
대부분 기본적인 servlet 메소드가 이미 구현된 추상 클래스인 javax.servlet.GenericServlet을 상속 받는다.
<hr>
MyServlet 클래스  
작성할 서블릿의 대부분 행위는 상위 클래스의 메소드를 상속받음으로써 해결된다. 그러므로 HTTP 메소드를 재정의 하는 일만 하면 된다.

### 3번의 중요한 순간
||호출되는 시점|목적|override 여부|
|---|---|---|---|
|init()|컨테이너는 servlet 인스턴스를 생성한 다음 init() 메소드를 호출한다. 이 메소드는 service 메소드 전에 실행되어야 한다.|클라이언트의 요청을 처리하기 전에 서블릿을 초기화 할 기회를 주는 것이다.|override 가능. 초기화 할 코드가 있으면 init() 메서드를 override 해야 한다. override하지 않으면 GenericServlet()의 init()이 실행된다.|
|service()|최초 클라이언트의 요청을 받았을 때, 컨테이너는 새로운 스레드를 생성하거나 스레드 풀로부터 하나를 가지고 와서 servlet의 service() 메소드를 호출한다.|클라이언트의 HTTP 메소드를 참조하여 doGet()을 호출할지 doPost()를 호출할지 아니면 다른 메소드를 호출할지 판단한다.|override 할 필요는 없다. doPost()나 doGet()을 override하여 HttpServlet의 service()가 이를 실행하도록 하면 된다.|
|doGet() 또는 doPost()|service() 메소드가 클라이언트의 HTTP 메소드(GET, POST 등)를 참조하여 doGet() 또는 doPost()를 호출한다.|코드가 시작하는 부분이다. web app이 작업을 시작하는 곳이다. 다른 객체에서 다른 메서드를 호출할 수 있지만, 여기에서 시작한다.|doGet()이나 doPost() 중 반드시 하나 이상이 있어야 한다. override할 것 중에 어떤 것이든 컨테이너에게 말해야 한다. doPost()를 override하지 않을 것이라면 이 servlet은 HTTP POST request를 지원하지 않는 것이라고 말하는 중이다.|

## servlet threads
* servlet initialization
   * Thread A
      * Container는 servlet이 어떤 client request를 수행하기 전에 servlet instance를 생성한 다음 servlet instance 위에 init() 메소드를 호출한다. 
      * 초기화 코드가 있다면 servlet class에서 init() 메서드를 override해야 한다. 그렇지 않으면 GenericServlet의 init() 메서드가 실행된다.
   * Thread B(client reqeust 1)
      * 첫 번째 client request이 들어올 때, Container는 thread를 실행하고 servlet의 service() 메서드를 호출한다.
      * service() 메소드가 완료되는 시점이 스레드가 종료되는 시점이다.
   * Thread C(client request 2)
      * 두 번째 client request가 들어올 때, Container는 thread를 생성하거나 다른 thread를 찾아서 servlet의 service() 메서드를 호출한다.
      * client request가 있을 때마다 service() &#8594; doGet() 메서드 순서로 호출된다. 
* Container는 하나의 servlet에 대한 다수의 request를 처리하기 위해 다수의 thread를 실행하지 다수의 인스턴스를 만들지 않는다.
   * servlet initialization
      - servlet의 일생은 Container가 servlet class 파일을 찾을 때 시작한다. 
      - Container가 시작하면, Container는 배포된 web app을 찾고 servlet class 파일을 찾는다. 
         (1) class 찾기
         (2) class 로딩하기. 이는 Container가 시작하거나 client가 처음 이용할 때 일어난다. 
      - Container가 client가 처음 필요로 할 때, servlet을 일찍 준비하든가 실행 시에 로딩하든 상관없이 servlet이 완전히 초기화 되기 전까지 servlet의 service() 메서드를 실행되지 않을 것이다. 

## servlet initialization
servlet은 Container가 servlet class file을 찾을 때 시작한다. 이는 Container가 시작할 때 일어난다.  
Container가 시작하면 배포된 web app을 찾은 다음, servlet class file을 찾기 시작한다.  
class를 찾는 것이 첫 번째 단계이다. class를 로딩하는 것이 두 번째 단계이다. 이 작업은 Container가 시작하거나 첫 번째 client가 사용하려고 할 때 일어난다.  
첫 번째 client가 필요로 할 때 Container가 미리 servlet을 준비시키거나 실행 시(Just in time)에 작동시키는지에 상관없이 servlet의 service() 메소드는 servlet이 완전히 초기화되기 전까지 실행되지 않는다.  
init()은 항상 service()에 대한 첫 번째 호출이 있기 전에 완료한다.

servlet은 생성자가 시작하면서 does not exist에서 initialized로 전환된다.  
하지만 생성자는 객체만 만들지 servlet을 만들지 않는다. 
servlet이 되려면 객체는 servletness를 받아야 한다.
객체가 servlet이 되면 servlet이 되므로써 고유한 이점을 얻게 된다. 

## servlet 객체의 종류
1. ServletConfig 객체
   * servlet당 한 개의 ServletConfig 객체
   * 배포 시 설정된 정보를 전달해주기 위해 사용한다.
   * ServletContext에 접근하기 위해 사용한다.
   * 파라미터는 DD에서 설정할 수 있다. 
2. ServletContext
   * web app당 ServletContext 1개
   * web 파라미터에 접근하기 위해 사용
   * 다른 부분의 application이 접근할 수 있는 application 게시판처럼 사용한다. 
   * server 정보를 얻기 위해 사용한다. 
3. ServletConfig과 ServletContext의 차이점
   * ServletConfig
      - config는 설정(configuration)이라는 의미이다. servlet을 배포할 때 설정한 값이다. 
      - ServletConfig의 파라미터는 servlet이 배포되고 실행되는 동안 바뀌지 않는다. 바꾸려면 servlet을 다시 배포해야 한다.
   * ServletContext
      - servlet 당 하나가 아니라, web app 당 하나의 ServletContext만 존재한다. 

## servlet의 임무
servlet은 client request를 다루기 위해 존재한다.

## Request와 Response
|**ServletRequest interface (javax.servlet.ServletRequest)**|**ServletResponse interface (javax.servlet.ServletResponse)**|
|:---------------------------------------------------------:|:-----------------------------------------------------------:|
|getAttribute(String) <br> getContentLength() <br> getIntputStrean() <br> getLocalPort() <br> getParameter() <br> getParameterNames()|getBufferSize() <br> setContentType() <br> getOutputStream() <br> geWriter() <br> setContentType()|
|<center>&uarr;</center>|<center>&uarr;</center>|
|**Http ServletRequest interface (javax.servlet.http.HttpServletRequest)**|**HttpServletResponse interface (javax.servlet.http.HttpServletResponse)**|
|getContextPath() <br> getCookies() <br> getHeader(String) <br> getQueryString() <br> getSession() <br> getMethod()|addCookie() <br> addHeader() <br> encodeRedirectURL() <br> sendError <br> setStatus()|
|HttpServletRequest 메소드는 cookies, header, session과 같은 HTTP에 관련된 것들을 서비스한다.|HttpServletResponse는 HTTP를 사용할 때 신경써야 하는 error, cookie, header에 대한 메소드들이 추가되어 있다.|

### HttpServletRequest와 HttpServletResponse는 인터페이스인데 누가 이를 구현할까? API에 구현된 클래스가 있나?
컨테이너가 구현하고 API에 구현된 클래스는 없다. API에 없는데 그 이뉴는 컨테이너 벤더가 구현하기 때문이다.

## HTTP 메소드의 종류
* GET: 요청된 URL로부터 자원이나 파일을 get한다고 요청한다.
* POST: server에게 request에 첨부된 body info를 받아들이라고 요구하고, 요청된 URL에 body info를 넘겨준다.
* HEAD: GET이 무엇을 반환하든지 오직 header 부분만 요청한다. 그래서 HEAD는 response에 body가 없는 GET과 같다.
* TRACE: request message에 loopback을 요청해서, 테스트 또는 troubleshooting(문제 해결)을 위해 client가 다른 쪽에서 무엇을 받았는지 볼 수 있다.
* OPTION: 요청한 URL이 응답할 수 있는 HTTP 메소드의 목록을 요청한다.
* PUT: 요청한 URL에서 동봉한 body info를 put한다.
* DELETE: 요청한 URL에서 자원이나 파일을 delete한다.
* CONNECT: 터널링의 목적으로 connect를 요청한다.
HttpServlet과 관련되지 않은 CONNECT를 제외하고 HttpServlet 클래스의 doXXX() 메소드와 연결된다.

### GET과 POST의 차이점
1. size
   * POST에는 body가 있다. GET은 Request line에 보낼 수 있는 파라미터 데이터의 양이 제한되어 있다.
2. security
   * GET을 사용하면 브라우저의 input bar(주소 입력 창)에 파라미터 데이터가 노출되면서 보안에 취약하다는 단점이 있다.
3. bookmarking
   * GET request는 그대로 즐겨찾기에 추가되지만, POST request는 그렇지 않다. user가 검색 조건을 명시하고 검색했을 때, server에 새로운 데이터가 있기 때문에 일주일 뒤에 돌아와도 이전의 데이터를 보여준다.
4. supposed to be used(사용 목적)
   * GET은 어떤 것을 단순히 가져올 때 사용한다. 이것은 server에 어떠한 변화를 가져오지 않는다.
   * POST는 처리할 데이터를 보내기 위해 사용한다. POST를 생각할 때 생각해내야 하는 단어는 update이다. 이는 server상의 어떤 것을 바꾸기 위해 POST의 body로부터 데이터를 사용한다는 것이다.
5. Idempotent(멱등) 여부: 
   - HTTP / servlet 환경에서 동일 request는 server에 어떤 부작용을 야기하지 않고 두 번 이상 이루어질 수 있다는 의미이다. 
   - idempotent는 동일한 request가 항상 동일한 response를 반환하는 것은 아니며, request가 어떤 부작용도 발생하지 않아야 한다는 것을 의미하지 않는다. 
   - GET, HEAD, PUT은 멱등이다.
   - POST는 멱등이 아니다.

#### idempotent requests
HTTP GET은 어떤 것을 가져오는 것이지 server에 대해 어떤 것을 바꾸는 것이 아니다. 그래서 GET은 정의상 idempotent이다.<br/>
그러나 POST는 idempotent가 아니다. POST의 body에서 제출된 데이터가 transaction으로 향한다면 그것은 되돌릴 수 없다. 그래서 doPost()를 구현할 때는 주의해야 한다. POST메소드가 한 번 이상 들어오는 경우 web app logic이 이러한 상황을 제대로 처리할 수 있도록 만들어야 한다.

### forms and HTTP
form에 method="POST"를 입력하지 않으면 초기값은 HTTP GET request이다. 이는 browser가 파라미터를 request header안에 넣어서 보낸다는 것이다. request가 GET으로 오면 폼 처리에 있어서 대부분 doPost()만 만들어 놓기 때문에 문제가 발생한다.

#### 서블릿에서 doGet()과 doPost()를 다 지원하도록 만드는 방법
doGet()을 구현하고 doPost()는 요청을 doGet()으로 넘긴다.
```java
public void doPost(...) throws ... {
   doGet(request, response);
}
```

#### 파라미터 1개 전송 및 사용하기
**HTML form**
```html
<form action="SelectBeer.do" method="post">
   <p>Select beer characteristics</p>
   <select name="color" size="1">
   <option value="light">light</option>
   <option value="amber">amber</option>
   <option value="brown">brown</option>
   <option value="dark">dark</option>
   </select>
   <center>
   <input type="submit">
   </center>
</form>
```
**HTTP POST request**
POST ...
color=dark

**servlet class**
```java
public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
   String colorParam = request.getParameter("color");
   // colorParam 문자 변수에는 dark라는 값이 들어 있다.
}
```

#### 파라미터 2개 전송하기
**HTML form**
```html
<form action="SelectBeer.do" method="post">
   <p>Select beer characteristics</p>
   COLOR:
   <select name="color" size="1">
      <option value="light">light</option>
      <option value="amber">amber</option>
      <option value="brown">brown</option>
      <option value="dark">dark</option>
   </select>
   BODY:
   <select name="body" size="1">
      <option>light</option>
      <option>medium</option>
      <option>heavy</option>
   </select>
   <center>
   <input type="submit">
   </center>
</form>
```
**HTTP POST request**
POST ...
color=dark&body=heavy

**servlet class**
```java
public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
   String colorParam = request.getParameter("color");
   String bodyParam = request.getParameter("body");
   // colorParam 변수에는 dark가, bodyParam 변수에는 heavy가 들어 있다.
}
```

#### parameter 하나가 여려 개의 값을 가질 때 읽는 방법
getParameter()로 String을 반환받는 대신, array를 반환하는 getParameterValues()를 사용해야 한다.
```java
String one = request.getParameterValues("sizes")[0];
String [] sizes = request.getParmeterValues("sizes");

// 사용자가 선택한 값들이 무엇인지 일일이 확인하고 싶은 경우
String [] sizes = request.getParameterValues("sizes");
for(int x=0;x<sizes.length; x++) {
   out.println("<br>sizes: " + sizes[x])
}
```

## HttpServletRequest 객체
### request 객체로부터 얻을 수 있는 것
1. 클라이언트 플랫폼 정보 및 브라우저 정보
   ```java
   String client = request.getHeader("User-Agent");
   ```
2. request에 관련된 쿠키
   ```java
   Cookie[] cookies = request.getCookies();
   ```
3. 클라이언트의 세션 정보
   ```java
   HttpSession session = request.getSession();
   ```
4. request의 HTTP 메소드
   ```java
   String theMethod = request.getMethod();
   ```
5. request의 입력 스트림
   ```java
   InputStream input = request.getInputStream();
   ```

## HttpServletResponse 객체
response는 client에게 돌려보내는 것이다. 일반적으로 출력 스트림(보통 Writer)을 사용하여 client에게 돌아갈 HTML을 작성한다. response 객체는 I/O 출력 외에도 다른 메소드를 가지고 있다. 

대부분 client에 데이터를 전송하기 위해 response 객체를 사용한다. response을 하기 위해 serContentType()와 getWriter() 두 개의 메서드를 호출한다. 그 후에 스트림에 HTML을 쓰기 위해 I/O작업을 한다. 이 외에도 헤더 정보를 설정하거나 오류를 보내고 쿠키를 추가할 때 response를 사용한다.

### JAR 파일을 client에게 보내기
JAR 파일로부터 client가 코드를 얻을 수 있는 다운로드 페이지를 만들었다고 가정하자. response는 HTML 페이지 대신, JAR을 표현하는 bytes를 포함하고 있어야 한다. 먼저 JAR 파일의 bytes를 읽은 다음 response의 출력 스트림에 작성한다.

1. JAR 코드 파일을 다운 받는 링크는 Code.do라는 이름의 servlet을 실행하는 것이다.
2. 브라우저는 Code.do라는 요청된 serlvet에 대한 HTTP request를 서버로 보낸다.
3. Container는 처리를 위해 request를 CodeReturn servlet으로 보낸다.
4. CodeReturn servlet은 Jar 바이트를 읽어와서 response로부터 출력 스트림을 받고, 출력 스트림에 JAR을 표현하는 바이트를 작성한다.
5. HTTP response는 이제 JAR을 표현하는 바이트가 들어있다.
6. JAR은 client의 기계에 다운로드가 시작된다.

### JAR을 내려받는 servlet 코드
```java
public class CodeReturn extends HttpServlet {
   public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
      response.setContentType("application/jar");  // 브라우저가 HTML이 아니라 JAR임을 인지하기 위해 content type를 application/jar로 설정한다.

      ServletContext ctx = getServletContext();
      InputStream is = ctx.getResourceAsStream("/bookCode.jar");  // bookCode.jar이라는 자원을 input stream으로 주세요
      // getResourceAsStream()의 인자값으로 들어오는 파일경로는 반드시 web app의 루트를 의미하는 /로 시작해야 한다. 

      int read = 0;
      byte[] bytes = new byte[1024];

      // JAR 바이트를 읽은 뒤, response 객체로부터 얻은 output stream에 byte를 기록하는 것이다.
      OutputStream os = response.getOutputStream();
      while ((read = is.read(bytes)) != -1) {
         os.write(bytes, 0, read);
      }
      os.flush();
      os.close();
   }
}
```

### content type
content type은 MIME type를 의미한다. content type는 HTTP response 내에 반드시 포함되어야 하는 HTTP header이다. 프로그램이 정상적으로 작동하기 위해서 output stream을 주는 메소드(getWriter() 또는 getOutputStream())를 호출하기 전에 항상 serContentType()를 제일 먼저 호출해야 한다. 

#### 일반적인 MIME 타입
* text/html
* application/pdf
* video/quicktime
* application/java
* image/jpeg
* application/jar
* applicaton/octet-stream
* application/x-zip

### PrintWriter와 OutputStream
* PrintWriter
   * 예제
   ```java
   PrintWriter writer = response.getWriter();
   writer.println("some text and HTML");
   ```
   * 용도<br/>
   텍스트 데이터를 chatacter stream으로 출력한다. 
* OutputStream
   * 예제
   ```java
   ServletOutputStream out = response.getOutputStream();
   out.write(aByteArray);
   ```
   * 용도<br/>
   아무거나

### setHeader와 addHeader의 차이점
```java
response.setHeader("foo", "bar");
response.addHeader("foo", "bar");
```
setHeader()와 addHeader() 둘 다 response에 header(첫 번째 인자)와 value(두 번째 인자)를 추가할 수 있다. setHeader()는 이미 존재하는 값을 덮어 쓴다. addHeader()는 값을 하나 더 추가한다.

## request redirect
request를 완전히 다른 URL로 redirect하거나 request를 web app 상의 다른 구성요소로 dispatch(처리를 위임)할 수 있다.

### Redirect 과정
1. client가 URL을 브라우저 주소 창에 입력한다.
2. server나 Container로 request가 날아간다.
3. servlet는 request가 완전히 다른 URL로 가야 한다고 결정한다.
4. servlet은 response객체의 sendRedirect() 메소드를 호출한다.
5. HTTP response는 상태 코드 301과 Location 헤더에 새로운 URL 값을 가지고 있다.
6. 브라우저가 response를 받고, 상태 코드가 301인지 확인하고 Location header에 어떤 값이 있는지 확인한다.
7. 브라우저는 이전 response 안의 Location header의 값으로 받은 URL을 사용해서 새로운 request를 만든다. 사용자는 브라우저 주소창의 URL이 바뀌었음을 인지할 수 있다.
8. request가 redirect에 의해 유발된 것이라고 할지라도, request에 대해 특별한 것은 없다. 
9. server는 요청된 URL에 있는 것을 접수한다.
10. HTTP response는 다른 response와 동일하다.
11. 브라우저는 새로운 페이지를 보여준다.

### servlet redirect
servlet redirect하면 브라우저가 일하게 만든다.<br />
redirect는 servlet을 책임으로부터 완전히 벗어나게 해준다. <br />
servlet이 일을 할 수 없다고 결정한 후에 servlet은 단순히 sendRedirect() 메소드를 호출한다.<br />

```java
if(workdsForMe) {
   // handle the request
} else {
   response.sendRedirect("http://www.oreilly.com");
}
```

#### sendRedirect()안에 relative URL사용하기
sendRedirect()의 인자로 http://www...로 시작하는 전체의 URL 주소를 적는 대신 relative URL을 사용할 수 있다. <br/>
response객체에 쓰기 작업을 한 뒤에 sendRedirect()를 호출할 수 없다. <br/>
relative URL은 /로 시작하는 것과 /이 없는 것 두 가지가 있다. <br/>

client가 http://www.wickedlysmart.com/myApp/cool/bar.do를 입력했다고 하자.<br/>
request가 bar.do servlet으로 들어가서 servlet은 relative URL과 함께 sendRedirect()를 호출한다.<br/>

1. /로 시작하지 않은 경우
```java
sendRedirect("foo/stuff.html");
```
Container는 원래 주소를 가지고 완전한 URL 주소를 작성한다.<br/>
새로운 URL: http://www.wickedlysmart.com/myApp/cool/foo/stuff.html

2. /로 시작하는 경우
```java
sendRedirect("/foo/stuff.html");
```
/는 web Container의 root를 의미한다.<br/>
새로운 URL: http://www.wickedlysmart.com/foo/stuff.html<br/>