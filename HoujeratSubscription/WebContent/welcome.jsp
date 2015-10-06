<html>

<head>
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1256">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Houjerat Subscription</title>

<script language="javascript">
 function gotoLogin()
	{
		window.open('index.jsp','_parent');
	}


</script>

</head>

<frameset rows="90,*" FRAMEBORDER=NO FRAMESPACING=0 BORDER=0>
	<frame name="banner" scrolling="auto" noresize target="contents"
		src="top.jsp">
	<frameset cols="140,*" FRAMEBORDER=NO FRAMESPACING=0 BORDER=0>
		<frame name="contents" target="main" scrolling="auto" noresize src="left.jsp">
		<frame name="main" src="main.jsp">
	</frameset>
	<noframes>
	<body>

	<p>This page uses frames, but your browser doesn't support them.</p>
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
	</body>
	</noframes>
</frameset>

</html>
