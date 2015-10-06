<%@ page contentType="text/html;charset=UTF-8" language="java"
	import="java.sql.*, javax.sql.*, java.text.*, javax.naming.*"%>

<html>
<head>
<title>Keywords</title>
<link rel="stylesheet" type="text/css" href="mobilinkStyles.css">
</head>
<body>
<table width="90%" border="0" cellspacing="1" cellpadding="0"
	style="border-collapse: collapse">
	<tr class="H1">
		<td colspan=4>Keywords List </td>
	</tr>
	<tr class="H2">
		<td width="30%">Id</td>
		<td width="30%">Keywords</td>
		<td width="30%">Keyword Type</td>
		<td width="70%">Contest name</td>
		
		
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
		pstmt1 = con.prepareStatement("SELECT keyword.id, keyword.keyword, keyword.cid,contest.contestname, keyword.type FROM  keyword , Contest WHERE type IN ('S','M')AND keyword.cid = contest.cid");
		rs1 = pstmt1.executeQuery();
		String kwid, keyword,cid,contestname;
		String strKeywordType = "S";
		while(rs1.next())
		{
			kwid=rs1.getString(1);
			keyword=(rs1.getString(2)).trim();
			cid=rs1.getString(3);
			contestname=rs1.getString(4);
			strKeywordType = rs1.getString(5);
%>
	<tr class="content">
	   <td width="30%"><a class="sublinks" target="I1"
			href='kwadd.jsp?keyword=<%=java.net.URLEncoder.encode(keyword.trim(),"windows-1256")%>&cid=<%=cid%>&kwid=<%=kwid%>&keywordtype=<%=strKeywordType%>&contestname=<%=contestname%>'><%=kwid%></a></td>
		<td width="30%"><%=keyword%></td>
		<td width="30%"><%=rs1.getString(5)%></td>
		<td width="70%"><%=contestname%></td>
	</tr>
	<%	
		}
		%>
		</table>
<table width="100%">
	<tr>
		<td width="10%" align="left"><a class="sublinks" target="I1"
			href="kwadd.jsp?keywordtype=<%=strKeywordType%>">Add</a></td>
		<td width="70%" align="left"><a class="sublinks" href="keywords.jsp">Refresh</a>
		</td>

	</tr>
</table>
<%
		rs1.close();
		rs1 = null;
		pstmt1.close();
		pstmt1 = null;	
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
				//log.info("Connection kept back into the pool.");
             }
    	}catch(Exception e){
    	
    	}
	}
%>

<p><iframe name="I1" width="570" height="318" border="0" frameborder="0">
Your browser does not support inline frames or is currently configured
not to display inline frames. </iframe></p>
</body>
</html>
