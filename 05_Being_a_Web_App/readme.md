# Objectives
Web Container Model
1. servlet과 ServletContext 초기화 파라미터에 관하여: <br/>
초기화 파라미터값을 읽기 위한 서블릿 코드를 작성한다.<br/>
초기화 파라미터를 선언하기 위하여 배포 서술자를 작성한다.

2. 기본적인 서블릿 생존범위에 대하여: 속성을 추가하고, 읽고, 삭제하는 서블릿 코드를 작성한다. <br>주어진 시나리오에 따라 적당한 속성 생존범위가 무엇인지 알아본다. <br> 각각의 생존범위에 대한 멀티스레딩 문제를 알아본다.

3. request, sessions, web applications를 위한 Web Container 생명주기 event model을 설명한다. <br/> 각각의 생존범위를 위한 listener 클래스를 생성하고 설정한다. <br/> 생존 범위별 listener 클래스, 주어진 시나리오의 특징을 생성하고 설정한 뒤, 사용할 적절한 특성의 listener를 식별하기.

4. RequestDispatcher mechanism을 설명하기; request dispatcher를 생성하는 servlet 코드 만들기; target resource에 대한 forward나 include servlet code 작성하기; target resource에 대한 container가 지원하는 부가적인 request 속성이 무엇인지 설명하기.

Describe the RequestDispatcher mechanism; write servlet code to create a request dispatcher; write servlet code to forNard or include the target resource; and identify the additional request­ scoped attributes provided by the container to the target resource.