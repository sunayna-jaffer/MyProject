
<%@ page language="java" contentType="text/html;charset=windows-1256"
	import="java.util.*,java.sql.*,
            javax.sql.*,
            javax.naming.*"%>

<%
	String id = request.getParameter("id");
	String ShortCode = request.getParameter("ShortCode");
	String URL = request.getParameter("URL");
	String ShortCodeType = request.getParameter("ShortCodeType");


%>

<html>
<head>
<title>URL Mapping Modify</title>
</head>
<body>

<form method="POST" action="URLMappingProcess.jsp">
	
	<input type="hidden" name="id"	size="20" value=<%=id%>>
	<input type="hidden" name="ShortCode" size="20" value=<%=ShortCode%>>
	<input type="hidden" name="URL"	size="20" value=<%=URL%>>

<table width="100%" border="0" bgcolor="#FFDD66" cellspacing="1"
	cellpadding="0" style="border-collapse: collapse">
	<tr>
		<td bgcolor="#FF9933" colspan=4>
		<p align="center"><b><font size="3" color="#0000FF"> Modify MT Charged ShortCode</font></b>
		</td>
	</tr>
	<tr>
		<td width="35%"><font color="#0000FF"><b>Free </b></td>
		<td width="15%"><INPUT TYPE=RADIO NAME="ShortCodeType"  value=F></td>
		<td width="35%"><font color="#0000FF"><b>Charging </b></td>
		<td width="15%"><INPUT TYPE=RADIO NAME="ShortCodeType"  value=C></td>
	</tr>
</table>
<table width="70%" border="0" cellspacing="1" cellpadding="0"
	style="border-collapse: collapse">
	<tr>
		<td colspan=2>
		<p align="center"><input type="submit" value="Submit" name="Add"> <input
			type="reset" value="Reset" name="Clear"></p>
		</td>
	</tr>
</table>
<p>&nbsp;</p>
</form>
</body>
</html>
