# Objectives
Web Container Model
1. servlet과 ServletContext 초기화 파라미터에 관하여: <br/>
초기화 파라미터값을 읽기 위한 서블릿 코드를 작성한다.<br/>
초기화 파라미터를 선언하기 위하여 배포 서술자를 작성한다.

2. 기본적인 서블릿 생존범위에 대하여: 속성을 추가하고, 읽고, 삭제하는 서블릿 코드를 작성한다. <br>주어진 시나리오에 따라 적당한 속성 생존범위가 무엇인지 알아본다. <br> 각각의 생존범위에 대한 멀티스레딩 문제를 알아본다.

3. request, sessions, web applications를 위한 Web Container 생명주기 event model을 설명한다. <br/> 각각의 생존범위를 위한 listener 클래스를 생성하고 설정한다. <br/> 생존 범위별 listener 클래스, 주어진 시나리오의 특징을 생성하고 설정한 뒤, 사용할 적절한 특성의 listener를 식별하기.

4. RequestDispatcher mechanism을 설명하기; request dispatcher를 생성하는 servlet 코드 만들기; target resource에 대한 forward나 include servlet code 작성하기; target resource에 대한 container가 지원하는 부가적인 request 속성이 무엇인지 설명하기.

# attribute and listener
서블릿 클래스 안에 이메일 주소를 하드 코딩하는 방식 대신 이메일 주소를 배포 서술자(web.xml) 안에 넣으면 된다. 그러면 서블릿은 DD에서 이메일 주소를 읽어오면 되는 것이다.

**In the DD(web.xml) file**
```html
<servlet>
  <serlet-name>BeerParamTests</servlet-name>
  <servlet-class>TestInitParams</servlet-class>
  
  <init-param>
    <param-name>adminEmail</param-name>
    <param-value>ikjun96@gmail.com</param-value>
  </init-param>
</servlet>
```

**In the servlet code**
```java
out.println(getServletConfig().getInitParameter("adminEmail"));
```
## servlet init parameter
### servlet이 초기화 된 다음 servlet init parameter를 사용할 수 있다.
servlet은 getServletConfig()을 상속받는다. getServletConfig 참조를 얻은 뒤에 getInitParameter()를 호출할 수 있다. 하지만 이 메서드를 생성자에서 호출할 수 없다. Container가 servlet의 init()을 호출하고 난 뒤에, servlet은 servlet의 정체성을 갖는다.<br/>

Container가 servlet을 초기화할 때, Container는 servlet마다 하나씩 ServletConfig을 생성한다. Container는 DD에서 servlet init parameter를 읽고, servlet init parameter를 ServletConfig로 넘겨준다. 그 다음 ServletConfig를 servlet의 init() 메서드에 넘겨준다.<br/>

### Container가 servlet을 초기화할 때 servlet init parameter는 단 한 번 읽는다.
servlet init parameter가 ServletConfig에 기록되면 servlet을 다시 배포하지 않는한 다시 읽지 않는다. 
1. Container는 servlet init parameters를 포함하는 servlet을 위한 DD(배포 서술자)를 읽는다.
2. Container는 새로운 ServletConfig 인스턴스를 (서블릿 당 하나씩) 만든다.
3. Container는  각각의 servlet init parameter마다 String 타입의 name과 value의 한 쌍을 만든다.
4. Container는 ServletConfig 참조에 이름/값으로 된 init parameters를 설정한다.
5. Container는 servlet 클래스의 새로운 인스턴스를 생성한다.
6. Container는 ServletConfig의 참조를 인자로 하는 servlet의 init() method를 호출한다. 

### ServletConfig 테스트하기
ServletConfig의 주요 업무는 init parameters에 대한 정보를 주는 것이다. ServletConfig는 ServletContext도 주지만, context를 보통 다른 방식으로 받고, getServletName() 메서드를 자주 사용하지 않는다. 

### 어떻게 JSP가 servlet init parameter에 접근할 수 있는가?
DD안에 있는 servlet의 init parameter안에 넣은 것과 동일한 정보를 application의 다른 부분에서 사용하기 원한다면 몇 가지 작업을 완료해야 한다.
```java
// doPost() 메소드 안
String color = request.getParameter("color");

BeerExpert be = new BeerExpert();
List result = be.getBrands(color);

request.setAttribute("styles",result);
```
1. request객체로부터 client가 고른 색깔을 얻는다.
2. 그 다음 인스턴스화를 하고, MODEL을 이용해서 VIEW에 필요한 정보를 얻는다.
3. 그 다음 request의 "attribute"를 설정하고, request를 JSP가 처리하도록 넘긴다(forward).

### init parameter limits
request 객체 속성에 이메일 주소를 설정할 수 하지만, request 객체를 받는 JSP하고만 정보를 공유한다. 

