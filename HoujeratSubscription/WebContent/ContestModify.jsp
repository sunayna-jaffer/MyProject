
<%@ page language="java" contentType="text/html;charset=windows-1256"
	import="java.util.*,java.sql.*,
            javax.sql.*,
            javax.naming.*"%>

<%
	String id = request.getParameter("id");
	String cname = request.getParameter("cname");
	String cid = request.getParameter("cid");
	String keywordcheckflag = request.getParameter("keywordcheckflag");
	String label = null;


%>

<html>
<head>
<title>Contest Modify</title>
</head>
<body>

<form method="POST" action="ContestProcess.jsp">
	
	<input type="hidden" name="id"	size="20" value=<%=id%>>
	<input type="hidden" name="cname" size="20" value=<%=cname%>>
	<input type="hidden" name="cid"	size="20" value=<%=cid%>>

<table width="100%" border="0" bgcolor="#FFDD66" cellspacing="1"
	cellpadding="0" style="border-collapse: collapse">
	<tr>
		<td bgcolor="#FF9933" colspan=4>
		<p align="center"><b><font size="3" color="#0000FF"> Modify Keyword Check Required</font></b>
		</td>
	</tr>
	<tr>
		<td width="35%"><font color="#0000FF"><b>Keyword Check Required </b></td>
		<td width="15%"><INPUT TYPE=RADIO NAME="keywordcheckflag"  value=0 ></td>
		<td width="35%"><font color="#0000FF"><b>Keyword Check Not Required </b></td>
		<td width="15%"><INPUT TYPE=RADIO NAME="keywordcheckflag"  value=1 ></td>
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
