<%@ page contentType="text/html;charset=UTF-8"
    language="java"
    import="java.util.*,
    		java.sql.*,
            javax.sql.*,
            java.net.*,
            javax.naming.*"%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
  <head>


    <title>BlackList</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
  </head>

  <body>
<html>
<head>
<title>Group</title>
<link rel="stylesheet" type="text/css" href="mobilinkStyles.css">
</head>
<body>
<br>
	<%
		int totalSubs=0;
		int activeSubs=0;
		int inActiveSubs=0;
		int	totalInActive=0;
        int	totalActive=0;
        int	total=0;
		String contestName=null;
		Connection con=null;
	   	DataSource ds=null;
	   	PreparedStatement pstmt1=null;
	   	ResultSet rs1=null;

  %>

<table width="70%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
	   <tr>
		<td bgcolor="#FF9933" colspan=4>
			<p align="center"><b><font size="4" color="#0000FF">Zain Kuwait Subscribers Statistics
		</td>
	</tr>
	<tr>
		<td bgcolor="#FF9900" >
			<font size="3" color="#0000FF"><b>Group</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>Total</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>Active</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>In Active</b>
		</td>
	</tr>


	<%

	   try{
			InitialContext context = new InitialContext();
		    ds = (DataSource)context.lookup("java:HoujeratSubscription");
			con = ds.getConnection();

            String sel="select t.contestname,t.totalusers ,a.activeusers, t.totalusers-a.activeusers as Inactive ";
			sel=sel+" from vw_ActiveSubscribers a, vw_totalsubscribers t where t.ContestName=a.ContestName and t.Cid = a.Cid and " ; 
			sel=sel+" t.OpCode = a.OpCode and t.OpCode = 14 order by t.ContestName ";

			pstmt1 = con.prepareStatement(sel);
			rs1 = pstmt1.executeQuery();


			while(rs1.next()){
				contestName=rs1.getString(1);
				totalSubs=rs1.getInt(2);
				activeSubs=rs1.getInt(3);
				inActiveSubs=rs1.getInt(4);
		%>
	<tr>
		<td bgcolor="#FFFFFF" >
			<font size="3" color="#0000FF"><%=contestName%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=totalSubs%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=activeSubs%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=inActiveSubs%>
		</td>
	</tr>
  <%
      total=total+totalSubs;
      totalActive=totalActive+activeSubs;
      totalInActive=totalInActive+inActiveSubs;
     }
     
          rs1.close();
     rs1 = null;
     pstmt1.close();
     pstmt1 = null;
     con.close();
     con = null;
	}catch(SQLException exe){
		   	exe.printStackTrace();
		   	System.out.println("Could not execute.."+exe.getMessage());
	    }catch(NamingException ne){
	        ne.printStackTrace();
		   	System.out.println("Naming exception occured..."+ne.getMessage());
		}
		finally{
			try{
		   		if(rs1 != null){
	        		rs1.close();
	        		rs1 = null;
	        		pstmt1 = null;
	           	}
	         	if (pstmt1 != null){
	           		pstmt1.close();
	         	}
	         	if (con != null){
	            	con.close();
	            	con=null;
	         	}
			}catch(Exception e){
			e.printStackTrace();
				rs1 = null;
				pstmt1 = null;
	   		}
	   }
 %>
	<tr>
		<td colspan=1 bgcolor="#FF9900">
			<font size="3" color="#0000FF">Grand Total</td>

		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=total%>
		</td>
		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=totalActive%>
		</td>
		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=totalInActive%>
		</td>
	</tr>
</table>
<br/>
<br/>
<br/>
<br/>


<%
		totalSubs=0;
		activeSubs=0;
		inActiveSubs=0;
		totalInActive=0;
        totalActive=0;
        total=0;
		contestName=null;
		con=null;
	   	ds=null;
	   	pstmt1=null;
	   	rs1=null;

  %>