### Context init parameters가 답이다.
context parameters가 하나의 servlet만 사용하는 것이 아니라 전체의 web app에서 사용할 수 있다는 점을 제외하고, Context init parameters는 servlet init parameters와 정확히 동일한 방식으로 작동한다. 이것은 web app에 있는 어떠한 servlet이나 JSP는 context init parameters에 접근할 권한이 있다는 것을 의미한다. 

**In the DD(web.xml) file:**
```html
<servlet>
  <servlet-name>BeerParamTests</servlet-name>
  <servlet-class>TestInitParams</servlet-class>
</servlet>

<context-param>
  <param-name>adminEmail</param-name>
  <param-value>ikjun96@gmail.com</param-value>
</context-param>
```
<servlet> 원소 안에 있던 <init-param> 원소를 모두 삭제했다.<br/>
param-name과 paramvalue를 servlet init parameters와 동일하게 넘겨쥰다. 단, 이 항목은 <init-param> 대신 <context-param> 안에 있다.<br/>
<context-param>은 전체 app을 위한 것이므로 개별 <servlet> 원소 안에 들어가지 않는다. <context-param>은 <web-app>안에 넣어야 하지만 <servlet> 밖에 위치해야 한다.

**servlet code:**
```java
out.println(getServletContext().getInitParameter("adminEmail"));
```
모든 servlet은 getServletContext() 메소드를 상속받는다. <br/>
getServletContext() 메소드는 ServletContext 객체를 반환한다. 그리고 그 객체의 메소드 중 하나가 getInitParameter()이다.

### context vs. servlet init parameters
servlet init parameters만 DD 파일 내에 init이 있을지라도, 둘 다  init parameter으로 여겨진다.

||Context init parameters|servlet init parameters|
|---|---|---|
|Deployment Descriptor| \<web-app> 항목 내에 작성해야지 \<servlet> 항목 안에 작성하면 안 된다.|\<servlet> 항목 안에 작성한다.|
|servlet code|getServlet.Context().getInitParameter("foo");|getServletConfig().getInitParameter("foo");|
|Availability|web app에 존재하는 어떠한 servlet이나 JSP.|\<init-param>이 설정된 서블릿에만.|
|개수|전체 web app마다 ServletConteext는 한 개|servlet당 한 개|

### web app initialization
1. Container가 DD를 읽은 뒤, 각각의 <context-param> 마다 name과 value String 쌍을 만든다.
2. Container는 새로운 ServletContext 인스턴스를 만든다.
3. Container는 ServletContext에 context init parameter 각각의 name과 value 쌍에  참조를 넘겨준다.
4. 하나의 web app의 부분으로서 배포된 모든 servlet과 JSP는 동일한 ServletContext에 접근할 수 있다.

init parameter라고 적혀있다면 servlet init parameter라고 생각하면 된다. DD에서 init param이라는 말은 servlet parameter에만 있기 때문이다. 

## ServletContext
ServletContext는 JSP나 서블릿을 Container 또는 web app의 다른 부분과 연결시켜 준다. 

### 두 가지 방식으로 ServletContext를 받을 수 있다.
1. getServletConfig().getServletContext().getInitParameter()
ServletConfig 객체는 ServletContext에 대한 참조를 가지고 있다.
2. this.getServletContext().getInitParameter()

### context paameter limitations
init parameter는 String만 된다. database에 DataSource 객체를 저장할 수는 없을까?

## context listener
context initialization event에 리스닝 하는 것을 원한다. 이를 이용하면 context init parameter를 얻을 수 있고, app이 client에게 서비스 하기 전에 특정 코드를 실행할 수 있다.<br/>
이것을 하기 위해 servlet이나 JSP가 아닌 분리된 class를 필요로 한다. 그 class는 ServletContext의 두 가지 중요한 event인 initialization과 destruction을 listen할 수 있는 것이어야 한다. 그 분리된 class는 javax.servlet.ServletContextListener를 구현한다.

### ServletContextListener 클래스
```java
import javax.servlet.*;
public class MyServletContextListener implements ServletContextListener {
  public void contextInitialized(ServletContextEvent event) {
    // database 연결을 초기화 하는 코딩
    // context atriute에 저장
  }

  public void contextDestroyed(ServletContextEvent event) {
    // close the database connection
  }
}
```

### HttpSessionBindingListener와 HttpSessionAttributeListener 차이점
HttpSessionBindingListener: 속성 자신이 세션에 속성으로 추가, 제거되었는지 알기 위해 사용<br/>
HttpSessionAttributeListener: 세션에 어떤 속성이라도 속성이 추가, 제거, 수정되는 이벤트가 발생하는지 알고 싶을 때 사용<br/>

## 속성이란?
3개의 서로 다른 servlet API객체 - ServletContext, HttpServletRequest, HttpSession - 중 하나에 설정하는(binding) 객체를 말한다. map 인스턴스 변수에 String과 value 쌍으로 저장하는 것으로 단순히 생각할 수 있다. 현실에서는 실제로 어떻게 구현되어 있는지보다, attrubute가 존재하는 범위가 더 중요하다. 

