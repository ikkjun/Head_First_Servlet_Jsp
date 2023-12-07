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

## servlet이 초기화 된 다음 servlet init parameter를 사용할 수 있다.
servlet은 getServletConfig()을 상속받는다. getServletConfig 참조를 얻은 뒤에 getInitParameter()를 호출할 수 있다. 하지만 이 메서드를 생성자에서 호출할 수 없다. Container가 servlet의 init()을 호출하고 난 뒤에, servlet은 servlet의 정체성을 갖는다.<br/>

Container가 servlet을 초기화할 때, Container는 servlet마다 하나씩 ServletConfig을 생성한다. Container는 DD에서 servlet init parameter를 읽고, servlet init parameter를 ServletConfig로 넘겨준다. 그 다음 ServletConfig를 servlet의 init() 메서드에 넘겨준다.<br/>

