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

### 서블릿의 일생
서블릿은 옥 하나의 중요한 상태를 가지는데 이는 초기화이다. 서블릿이 초기화되지 않았다는 말은 최기화 되는 중(생성자를 실행하거나 init() 메소드를 실행하거나)이거나, 소멸되는 중(destory() 메소드를 실행)이거나 존재하지 않은 것 중 하나이다.

### 서블릿 API
servlet은 생명주기 메소드를 상속받는다.
&#8593;
:arrow_up: