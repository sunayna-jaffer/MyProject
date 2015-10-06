
<%@ page language="java" contentType="text/html;charset=windows-1256"
	import="java.util.*,java.sql.*,
            javax.sql.*,
            javax.naming.*"%>

<%
    

    String schContent=null;    
	String id=request.getParameter("id");
	String stime=null;
	String Cid=null;

	StringTokenizer st = null;
	String fromDy = null;
	String fromMth = null;
	String fromYr = null;
	String fromHr = null;
	String fromMin = null;
	String fromSec = null;
	
	String fromdate = null;
	String fromtime = null;
	String todate = null;
	String totime = null;
		
	String toDy = null;
	String toMth = null;
	String toYr = null;
	String toHr = null;
	String toMin = null;
	String toSec = null;
	
	String fromDt = null;
	String toDt = null;
	
	String loginname;
	loginname=(String) session.getAttribute("logname");
	if(loginname == null) {
		System.out.println("session is null for loginname so taking from request");
		loginname = request.getParameter("loginname");
	}
	System.out.println("login name--"+loginname);
	
	if(id!=null)
	{
	    schContent = new String(request.getParameter("schContent").trim().getBytes("Cp1252"),"Cp1256");
		Cid=request.getParameter("Cid");
		stime=request.getParameter("stime");	
		
		
		toDt = java.net.URLDecoder.decode(request.getParameter("stime"));
		
		st = new StringTokenizer(toDt," ");
			
		if (st.hasMoreElements())
			fromdate = (String)st.nextElement();
		if (st.hasMoreElements())
			fromtime = (String)st.nextElement();
			
		st = new StringTokenizer(fromdate,"-");
		if (st.hasMoreElements())
			fromYr = (String)st.nextElement();
		if (st.hasMoreElements())
			fromMth = (String)st.nextElement();
		if (st.hasMoreElements())
			fromDy = (String)st.nextElement();
		
		st = new StringTokenizer(fromtime,":");
		if (st.hasMoreElements())
			fromHr = (String)st.nextElement();
		if (st.hasMoreElements())
			fromMin = (String)st.nextElement();
		if (st.hasMoreElements())
			fromSec = (String)st.nextElement();
			
		st = new StringTokenizer(fromSec,".");
		if (st.hasMoreElements())
			fromSec = (String)st.nextElement();				

		st = new StringTokenizer(toDt," ");
		if (st.hasMoreElements())
			todate = (String)st.nextElement();
		if (st.hasMoreElements())
			totime = (String)st.nextElement();		

		st = new StringTokenizer(todate,"-");
		if (st.hasMoreElements())
			toYr = (String)st.nextElement();
		if (st.hasMoreElements())
			toMth = (String)st.nextElement();
		if (st.hasMoreElements())
			toDy = (String)st.nextElement();
		
		st = new StringTokenizer(totime,":");
		if (st.hasMoreElements())
			toHr = (String)st.nextElement();
		if (st.hasMoreElements())
			toMin = (String)st.nextElement();
		if (st.hasMoreElements())
			toSec = (String)st.nextElement();	
			
		st = new StringTokenizer(toSec,".");
		if (st.hasMoreElements())
			toSec = (String)st.nextElement();
			
	}
	
	String action = null;
	String label = null;
	Vector cid = new Vector();
	Vector ContestName = new Vector();
	PreparedStatement pstmt=null;
	Connection con=null;
   	DataSource ds=null;
	
	InitialContext context = new InitialContext();
    ds = (DataSource)context.lookup("java:HoujeratSubscription");
	con = ds.getConnection();
	pstmt = con.prepareStatement("SELECT Cid,ContestName FROM Contest ORDER BY Cid");
	ResultSet rs = pstmt.executeQuery();
	while(rs.next()){
	cid.add(rs.getString(1));
	ContestName.add(rs.getString(2));
		}
	rs.close();
	rs = null;
	pstmt.close();
	pstmt = null;
	con.close();
	con=null;
		

   	if(id==null)
	{	
		id = "";
		schContent = "";
		action="addschedule";
		label="Add Schedule";
	
	}	
	else
	{
	
		action="schedulemodify";
		label="Modify Schedule";
		
	}

%>

<html>

<script language="JavaScript">
	var maxCount = 250; 
       
    function displayBalanceChars(){
		var len = document.msg.schContent.value.length;
		document.msg.count.value = maxCount - len;
		document.msg.schContent.focus(); 
	}
		 
	function setFocus(){
		document.msg.schContent.focus(); 
	}
	
	function setTextArea(val){
		document.msg.schContent.value = document.all[val].value;
		displayBalanceChars();
	}
</script>
<head>
<title>Add Schedule for HoujeratSubscription</title>
</head>
<body>
<%
	      Calendar calendar = new GregorianCalendar(new Locale("ar","KW"));
	      int date = calendar.get(Calendar.DAY_OF_MONTH);
	      int month = calendar.get(Calendar.MONTH) + 1; //Month index starts with 0
	      int year = calendar.get(Calendar.YEAR);
	      int yearRange = 2;
	      Hashtable data = null;   
	      data = new Hashtable();
%>

<form method="POST" action=scheduleprocess.jsp  name="msg">
<table border="1" cellspacing="0" width="100%" id="AutoNumber1" height="52" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0">