<table width="70%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
	   <tr>
		<td bgcolor="#FF9933" colspan=4>
			<p align="center"><b><font size="4" color="#0000FF">Wataniya Kuwait Subscribers Statistics
		</td>
	</tr>
	<tr>
		<td bgcolor="#FF9900" >
			<font size="3" color="#0000FF"><b>Group</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>Total</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>Active</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>In Active</b>
		</td>
	</tr>


	<%

	   try{
			InitialContext context = new InitialContext();
		    ds = (DataSource)context.lookup("java:HoujeratSubscription");
			con = ds.getConnection();

            String sel="select t.contestname,t.totalusers ,a.activeusers, t.totalusers-a.activeusers as Inactive ";
			sel=sel+" from vw_ActiveSubscribers a, vw_totalsubscribers t where t.ContestName=a.ContestName and t.Cid = a.Cid and " ; 
			sel=sel+" t.OpCode = a.OpCode and t.OpCode = 15 order by t.ContestName ";

			pstmt1 = con.prepareStatement(sel);
			rs1 = pstmt1.executeQuery();


			while(rs1.next()){
				contestName=rs1.getString(1);
				totalSubs=rs1.getInt(2);
				activeSubs=rs1.getInt(3);
				inActiveSubs=rs1.getInt(4);
		%>
	<tr>
		<td bgcolor="#FFFFFF" >
			<font size="3" color="#0000FF"><%=contestName%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=totalSubs%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=activeSubs%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=inActiveSubs%>
		</td>
	</tr>
  <%
      total=total+totalSubs;
      totalActive=totalActive+activeSubs;
      totalInActive=totalInActive+inActiveSubs;
     }
     
          rs1.close();
     rs1 = null;
     pstmt1.close();
     pstmt1 = null;
     con.close();
     con = null;
	}catch(SQLException exe){
		   	exe.printStackTrace();
		   	System.out.println("Could not execute.."+exe.getMessage());
	    }catch(NamingException ne){
	        ne.printStackTrace();
		   	System.out.println("Naming exception occured..."+ne.getMessage());
		}
		finally{
			try{
		   		if(rs1 != null){
	        		rs1.close();
	        		rs1 = null;
	        		pstmt1 = null;
	           	}
	         	if (pstmt1 != null){
	           		pstmt1.close();
	         	}
	         	if (con != null){
	            	con.close();
	            	con=null;
	         	}
			}catch(Exception e){
			e.printStackTrace();
				rs1 = null;
				pstmt1 = null;
	   		}
	   }
 %>
	<tr>
		<td colspan=1 bgcolor="#FF9900">
			<font size="3" color="#0000FF">Grand Total</td>

		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=total%>
		</td>
		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=totalActive%>
		</td>
		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=totalInActive%>
		</td>
	</tr>

</table>
<br/>
<br/>
<br/>
<br/>

<%
		totalSubs=0;
		activeSubs=0;
		inActiveSubs=0;
		totalInActive=0;
        totalActive=0;
        total=0;
		contestName=null;
		con=null;
	   	ds=null;
	   	pstmt1=null;
	   	rs1=null;

  %>

