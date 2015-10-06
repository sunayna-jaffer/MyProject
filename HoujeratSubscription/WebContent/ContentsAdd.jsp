
<%@ page language="java" contentType="text/html;charset=windows-1256"
	import="java.util.*,java.sql.*,
            javax.sql.*,
            javax.naming.*"%>

<%
	String ContentId = request.getParameter("ContentId");
	String FileName = request.getParameter("FileName");
	String cid = request.getParameter("ContestId");
	String FilePath = "";
	String action = null;
	String label = null;


	FileName="";
	ContentId = "";
	action="addContent";
	label="Add Content";

%>

<html>
<head>
<title>Add Contents</title>
<script language="JavaScript">
</script>
</head>
<body>

<form method="POST" action="ContentsProcess.jsp" name="msg" ENCTYPE="multipart/form-data">
	<input type="hidden" name="op" size="20" value=<%=action%>> 
	<input type="hidden" name="old"	size="20" value=<%=ContentId%>>
	<input type="hidden" name="cid"	size="20" value=<%=cid%>>
	<%

	if("addContent".equals(action))
	{
		Connection con=null;
	   	DataSource ds=null;
	   	PreparedStatement pstmt1=null;
	   	ResultSet rs1=null;
	   	Vector contsts = new Vector();
		try
		{
			InitialContext context = new InitialContext();
		    ds = (DataSource)context.lookup("java:HoujeratSubscription");
			con = ds.getConnection();
			pstmt1 = con.prepareStatement("select ContestName from Contest");
			rs1 = pstmt1.executeQuery();
			while(rs1.next()){
				contsts.add(rs1.getString(1).trim());
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
	   }
	      %>

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
			  int inc=1;
			  Iterator it = contsts.iterator ();
			  while (it.hasNext ()) {
			    String contst = (String) it.next ();
			%>
			<option value="<%=inc%>"
			<% if  (cid != null) {
	        if ((Integer.parseInt(cid.trim()))==inc){ %> 
	        selected 
	        <% }} %>> <%=contst%></option>
			<%
	          inc++;
	        }
	        %>
			</select>
		</td>
	</tr>
	<tr>
		<td width="35%"><font color="#0000FF"><b> Country </b></td>
		<td width="35%">
			<select size="1" name="Country" onchange="refresh()">
				<option value="1" selected> Iraq </option>
			</select>
		</td>
	</tr>
	<tr>
		<td width="25%"><b><font color="#0000FF">Enter the ContentId </font></b></td>
		<td width="35%"><input type="text" name="ContentId1" size="20" value=<%=ContentId%>> <b></td>
	</tr>

	<tr>
		<td width="25%"><b><font color="#0000FF">File 1: </font></b></td>
		<td width="35%"><input type="file" name="File1" size="50"> <b></td>
	</tr>
	
	<tr>
		<td width="25%"><b><font color="#0000FF">Enter the ContentId </font></b></td>
		<td width="35%"><input type="text" name="ContentId2" size="20" value=<%=ContentId%>> <b></td>
	</tr>
	
	<tr>
		<td width="25%"><b><font color="#0000FF">File 2: </font></b></td>
		<td width="35%"><input type="file" name="File2" size="50"> <b></td>
	</tr>
	
	<tr>
		<td width="25%"><b><font color="#0000FF">Enter the ContentId </font></b></td>
		<td width="35%"><input type="text" name="ContentId3" size="20" value=<%=ContentId%>> <b></td>
	</tr>
	
	<tr>
		<td width="25%"><b><font color="#0000FF">File 3: </font></b></td>
		<td width="35%"><input type="file" name="File3" size="50"> <b></td>
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
<%}%>
<p>&nbsp;</p>
</form>
</body>
</html>
