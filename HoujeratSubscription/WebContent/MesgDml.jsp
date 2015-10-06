<%@ page contentType="text/html;charset=windows-1256" language="java"
	import="java.sql.*,
   		   java.util.*,
   		   javax.sql.*,
   		   java.text.*,
   		   javax.naming.*"%>


<%

	String id = request.getParameter("id");
	//if ((request.getParameter("mesg"))!=null)
	String mesg = "";
	String desc = request.getParameter("desc");
	String type = request.getParameter("type");
	String cid = request.getParameter("cid");
	String action="";
	String DA="";
	
    Vector contsts = new Vector();
    Vector vCid = new Vector();
    
    Connection con=null;
  	DataSource ds=null;
   	PreparedStatement pstmt1=null;
   	ResultSet rs1=null;
   	HashMap contId = new HashMap();
	try{
		InitialContext context = new InitialContext();
	    ds = (DataSource)context.lookup("java:HoujeratSubscription");
   		con = ds.getConnection();		
		pstmt1 = con.prepareStatement("select Contestname, Cid from contest");
		rs1 = pstmt1.executeQuery();
		while(rs1.next()){
			contsts.add(rs1.getString(1).trim());
			vCid.add(rs1.getString(2).trim());
		}
	}catch(SQLException exe){
	   	System.out.println("Could not execute.."+exe.getMessage());
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
   
    String label;
	if (id==null){
		id="";
		mesg="";
		desc="";
		type="";
		action="addMessage";
		label="Add Message";
	}
	else{
		action="modifyMessage";
		label="Modify Message";
		mesg=new String(request.getParameter("mesg").trim().getBytes("Cp1252"),"Cp1256");
	}
 %>
<html>
<head>
<script language="JavaScript">
	var maxCount = 250; 
       
    function displayBalanceChars(){
		var len = document.msg.mesg.value.length;
		document.msg.count.value = maxCount - len;
		document.msg.mesg.focus(); 
	}
		 
	function setFocus(){
		document.msg.mesg.focus(); 
	}
	
	function setTextArea(val){
		document.msg.mesg.value = document.all[val].value;
		displayBalanceChars();
	}
</script>

<%
      Calendar calendar = new GregorianCalendar(new Locale("ar","KW"));
      int date = calendar.get(Calendar.DAY_OF_MONTH);
      int month = calendar.get(Calendar.MONTH) + 1; //Month index starts with 0
      int year = calendar.get(Calendar.YEAR);
      int yearRange = 2;
      Hashtable data = null;   
      data = new Hashtable();
      
	      %>

</head>
<body>
<form action="MessageProcess.jsp" method="Post" name="msg">
<table width="90%" border="0" bgcolor="#FFDD66" cellspacing="1"
	cellpadding="0" style="border-collapse: collapse">
	<tr>
		<td bgcolor="#FF9933" colspan=2>
		<p align="center"><b><font size="3" color="#0000FF"><%=label%>
		</td>
	</tr>
	<tr>
		<td width="25%" height="39"><font color="#0000FF"><b>Type</b></font></td>
		<td width="65%" height="39"><font color="#0000FF"><b> <input
			type="text" name="type" size="20" value="<%=type%>" ></b></font></td>
	</tr>
	<tr>
		<td width="25%" height="105" valign="top"><b><font color="#0000FF">Message&nbsp;&nbsp;
		</font></b></td>
		<td width="65%" height="105"><font color="#0000FF"><b> <textarea
			rows="7" name="mesg" cols="72" dir="rtl"
			onkeypress="displayBalanceChars();"
			onkeydown="displayBalanceChars();" onchange="displayBalanceChars();"
			onkeyup="displayBalanceChars();"><%=mesg%></textarea></b></font></td>
	</tr>
	<tr>
		<td width="25%" height="105" valign="top"><b><font color="#0000FF">Description&nbsp;&nbsp;
		</font></b></td>
		<td width="65%" height="105"><font color="#0000FF">
		<b>	<textarea rows="7" name="Description" cols="72" dir="rtl"><%=desc%></textarea></b></font></td>
	</tr>
	<input type="hidden" name="action" value=<%=action%>>
	<input type="hidden" name="id" value=<%=id%>>
	<tr>
		<td width="25%" height="22">&nbsp;</td>
		<td width="65%" height="22"><font color="#FF6600"><b> <input
			type="text" name="count" size="5" value=250 readonly></b></font></td>
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
</table>
<table width="90%" border="0" cellspacing="1" cellpadding="0"
	style="border-collapse: collapse">
	<tr>
		<td colspan=2>
		<p align="center"><input type="submit" value="Submit" name="Add"> <input
			type="reset" value="Reset" name="Clear"></p>
		</td>
	</tr>
</table>
</form>
</body>
</html>
