
<%@ page language="java" contentType="text/html;charset=windows-1256"
	import="java.util.*,java.sql.*,
            javax.sql.*,
            javax.naming.*"%>

<%
	String keyword = request.getParameter("keyword");
	String kwid = request.getParameter("kwid");
	String cid = request.getParameter("cid");
	String action = request.getParameter("action");
	String strKeywordType = request.getParameter("keywordtype");
	String contestname = request.getParameter("contestname");
	String label;

	if(!(kwid==null))
	{
		keyword = new String(request.getParameter("keyword").trim().getBytes("Cp1252"),"Cp1256");
		cid = new String(request.getParameter("cid").trim().getBytes("Cp1252"),"Cp1256");

		action="deletekeyword";
		label="Delete Keyword";
	}
	else
	{
		kwid="";
		action="addkeyword";
		label="Add Keyword";
	}

%>

<html>
<head>
<title>KeyWord Delete</title>
</head>
<body>

<form method="POST" action="kwprocess.jsp"><input type="hidden"
	name="op" size="20" value=<%=action%>> <input type="hidden" name="old"
	size="20" value=<%=kwid%>>
	<input type="hidden" name="keywordtype"	size="20" value=<%=strKeywordType%>>
	 <%	Connection con=null;
	   	DataSource ds=null;
	   	PreparedStatement pstmt1=null;
	   	ResultSet rs1=null;
	   	Vector contsts = new Vector();
	   		Vector vCid = new Vector();
		try{
			InitialContext context = new InitialContext();
		    ds = (DataSource)context.lookup("java:HoujeratSubscription");
			con = ds.getConnection();
			pstmt1 = con.prepareStatement("select Contestname,Cid from contest");
			rs1 = pstmt1.executeQuery();
			while(rs1.next()){
				contsts.add(rs1.getString(1).trim());
				vCid.add(rs1.getString(2).trim());
			}
		}catch(SQLException exe){
		   	System.out.println("Could not execute.."+exe.getMessage());
	    }catch(NamingException ne){
		   	System.out.println("Naming exception occured..."+ne.getMessage());
		}finally{
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
				rs1 = null;
				pstmt1 = null;
	   		}
	   }    %>

<table width="70%" border="0" bgcolor="#FFDD66" cellspacing="1"
	cellpadding="0" style="border-collapse: collapse">
	<tr>
		<td bgcolor="#FF9933" colspan=2>
		<p align="center"><b><font size="3" color="#0000FF"> <%=label%></font></b>
		</td>
	</tr>
	<tr>
		<td width="35%"><font color="#0000FF"><b> Contest</b></td>
		<td width="35%">
		<select size="1" name="contest" onchange="refresh()">
		<%
			for(int i=0;i<contsts.size();i++){
				if(vCid.get(i).equals(cid)){
			%>
					  <option value="<%=vCid.get(i)%>" selected><%=contsts.get(i)%></option>
			<%}else{ %>		  
			          <option value="<%=vCid.get(i)%>"><%=contsts.get(i)%></option>
				  
			<%
				}
				}
		%>
		</select>
	</td>
	</tr>
	<tr>
		<td width="35%"><font color="#0000FF"><b>Enter the Keyword </b></td>
		<td width="35%"><input type="text" name="keyword" size="20"
			value=<%=keyword%>> <b></td>
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
