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
  String contest = null;
  String strCondition = null;
  String strOpCodeCondition = null;
  String Country = null;

 From = request.getParameter("fromdate");
 To = request.getParameter("todate");
 contest = request.getParameter("contest");
 Country = request.getParameter("Country");
 System.out.println("Country: " + Country);
  String query = null;

	if(Country.equals("Iraq"))
	{
		strOpCodeCondition = " OpCode = 40 ";
	}
	else if(Country.equals("Bahrain"))
	{
		strOpCodeCondition = " OpCode = 11 ";
	}	
		else if(Country.equals("Zain - Kuwait"))
	{
		strOpCodeCondition = " OpCode = 14 ";
			
	}
		else if(Country.equals("Wataniya - Kuwait"))
	{
		strOpCodeCondition = " OpCode = 15 ";
			
	}
		else if(Country.equals("Sudan"))
	{
		strOpCodeCondition = " OpCode = 62 ";
	}	
		else if(Country.equals("Yemen"))
	{
		strOpCodeCondition = " OpCode = 4 ";
	}	
	if(contest.equals("1"))
	{
		strCondition = "Cid = 1 ";
	}
	else if(contest.equals("2"))
	{
		strCondition = "Cid = 2 ";
	}
	else
	{
		strCondition = "Cid IN (1,2) ";
	}
	query="SELECT CONVERT(varchar,fromdate,111) 'Date' , count(case when status = 1 then 1 end) 'Active Subscribers', ";
	query = query+" count(case when status in (0,2) then 2 end) 'Inactive Subscribers' FROM Subscribers(nolock) ";
	query=query+"WHERE " + strCondition + " AND FromDate <= '"+To+"'  and FromDate >'"+From+"' AND " + strOpCodeCondition;
	query=query+"GROUP BY CONVERT(varchar,FromDate,111) ORDER BY CONVERT(varchar,FromDate,111) desc";
	
	System.out.println("query: " + query);
	
%>

<sql:query var="data" dataSource="${ds}">
	<%=query%>
</sql:query>


<div id="body">

<display:table name="${data.rows}" id= "records" pagesize="50" sort="external" export="true" varTotals="totals">
  <display:column property="Date" title="Date" sortable="true" headerClass="sortable" />
  <display:column property="Active Subscribers" title="Active Subscribers" total="true" />
   <display:column property="Inactive Subscribers" title="Inactive Subscribers" total="true" />
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
    <tr>
  </display:footer>

</display:table>
</div>
</form>
</body>
</html>