<tr>
    <td width="18%" height="25"><font color="#3366FF">SlNo</font></td>
    <td width="132%" height="25"><font color="#3366FF"><input type="text" name="id" size="20" readonly value=<%=id%>></font></td>
</tr>

<tr>
    <td width="25%" height="25"><font color="#3366FF">Group</font></td>
    <td width="132%" height="25">

  <font color="#3366FF">

<select size="1" name="Cid" selected>
<%
	for(int i=0;i<ContestName.size();i++){
		if(cid.get(i).equals(Cid)){
	%>
			  <option value="<%=cid.get(i)%>" selected><%=ContestName.get(i)%></option>
	<%}else{ %>		  
	          <option value="<%=cid.get(i)%>"><%=ContestName.get(i)%></option>
		  
	<%
		}
		}
%>
</select>
</tr>

<tr>
		<td width="373" height="33"><font color="#3366FF">Schedule Date</font></td>
		<td width="939" height="33"><font color="#FF0000"> <select
			name="sdate">
			<%
//To 
     for(int i = 1;i <= 31;i++){
 	     String j = "0";
		 if(i < 10)j=j+i;
		 else 
		      j = ""+i;
		 j = j.trim();	  

		if (toDy != null)
			 date = Integer.parseInt(toDy);
			 
	     if(i == date){
%>
			<option value="<%=j%>" selected><%=j%> <%				  
         }else{
%>
			<option value="<%=j%>"><%=j%> <%			   
		 }		 
	 }	
%>
		</select> <strong><font size="+2 "><b>/</b></font></strong> </font> <font
			color="#FF0000"> <select name="smonth">
			<%
     for(int i = 1;i <= 12;i++){
 	     String j = "0";
		 if(i < 10)j=j+i;
		 else 
		      j = ""+i;
		 j = j.trim();	  

		if (toMth != null)
			 month = Integer.parseInt(toMth);
			 
	     if(i == month){
%>
			<option value="<%=j%>" selected><%=j%> <%				  
         }else{
%>
			<option value="<%=j%>"><%=j%> <%			   
		 }		 
	 }	
%>
		</select> <strong><font size="+2 "><b>/</b></font></strong> <select
			name="syear">
			<%
     for(int i = year - yearRange;i <= year + yearRange;i++){
     
		if (toYr != null)
			 year = Integer.parseInt(toYr);
			      
	     if(i == year){
%>
			<option value="<%=i%>" selected><%=i%> <%
         }else{
%>
			<option value="<%=i%>"><%=i%> <%			   
		 }		 
	 }	
//End of To	 
%>
		</select> &nbsp;&nbsp;&nbsp; <select name="shour">
			<%

//From 

     for(int i = 0;i <= 23;i++){
	     String j = "0";
		 if(i < 10)
		    j=j+i;
		 else 
		      j = ""+i;
		 j = j.trim();	  
%>
			<option value="<%=j%>" <% if (j.equals(toHr)) { %> selected <% } %>><%=j%>
			<%			   
	 }	
%>
		</select> <strong><font size="+2 "><b>:</b></font></strong> <select
			name="sminute">
			<%
     for(int i = 0;i <= 59;i++){
 	     String j = "0";
		 if(i < 10)
		    j=j+i;
		 else 
		      j = ""+i;
		 j = j.trim();	  

%>
			<option value="<%=j%>" <% if (j.equals(toMin)) { %> selected <% } %>><%=j%>
			<%			   
	 }	
%>
		</select> <strong><font size="+2 "><b>:</b></font></strong> <select
			name="ssecond">
			<%
     for(int i = 0;i <= 59;i++){
	 	     String j = "0";
		 if(i < 10)j=j+i;
		 else 
		      j = ""+i;
		 j = j.trim();	  
%>
			<option value="<%=j%>" <% if (j.equals(toSec)) { %> selected <% } %>><%=j%>
			<%			   
	 }	
//End od From	 
%>
</tr>

 	<tr>
		<td width="25%" height="105" valign="top"><b><font color="#3366FF">Scheduled Content</font></b></td>
		<td width="65%" height="105"><font color="#3366FF"><b> <textarea
			rows="7" name="schContent" cols="50" dir="rtl"
			onkeypress="displayBalanceChars();"
			onkeydown="displayBalanceChars();" onchange="displayBalanceChars();"
			onkeyup="displayBalanceChars();"><%=schContent%></textarea></b></font></td>
	</tr>
	

	<tr>
		<td width="25%" height="22">&nbsp;</td>
		<td width="65%" height="22"><font color="#FF6600"><b> <input
			type="text" name="count" size="5" value=250 readonly></b></font></td>
	</tr>
	
  <tr>
<font color="#3366FF">
<input type="hidden" name="action" size="20" value=<%=action%>>
<input type="hidden" name="loginname" size="20" value=<%=loginname%>>
<input type="hidden" name="id" size="20" value=<%=id%>>
    </font>
    <td width="18%" height="47">
    <font color="#3366FF">

    <input type="submit" value="Submit" name="B1" style="float: right"></font></td>
    <td width="82%" height="47">
  <font color="#3366FF">
  <input type="reset" value="Reset" name="B2"></font></td>
  </tr>
  </table>
</form>
</body>
</html>
