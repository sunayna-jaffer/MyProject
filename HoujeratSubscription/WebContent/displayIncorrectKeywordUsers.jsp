<%@ page contentType="text/html;charset=UTF-8"
    language="java"
    import="java.sql.*,
            java.util.*,
            javax.sql.*,
            javax.naming.*,
            java.io.*,
            javax.servlet.*,
            javax.servlet.http.*,
	    java.text.*"  %>
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
<form method="Post" name="list" action="SubscribeUsers.jsp" target="I1">
<%

  String From="";
  String To="";
  String Operator = "";
  String strCondition = null;

  From = request.getParameter("fromdate");
  To = request.getParameter("todate");
  Operator = request.getParameter("Operator");
  
  /*if(Operator.equals("14"))
  {
  	strCondition = " AND OpCode = 14 ";
  }
  else if (Operator.equals("40"))
  {
  	strCondition = " AND OpCode = 40 ";
  }
    else if (Operator.equals("11"))
  {
  	strCondition = " AND OpCode = 11 ";
  }
  else
  {
  	strCondition = "";
  }*/
  
  strCondition = "And OpCode = "+Operator;
  String query = null;

	/*query="SELECT DISTINCT SOA, Content FROM ContestLog(nolock) ";
	query=query+"WHERE TimeCreated <= '"+To+"'  and TimeCreated >'"+From+"' " + strCondition + "  AND Cid = 0 " ;
	query=query+"AND SOA NOT IN (SELECT SOA FROM Subscribers) ";*/
	
	query = "execute usp_incorrectkeyword_sel '"+From+"','"+To+"','"+Operator+"'";	
	
	System.out.println("query: " + query);

%>



<sql:query var="data" dataSource="${ds}">
	<%=query%>
</sql:query>
   
    
<div id="body">
	<input type="hidden" name="Operator" value=<%=Operator%> >
	<display:table name="${data.rows}" id= "records" pagesize="1000" export="true" >
	 <display:column title="Select" >	  	
	  	<input type="checkbox" name="SOA" value="${records.SOA}" />		
	  </display:column>
	  <display:column property="SOA" title="SOA" />
	  <display:column property="Content" title="Content" />
	</display:table>
</div>

<p align="center"><input type="submit" value="Submit" name="B1" ></p>
</form>
</body>
</html>