### 세 가지 생존범위: context, request, session
#### Context Attribute
어플리케이션 안에 있는 누구든지 접근할 수 있다.
#### Session Attribute
특정한 HttpSession에 접근 권한을 가진 것만 접근할 수 있다.
#### Request Attribute
특정한 ServletRequest에 접근 권한을 가진 것만 접근할 수 있다.

### Attibute API
Thethreeattributescopes—context, request, and session—are handled by the ServletContext, ServletRequest, and HttpSession interfaces. 'The API methods for attributes are exactly the same in every interface.

세 가지 속성 범위 - context, request, session - 은 ServletContext, ServletRequest, 그리고 HttpSession interface에 의해 다뤄진다. 각각의 interface에서 속성의 API 메소드는 동일하다.
```java
Object getAttribute(String name)
void setAttribute(String name, Object value)
void removeAttribute(String name)
enumeration getAttributeNames()
```

### attribute의 어두운 면
context의 생존범위는 thread-safe하지 않다. 이는 app 안에 있는 어떤 것이든 context attribute에 접근할 수 있고, 이는 다양한 servlet을 의미하기 때문이다. 그리고 다양한 servlet은 다양한 스레드를 의미한다. 왜나하면 요청들은 동시에 서로 다른 스레드에서 처리되기 때문이다. 이것은 요청이 동일한 servlet에서 들어온 것인지 다른 servlet에서 들어온 것인지에 상관 없이 발생한다.

#### 어떻게 하면 context attribute를 thread-safe하게 만들 수 있을까?
service 메소드를 동기화하는 것은 context attribute를 보호할 수 없다. <br/>
service 메소드를 동기화한다는 것은 한 번에 오직 하나의 servlet 메소드만 실행된다는 의미이다. 하지만 이는 다른 servlet이나 JSP가 속성에 접근하는 것을 마지 못한다는 것은 아니다. service 메소드를 동기화하는 것은 동일한 servlet의 스레드가 context 속성에 접근하는 것을 막을 수 있겠지만, 완전히 다른 servlet의 스레드가 수정하는 것은 막지 못한다.

### context attribute를 보호하는 전형적인 방법은 context 객체 자체를 동기화 하는 것이다.
context에 접근하는 모두가 context 객체에 있는 lock에 접근해야만 한다면, 한 번에 오직 하나의 스레드만이 context attribute를 얻거나 설정할 수 있다. 하지만 여기에도 조건이 있다. 동일한 context attribute를 다루는 모든 코드들이 ServletContext에 대하여 lock을 걸어야 작동한다. web app을 디자인하고 있다면, 모든 사람들이 attribute에 접근하기 전에 lock을 걸게 결정할 수 있다.

### session attribute는 thread-safe한가?
세션은 client와의 대화 상태를 유지하기 위한 객체이다. 하나의 client가 있다면, 그리고 하나의 client가 한 번에 오직 하나의 요청만 처리할 수 있다면, 자동적으로 세션이 thread-safe라고 할 수 있다. 다시 말하면 여러 개의 servlet이 포함되어 있다고 하더라도, 특정한 어느 시점에서 그 특정한 servlet에 대한 요청은 하나이다. 즉, 한 시점에 작동하는 스레드는 오직 하나라는 것이다.
<br/>
그러나 동일한 client가 동시에 하나 이상의 요청을 보낸다면 session attribute는 thread-safe할까? client는 새로운 브라우저를 열 수 있다. 브라우저의 다른 인스턴스 container는 client를 위해 여전히 동일한 session을 사용할 수 있다. 그러므로 container는 두 번째 window로부터 들어온 요청도 동일한 세션으로 처리할 수 있다. 그래서 session attribute도 안전하지 않으므로 보호되어야 한다. 이를 위해 HttpSession에 동기화를 해야 한다. 이 때 가능한 한 동기화 블럭을 작게 만들어야 한다. 그래야 다른 스레드가 이 코드를 실행할 수 있다. 
<br/>

### SingleThreadModel은 인스턴스 변수를 보호하기 위해 디자인되었다.
어떤 두 스레드도 동시에 이 servlet의 서비스 메소드를 실행할 수 없다.
웹 컨테이너가 서블릿이 한번에 하나의 요청만 처리하는 것은 다음과 같이 두 가지 방식으로 이루어진다. 
1. 요청을 큐로 처리하는 방법
첫번째로 컨테이너가 서블릿 하나를 만든다. 그런 다음 서블릿이 요청을 하나씩 처리하는 거죠. 즉 하나의 요청을 완벽하게 끝낸 다음에야 다음 요청을 받는 방식 말입니다. 둘째로 컨테이너가 서블릿 인스턴스 풀을 만드는 겁니다. 요청이 동시에 여럿 들어오면 각각의 서블릿 인스턴스가 요청을 하나씩 처리하는 방식입니다