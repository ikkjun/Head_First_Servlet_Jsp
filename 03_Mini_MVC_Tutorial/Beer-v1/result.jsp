<%@ page import="java.util.*" %>

<html>
<body>
<h1 align="center">Beer Recommendations JSP</h1>
<p>
    <%
        List styles = (List)request.getAttribute("styles");
        Iterator it = styles.iterator();
        while(it.hasNext()) {
            out.print("<br>try: " + it.next());
        }
    %> <!-- <% %> 안에 표준 자바 언어를 코딩하는 것을 scriptlet code라고 한다.-->
</p>
</body>
</html>