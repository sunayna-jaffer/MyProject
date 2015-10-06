
<%@ page contentType="text/html;" language="java"
	import="java.sql.*,
            javax.sql.*,
            java.text.*,
            javax.naming.*"%>

<html>
<head>
<title>ShortCode URL</title>
<link rel="stylesheet" type="text/css" href="mobilinkStyles.css">
</head>
<body>
<table width="100%" border="0" cellspacing="1" cellpadding="0"
	style="border-collapse: collapse">
	<tr class="H1" >
		<td colspan="3">ShortCode URL Mapping</td>
	</tr>
	<tr class="H2">
		<td width="25%">ShortCode</td>
		<td width="75%"><p align="center">URL</td>
		<td width="10%"><p align="center">ShortCodeType</td>
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
	pstmt1 = con.prepareStatement("select id, shortCode, URL, ShortCodeType from SC_URL_MAPPING(nolock) where OpCode = 40 and cid = 1 and ShortCodeType in ('C','F')");
	rs1 = pstmt1.executeQuery();
	String ShortCode="";
	String URL="";
	String ShortCodeType = "";
	String id = "";
	
	while(rs1.next())
	{
		id = rs1.getString(1);
		ShortCode=rs1.getString(2);
		URL=rs1.getString(3);
		ShortCodeType =rs1.getString(4);
%>
	<tr class="content">
		<td width="25%"><%=ShortCode%></td>
		<td><%=URL%></td>
		<td><a class="sublinks" target="I1"
			href='URLMappingModify.jsp?id=<%=id%>&ShortCode=<%=ShortCode%>&URL=<%=URL%>&ShortCodeType=<%=ShortCodeType%>'><%=ShortCodeType%></a></td>
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
		<td width="70%" align="left"><a class="sublinks" href="URLMapping.jsp">Refresh</a>
		</td>
	</tr>
</table>
<p><iframe name="I1" width="570" height="318" border="0" frameborder="0">
Your browser does not support inline frames or is currently configured
not to display inline frames. </iframe></p>

</body>

</html>
