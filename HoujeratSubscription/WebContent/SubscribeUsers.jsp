
<%@ page contentType="text/html;charset=UTF-8"
    language="java"
    import="org.apache.commons.httpclient.HttpClient,
            org.apache.commons.httpclient.HttpMethod,
            org.apache.commons.httpclient.HttpStatus,
            org.apache.commons.httpclient.methods.GetMethod,
            org.apache.commons.httpclient.methods.PostMethod"  %>
<%@ include file="datasource.jsp" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<html>
<head>
<title>HoujeratSubscription</title>
<link rel="stylesheet" type="text/css" href="css/mobilinkStyles.css">
<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, print" />

</head>

<body>
<form method="Post" name="list" action="SubscribeUsers.jsp">
<%

 String [] SOA = null;
 String InsertQuery = null;
 String InsertMTQuery = null;
 String Query = null;
 String strSOA = null;
 String postingURL = null;
 String strResponse = null;
 String From = null;
 String To = null;
 String strMsgId = null;
 String Operator = null;
 String MTMsgId = null;
 
 SOA = request.getParameterValues("SOA");
 From = request.getParameter("From");
 To = request.getParameter("To");
 Operator = request.getParameter("Operator");
 
 System.out.println("Operator: " + Operator);
 
  if(Operator.equals("14"))
  { 
 	Query = "SELECT message, unicode FROM Message where Type = 'RG'";
 	InsertQuery = "INSERT INTO Subscribers(SOA, DA, OpCode, Status, Cid) values(?,'98985',14,1,1)";
 	InsertMTQuery = "INSERT INTO MTMessageQueues (SOA, DA, Message, MTMsgId, Status,Tries, Cid, OpCode, MessageType) values (?,'98985',?,?,0,1,1,14,'RG')";
  }
  else   if(Operator.equals("40"))
  { 
 	Query = "SELECT unicode 'unicode' FROM Message where Type = 'RGIQ'";
 	InsertQuery = "INSERT INTO Subscribers(SOA, DA, OpCode, Status, Cid) values(?,'3574',40,1,1)";
  }
  else  if(Operator.equals("11"))
  { 
 	Query = "SELECT unicode 'unicode' FROM Message where Type = 'RG'";
 	InsertQuery = "INSERT INTO Subscribers(SOA, DA, OpCode, Status, Cid) values(?,'77390',11,1,1)";
 	InsertMTQuery = "INSERT INTO MTMessageQueues (SOA, DA, Message, MTMsgId, Status,Tries, Cid, OpCode, MessageType) values (?,'77390',?,?,0,1,1,11,'RG')";
  }
 
 
 
 if (SOA != null) 
 {
 	 for (int i = 0; i < SOA.length; i++) 
      {
      	strSOA = SOA[i];
      	System.out.println("SOA: " + strSOA);
%>
        <sql:update var="data" dataSource="${ds}">
    		<%= InsertQuery %>
	 		<sql:param value='<%= strSOA%>'/>
		</sql:update>
		
		<sql:query var="users" dataSource="${ds}">
			<%=Query%>
		</sql:query>
		<c:forEach var="row" items="${users.rows}">
		 	<c:set var="unicode" value="${row.unicode}"/>
		 	<c:set var="message" value="${row.message}"/>
		 </c:forEach>
 <%    
 	// Send welcome message
 	
 		long id = System.currentTimeMillis();
 		strMsgId = new Long(id).toString();
 		
 		String unicode = (String)pageContext.getAttribute("unicode");
 		String message = (String)pageContext.getAttribute("message");
 		if(Operator.equals("14"))
 		{
	 	    postingURL="http://192.168.1.221:54321/SMSGateway/SMSender?SrvcId=472&OpCode=1&login=mtgapp&passwd=Mc3n00sjc8&SOA=98953&Flags=102";
		    postingURL+="&Content="+unicode+"&MsgId="+strMsgId+"&DA="+strSOA;
	    }
	     else   if(Operator.equals("40"))
  		{ 
  			postingURL="http://192.168.1.221:8080/SMSGateway/SMSender?SrvcId=1423&OpCode=40&login=mtgapp&passwd=Mc3n00sjc8&SOA=MulaBasim&Flags=2";
		    postingURL+="&Content="+unicode+"&MsgId="+strMsgId+"&DA="+strSOA;
  		}
  		else  if(Operator.equals("11"))
  		{
  			postingURL="http://192.168.1.221:8080/SMSGateway/SMSender?SrvcId=1476&OpCode=11&login=mtgapp&passwd=Mc3n00sjc8&SOA=77453&Flags=102";
		    postingURL+="&Content="+unicode+"&MsgId="+strMsgId+"&DA="+strSOA;
  		}
	    System.out.println("IP posting "+postingURL);
	    	    
	    HttpClient client = new HttpClient();
		client.setTimeout(10000);
		client.setConnectionTimeout(50000);				
		HttpMethod method = new GetMethod(postingURL);
				
		if (method.validate()) {
			int statusCode = client.executeMethod(method);
			System.out.println(statusCode);
				
			if (statusCode == HttpStatus.SC_OK) {
				strResponse = method.getResponseBodyAsString();
				MTMsgId =  strResponse.substring(6).trim();
				System.out.println("Response: "+MTMsgId);
			}
						
			else{
				System.out.println("not 200");
				}
						
 		}
 		
 		if(Operator.equals("14") || Operator.equals("11"))
 		{
 		%>
 		<sql:update var="data" dataSource="${ds}">
    		<%= InsertMTQuery %>
	 		<sql:param value='<%= strSOA%>'/>
	 		<sql:param value='<%= message%>'/>
	 		<sql:param value='<%= MTMsgId%>'/>
		</sql:update>
		<%
		}
      }
 }
 
%>

<p><b><font color='red'>Following MSISDNS are successfully subscribed !!! </font> </b><p>

<%
	 if (SOA != null) 
 {
 	 for (int i = 0; i < SOA.length; i++) 
      {
      	strSOA = SOA[i];
      	out.println(strSOA);
      	%>
      	<br/>
      	<br/>
      	<%
      	}
  }
%>
	
</form>
</body>
</html>

