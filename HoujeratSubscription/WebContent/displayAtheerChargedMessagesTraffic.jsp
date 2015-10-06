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
<title>HoujeratSubscription </title>
<link rel="stylesheet" type="text/css" href="css/mobilinkStyles.css">
<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, print" />

</head>

<body>
<form name="winner" method="post" action="sendMessage.jsp">
<%

  String From="";
  String To="";

 From = request.getParameter("fromdate");
 To = request.getParameter("todate");
 String username = request.getParameter("username");
  String query = null;

	/*query="SELECT CONVERT(varchar(10), DeliveredDate, 126) 'Date', TotalCount 'Total Hits',  DeliveredCount 'Delivered Hits',RetrialCount,IdleCount from DeliveredReport(nolock) ";
	query=query+"WHERE DeliveredDate <= '"+To+"'  and DeliveredDate >='"+From+"' ";
	query=query+"ORDER BY CONVERT(varchar(10), DeliveredDate, 126) ";*/
	
	 query="select CONVERT(varchar(10), DeliveredDate, 126) 'Date' , TotalCount 'Total Hits', DeliveredCount 'Delivered Hits' ,RetrialCount,IdleCount from reportdb.dbo.consolidatedMTDelivery(nolock) ";
	 query=query + " where sc = '3574' and OpCode = 40 and DeliveredDate <= '"+To+"'  and DeliveredDate >='"+ From + "'";
	 query=query+" ORDER BY CONVERT(varchar(10), DeliveredDate, 126) desc";
	 
	
	System.out.println("query: " + query);

	
%>

<sql:query var="data" dataSource="${ds1}">
	<%=query%>
</sql:query>



<div id="body">

<display:table name="${data.rows}" id= "records" pagesize="50" sort="external" export="true" varTotals="totals">
  <display:column property="Date" title="Date" sortable="true" headerClass="sortable" />
  <display:column property="Total Hits" title="Total Hits" total="true" />
  <display:column property="Delivered Hits" title="Delivered Hits" total="true" />
  <%
  if(username.equals("alain"))
  {
	  
  
  %>
   <display:column property="RetrialCount" title="Retrials Hits" total="true" />
   <display:column property="IdleCount" title="Idle Hits" total="true" />
   <%
  }
   %>
  <display:footer>
    <tr>
      <td bgcolor="#FF6600">
      	<b>Total</b>
      </td>
	  <td bgcolor="#FF6600">
	  	<b><c:out value="${fn:substringBefore(totals.column2, '.0')}" /></b>
	  </td>
	  <td bgcolor="#FF6600">
	  	<b><c:out value="${fn:substringBefore(totals.column3, '.0')}" /></b>
	  </td>
	   <%
  if(username.equals("alain"))
  {
	  
  
  %>
	   <td bgcolor="#FF6600">
	  	<b><c:out value="${fn:substringBefore(totals.column4, '.0')}" /></b>
	  </td>
	  <td bgcolor="#FF6600">
	  	<b><c:out value="${fn:substringBefore(totals.column5, '.0')}" /></b>
	  </td>
	<%
	  }
	%>
    <tr>
  </display:footer>

</display:table>

</div>
</form>
</body>
</html>