<table width="70%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
	   <tr>
		<td bgcolor="#FF9933" colspan=4>
			<p align="center"><b><font size="4" color="#0000FF">Viva Kuwait Subscribers Statistics
		</td>
	</tr>
	<tr>
		<td bgcolor="#FF9900" >
			<font size="3" color="#0000FF"><b>Group</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>Total</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>Active</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>In Active</b>
		</td>
	</tr>


	<%

	   try{
			InitialContext context = new InitialContext();
		    ds = (DataSource)context.lookup("java:HoujeratSubscription");
			con = ds.getConnection();

            String sel="select t.contestname,t.totalusers ,a.activeusers, t.totalusers-a.activeusers as Inactive ";
			sel=sel+" from vw_ActiveSubscribers a, vw_totalsubscribers t where t.ContestName=a.ContestName and t.Cid = a.Cid and " ; 
			sel=sel+" t.OpCode = a.OpCode and t.OpCode = 52 order by t.ContestName ";

			pstmt1 = con.prepareStatement(sel);
			rs1 = pstmt1.executeQuery();


			while(rs1.next()){
				contestName=rs1.getString(1);
				totalSubs=rs1.getInt(2);
				activeSubs=rs1.getInt(3);
				inActiveSubs=rs1.getInt(4);
		%>
	<tr>
		<td bgcolor="#FFFFFF" >
			<font size="3" color="#0000FF"><%=contestName%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=totalSubs%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=activeSubs%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=inActiveSubs%>
		</td>
	</tr>
  <%
      total=total+totalSubs;
      totalActive=totalActive+activeSubs;
      totalInActive=totalInActive+inActiveSubs;
     }
     
          rs1.close();
     rs1 = null;
     pstmt1.close();
     pstmt1 = null;
     con.close();
     con = null;
	}catch(SQLException exe){
		   	exe.printStackTrace();
		   	System.out.println("Could not execute.."+exe.getMessage());
	    }catch(NamingException ne){
	        ne.printStackTrace();
		   	System.out.println("Naming exception occured..."+ne.getMessage());
		}
		finally{
			try{
		   		if(rs1 != null){
	        		rs1.close();
	        		rs1 = null;
	        		pstmt1 = null;
	           	}
	         	if (pstmt1 != null){
	           		pstmt1.close();
	         	}
	         	if (con != null){
	            	con.close();
	            	con=null;
	         	}
			}catch(Exception e){
			e.printStackTrace();
				rs1 = null;
				pstmt1 = null;
	   		}
	   }
 %>
	<tr>
		<td colspan=1 bgcolor="#FF9900">
			<font size="3" color="#0000FF">Grand Total</td>

		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=total%>
		</td>
		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=totalActive%>
		</td>
		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=totalInActive%>
		</td>
	</tr>

</table>
<br/>
<br/>
<br/>
<br/>

	<%
		totalSubs=0;
		activeSubs=0;
		inActiveSubs=0;
		totalInActive=0;
        totalActive=0;
        total=0;
		contestName=null;
		con=null;
	   	ds=null;
	   	pstmt1=null;
	   	rs1=null;

  %>

<table width="70%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
	   <tr>
		<td bgcolor="#FF9933" colspan=4>
			<p align="center"><b><font size="4" color="#0000FF">Zain Iraq Subscribers Statistics
		</td>
	</tr>
	<tr>
		<td bgcolor="#FF9900" >
			<font size="3" color="#0000FF"><b>Group</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>Total</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>Active</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>In Active</b>
		</td>
	</tr>


	<%

	   try{
			InitialContext context = new InitialContext();
		    ds = (DataSource)context.lookup("java:HoujeratSubscription");
			con = ds.getConnection();

            String sel="select t.contestname,t.totalusers ,a.activeusers, t.totalusers-a.activeusers as Inactive ";
			sel=sel+" from vw_ActiveSubscribers a, vw_totalsubscribers t where t.ContestName=a.ContestName and t.Cid = a.Cid and " ; 
			sel=sel+" t.OpCode = a.OpCode and t.OpCode = 40 order by t.ContestName ";

			pstmt1 = con.prepareStatement(sel);
			rs1 = pstmt1.executeQuery();


			while(rs1.next()){
				contestName=rs1.getString(1);
				totalSubs=rs1.getInt(2);
				activeSubs=rs1.getInt(3);
				inActiveSubs=rs1.getInt(4);
		%>
	<tr>
		<td bgcolor="#FFFFFF" >
			<font size="3" color="#0000FF"><%=contestName%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=totalSubs%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=activeSubs%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=inActiveSubs%>
		</td>
	</tr>
  <%
      total=total+totalSubs;
      totalActive=totalActive+activeSubs;
      totalInActive=totalInActive+inActiveSubs;
     }
     
          rs1.close();
     rs1 = null;
     pstmt1.close();
     pstmt1 = null;
     con.close();
     con = null;
	}catch(SQLException exe){
		   	exe.printStackTrace();
		   	System.out.println("Could not execute.."+exe.getMessage());
	    }catch(NamingException ne){
	        ne.printStackTrace();
		   	System.out.println("Naming exception occured..."+ne.getMessage());
		}
		finally{
			try{
		   		if(rs1 != null){
	        		rs1.close();
	        		rs1 = null;
	        		pstmt1 = null;
	           	}
	         	if (pstmt1 != null){
	           		pstmt1.close();
	         	}
	         	if (con != null){
	            	con.close();
	            	con=null;
	         	}
			}catch(Exception e){
			e.printStackTrace();
				rs1 = null;
				pstmt1 = null;
	   		}
	   }
 %>
	<tr>
		<td colspan=1 bgcolor="#FF9900">
			<font size="3" color="#0000FF">Grand Total</td>

		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=total%>
		</td>
		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=totalActive%>
		</td>
		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=totalInActive%>
		</td>
	</tr>

