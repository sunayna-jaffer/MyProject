<%@ page contentType="text/html;charset=UTF-8" language="java"
	import="java.sql.*,
            javax.sql.*,
            javax.naming.*"%>

<html>
<head>
<title>Messages</title>
<link rel="stylesheet" type="text/css" href="mobilinkStyles.css">
</head>
<body>
<table width="100%" border="0" cellspacing="1" cellpadding="0"
	style="border-collapse: collapse">
	<tr class="H1">
		<td colspan="5">Message List</td>
	</tr>
	<tr class="H2">
		<td width="10%">Id</td>
		<td width="30%">Message</td>
		<td width="30%">Description</td>
		<td width="15%">Type</td>
		<td width="20%">Contest</td>
	</tr>

	<%
	Connection con=null;
   	DataSource ds=null;
   	ResultSet rs1;
   	PreparedStatement pstmt1 ;
	try{
		InitialContext context = new InitialContext();
	    ds = (DataSource)context.lookup("java:HoujeratSubscription");
		con = ds.getConnection();		
		pstmt1 = con.prepareStatement("select message.id,message.message,message.type, message.description, message.cid, contest.contestname from message, contest where message.cid = contest.cid");
		rs1 = pstmt1.executeQuery();
		String mesg;
		String id;
		String type;
		String desc;
		String cid;
		String contest;
		while(rs1.next()){
			id=rs1.getString(1);
			System.out.println(id);
			mesg=rs1.getString(2);
			type=rs1.getString(3);
			desc=rs1.getString(4);
			cid=rs1.getString(5);
			contest=rs1.getString(6);
			System.out.println(mesg);
			
%>
	<tr class="content">
		<td width="10%"><a class="sublinks" target="I1"
			href='MesgDml.jsp?id=<%=id%>&mesg=<%=java.net.URLEncoder.encode(mesg,"windows-1256")%>&type=<%=type%>&desc=<%=desc%>&cid=<%=cid%>'><%=id%></a>&nbsp;</td>
		<td width="30%"><%=mesg%>&nbsp;</td>
		<td width="30%"><%=desc%>&nbsp;</td>
		<td width="15%"><%=type%>&nbsp;</td>
		<td width="20%"><%=contest%>&nbsp;</td>
	</tr>
	<%	
		}
		rs1.close();
		rs1=null;
		pstmt1.close();
		pstmt1=null;
		
	}catch(Exception ne){
    	System.out.println("Naming exception occured..."+ne.getMessage());   
    }
	finally{
    		try{
		    	con.close();
		    	con=null;
	    	}catch(Exception e){
    	}
    }
%>
</table>
<table width="100%">
	<tr>
		<td width="10%" align="left"><a class="sublinks" target="I1"
			href="MesgDml.jsp">Add</a></td>
		<td width="10%" align="left"><a> Delete</a>&nbsp;</td>
		<td width="70%" align="left"><a class="sublinks" href="messages.jsp">Refresh</a>
		</td>
	</tr>
</table>
<p><iframe name="I1" width="800" height="400" border="0" frameborder="0">
Your browser does not support inline frames or is currently configured
not to display inline frames.</iframe></p>
</body>
</html>
