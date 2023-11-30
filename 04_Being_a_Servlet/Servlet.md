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

## 서블릿의 일생
서블릿은 오직 하나의 중요한 상태를 가지는데 이는 초기화이다.  
서블릿이 초기화되지 않았다는 말은 초기화 되는 중(생성자를 실행하거나 init() 메소드를 실행하거나)이거나, 소멸되는 중(destory() 메소드를 실행)이거나 존재하지 않은 것 중 하나이다.

## 서블릿 API
### servlet은 생명주기 메소드를 상속받는다.  
Servlet interface(javax.servlet.Servlet)
**service(ServletRequest, ServletResponse)**
**init(ServletConfig)**
**destory()** &#8594; 생명주기 메소드
getServletConfig()
getServletInfo()
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
<hr>
HttpServlet 클래스  
**service(HttpServletRequest, HttpServletResponse)**
service(ServletRequest, ServletResponse)
doGet(HttpServletRequest, HttpServletResponse)
doPost(HttpServletRequest, HttpServletResponse)
doOption(HttpServletRequest, HttpServletResponse)
doPut(HttpServletRequest, HttpServletResponse)
doTrace(HttpServletRequest, HttpServletResponse)
doDelete(HttpServletRequest, HttpServletResponse)
getLastModified(HttpServletRequest, HttpServletResponse)
(추상 클래스) HttpServlet는 servlet의 HTTP적인 측면을 반영하기 위해 service()를 재정의한다.<br>
이는 service() 메소드가 오래된 servlet의 request와 response를 받지 않고, HTTP request와 response만 받는다는 의미이다.
<hr>
MyServlet 클래스  
작성할 서블릿의 대부분 행위는 상위 클래스의 메소드를 상속받음으로써 해결된다. 그러므로 HTTP 메소드를 재정의 하는 일만 하면 된다.

## servlet에게 3번의 중요한 순간들
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
   * 이름
      * 