</table>
<br/>
<br/>
<br/>
<br/>

	<%
		totalSubs=0;
		activeSubs=0;
		inActiveSubs=0;
		totalInActive=0;
        totalActive=0;
        total=0;
		contestName=null;
		con=null;
	   	ds=null;
	   	pstmt1=null;
	   	rs1=null;

  %>

<table width="70%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
	   <tr>
		<td bgcolor="#FF9933" colspan=4>
			<p align="center"><b><font size="4" color="#0000FF">Zain Bahrain Subscribers Statistics
		</td>
	</tr>
	<tr>
		<td bgcolor="#FF9900" >
			<font size="3" color="#0000FF"><b>Group</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>Total</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>Active</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>In Active</b>
		</td>
	</tr>


	<%

	   try{
			InitialContext context = new InitialContext();
		    ds = (DataSource)context.lookup("java:HoujeratSubscription");
			con = ds.getConnection();

            String sel="select t.contestname,t.totalusers ,a.activeusers, t.totalusers-a.activeusers as Inactive ";
			sel=sel+" from vw_ActiveSubscribers a, vw_totalsubscribers t where t.ContestName=a.ContestName and t.Cid = a.Cid and " ; 
			sel=sel+" t.OpCode = a.OpCode and t.OpCode = 11 order by t.ContestName ";

			pstmt1 = con.prepareStatement(sel);
			rs1 = pstmt1.executeQuery();


			while(rs1.next()){
				contestName=rs1.getString(1);
				totalSubs=rs1.getInt(2);
				activeSubs=rs1.getInt(3);
				inActiveSubs=rs1.getInt(4);
		%>
	<tr>
		<td bgcolor="#FFFFFF" >
			<font size="3" color="#0000FF"><%=contestName%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=totalSubs%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=activeSubs%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=inActiveSubs%>
		</td>
	</tr>
  <%
      total=total+totalSubs;
      totalActive=totalActive+activeSubs;
      totalInActive=totalInActive+inActiveSubs;
     }
     
          rs1.close();
     rs1 = null;
     pstmt1.close();
     pstmt1 = null;
     con.close();
     con = null;
	}catch(SQLException exe){
		   	exe.printStackTrace();
		   	System.out.println("Could not execute.."+exe.getMessage());
	    }catch(NamingException ne){
	        ne.printStackTrace();
		   	System.out.println("Naming exception occured..."+ne.getMessage());
		}
		finally{
			try{
		   		if(rs1 != null){
	        		rs1.close();
	        		rs1 = null;
	        		pstmt1 = null;
	           	}
	         	if (pstmt1 != null){
	           		pstmt1.close();
	         	}
	         	if (con != null){
	            	con.close();
	            	con=null;
	         	}
			}catch(Exception e){
			e.printStackTrace();
				rs1 = null;
				pstmt1 = null;
	   		}
	   }
 %>
	<tr>
		<td colspan=1 bgcolor="#FF9900">
			<font size="3" color="#0000FF">Grand Total</td>

		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=total%>
		</td>
		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=totalActive%>
		</td>
		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=totalInActive%>
		</td>
	</tr>

