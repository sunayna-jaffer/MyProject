
<%@ page contentType="text/html;" language="java"
	import="java.sql.*,
            javax.sql.*,
            java.text.*,
            javax.naming.*"%>

<html>
<head>
<title>Contests</title>
<link rel="stylesheet" type="text/css" href="mobilinkStyles.css">
</head>
<body>
<table width="60%" border="0" cellspacing="1" cellpadding="0"
	style="border-collapse: collapse">
	<tr class="H1">
		<td>Contest List</td>
	</tr>
	<tr class="H2">
		<td width="25%">ContestId</td>
		<td width="45%"><p align="center">Contest Name</td>
		<td width="25%"><p align="center">Keyword Check Required</td>
	</tr>

	<%

	Connection con=null;
   	DataSource ds=null;
   	PreparedStatement pstmt1=null;
   	ResultSet rs1=null;
try{

	InitialContext context = new InitialContext();
    ds = (DataSource)context.lookup("java:HoujeratSubscription");
	con = ds.getConnection();
	pstmt1 = con.prepareStatement("SELECT id, cid, contestname, CASE WHEN keywordcheckflag=0 THEN 'Keyword_Check_Required' ELSE 'Keyword_Check_Not_Required' END, keywordcheckflag FROM contest(nolock) ");
	rs1 = pstmt1.executeQuery();
	String cid="";
	String cname="";
	String keywordcheckflag = "";
	String id = "";
	
	while(rs1.next())
	{
		id = rs1.getString(1);
		cid=rs1.getString(2);
		cname=rs1.getString(3);
		keywordcheckflag =rs1.getString(5);
%>
	<tr class="content">
		<td width="25%"><%=cid%></td>
		<td><%=cname%></td>
		<td><a class="sublinks" target="I1"
			href='ContestModify.jsp?id=<%=id%>&cname=<%=cname%>&cid=<%=cid%>&keywordcheckflag=<%=keywordcheckflag%>'><%=rs1.getString(4)%></a></td>
	</tr>
	<%
	}
	}catch(SQLException exe){
   	System.out.println("Could not execute.."+exe.getMessage());

    }catch(NamingException ne){

    	System.out.println("Naming exception occured..."+ne.getMessage());
    }finally{
		try{
    	   	 if(rs1 != null){
            	rs1.close();
             }
             if (pstmt1 != null){
                pstmt1.close();
             }
             if (con != null){
                 con.close();
             }
    	}catch(Exception e){
    		rs1 = null;
			pstmt1 = null;
			con = null;
    	}
    }
%>
</table>
<table width="100%">
	<tr>
		<td width="70%" align="left"><a class="sublinks" href="Contest.jsp">Refresh</a>
		</td>
	</tr>
</table>
<p><iframe name="I1" width="570" height="318" border="0" frameborder="0">
Your browser does not support inline frames or is currently configured
not to display inline frames. </iframe></p>

</body>

</html>
