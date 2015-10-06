
<%@ page language="java" import="java.util.*"%>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";		
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>Houjerat Subscription </title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<script language="javascript">
 function gotoLogin()
	{
		window.open('index.jsp','_parent');
	}


</script>
</head>

<body>
<%

String loginname;
loginname=(String) session.getAttribute("loginname");
if(loginname==null)
{
%>
	<script>gotoLogin();</script>
 <%
}
%>
This is designed for Houjerat Subscription
<br>
</body>
</html>