</table>
<br/>
<br/>
<br/>
<br/>

	<%
		totalSubs=0;
		activeSubs=0;
		inActiveSubs=0;
		totalInActive=0;
        totalActive=0;
        total=0;
		contestName=null;
		con=null;
	   	ds=null;
	   	pstmt1=null;
	   	rs1=null;

  %>

<table width="70%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
	   <tr>
		<td bgcolor="#FF9933" colspan=4>
			<p align="center"><b><font size="4" color="#0000FF">Qatar Subscribers Statistics
		</td>
	</tr>
	<tr>
		<td bgcolor="#FF9900" >
			<font size="3" color="#0000FF"><b>Group</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>Total</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>Active</b>
		</td>
		<td bgcolor="#FF9900" align="right">
			<font size="3" color="#0000FF"><b>In Active</b>
		</td>
	</tr>


	<%

	   try{
			InitialContext context = new InitialContext();
		    ds = (DataSource)context.lookup("java:HoujeratSubscription");
			con = ds.getConnection();

            String sel="select t.contestname,t.totalusers ,a.activeusers, t.totalusers-a.activeusers as Inactive ";
			sel=sel+" from vw_ActiveSubscribers a, vw_totalsubscribers t where t.ContestName=a.ContestName and t.Cid = a.Cid and " ; 
			sel=sel+" t.OpCode = a.OpCode and t.OpCode = 17 order by t.ContestName ";

			pstmt1 = con.prepareStatement(sel);
			rs1 = pstmt1.executeQuery();


			while(rs1.next()){
				contestName=rs1.getString(1);
				totalSubs=rs1.getInt(2);
				activeSubs=rs1.getInt(3);
				inActiveSubs=rs1.getInt(4);
		%>
	<tr>
		<td bgcolor="#FFFFFF" >
			<font size="3" color="#0000FF"><%=contestName%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=totalSubs%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=activeSubs%>
		</td>
		<td bgcolor="#FFFFFF" align="right">
			<font size="3" color="#0000FF"><%=inActiveSubs%>
		</td>
	</tr>
  <%
      total=total+totalSubs;
      totalActive=totalActive+activeSubs;
      totalInActive=totalInActive+inActiveSubs;
     }
     
          rs1.close();
     rs1 = null;
     pstmt1.close();
     pstmt1 = null;
     con.close();
     con = null;
	}catch(SQLException exe){
		   	exe.printStackTrace();
		   	System.out.println("Could not execute.."+exe.getMessage());
	    }catch(NamingException ne){
	        ne.printStackTrace();
		   	System.out.println("Naming exception occured..."+ne.getMessage());
		}
		finally{
			try{
		   		if(rs1 != null){
	        		rs1.close();
	        		rs1 = null;
	        		pstmt1 = null;
	           	}
	         	if (pstmt1 != null){
	           		pstmt1.close();
	         	}
	         	if (con != null){
	            	con.close();
	            	con=null;
	         	}
			}catch(Exception e){
			e.printStackTrace();
				rs1 = null;
				pstmt1 = null;
	   		}
	   }
 %>
	<tr>
		<td colspan=1 bgcolor="#FF9900">
			<font size="3" color="#0000FF">Grand Total</td>

		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=total%>
		</td>
		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=totalActive%>
		</td>
		<td align="right" bgcolor="#FF9900">
			<font size="3" color="#0000FF"><%=totalInActive%>
		</td>
	</tr>

	 <tr>
	</tr>

	 <tr>
	</tr>
</table>


<br/>
<br/>
<br/>
<br/>


</body>
</html>