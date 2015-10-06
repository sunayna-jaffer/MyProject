
<html>

<head>
<base target="main">
<link rel="stylesheet" type="text/css" href="mobilinkStyles.css">
</head>

<body bgcolor="#FF6600">
<% 
	String loginname;
	loginname=(String) session.getAttribute("loginname");
	
	System.out.println("loginname: " + loginname);
	
	if (loginname.equals("admin") || loginname.equals("alain")){
 %>
<p><a href="Contest.jsp">Contest</a></p>
<p><a href="keywords.jsp">Keywords</a></p>
<p><a href="UnSubcribeKeyword.jsp">Unsubscribe Keywords</a></p>
<p><a href="messages.jsp">Messages</a></p>
<!--<p><a href="http://192.168.1.250:8080/softlaunch/contentde.jsp">Add MMS Contents</a></p> -->
<p><a href="Contents.jsp">Add WAP Contents</a></p> 
<p><a href="Scheduler.jsp?loginname=<%=loginname%>">Scheduler</a></p>
<p><a href="DailySubsribers.jsp">Daily Subscribers</a></p>
<!--<p><p><a href="SubscribersStatistics.jsp">Subscriber statistics</a></p>-->
<p><a href="URLMapping.jsp">URL Mapping</a></p>
<!--<p><a href="IncorrectKeyword.jsp">Incorrect Keyword Users</a></p> -->
<!-- <p><a href="AtheerChargedMessagesTraffic.jsp?loginname=<%=loginname%>">Zain Iraq Charged MT Traffic</a></p> -->
<!-- <p><a href="KuwaitChargedMessagesTraffic.jsp">Zain Kuwait Charged MT Traffic</a></p> -->
<!--<p><a href="WataniyaChargedMessagesTraffic.jsp">Wataniya Kuwait Charged MT Traffic</a></p> -->
<!--<p><a href="VivaChargedMessagesTraffic.jsp">Viva Kuwait Charged MT Traffic</a></p> -->
<!-- <p><a href="BahrainChargedMessagesTraffic.jsp">Zain Bahrain Charged MT Traffic</a></p>-->

<%
	}
%>
	
</body>
</html>


