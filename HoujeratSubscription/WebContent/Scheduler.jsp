
<%@ page contentType="text/html;charset=UTF-8" language="java"
	import="java.sql.*,
            javax.sql.*,
            java.util.*,
            java.text.*,
            javax.naming.*,
            java.net.*,
            java.util.Date"%>
           
          
<%!	
public String convertDate(String dateString){
    	dateString=dateString.trim();
        String day="";
        String month="";
        String year="";
        int intDate=Integer.parseInt(dateString.substring(0,dateString.indexOf("/")));
        if(intDate<10) day="0"+intDate;
        else day=""+intDate;
        System.out.println("day : " + day);
        int intMonth=Integer.parseInt(dateString.substring(dateString.indexOf("/")+1,dateString.lastIndexOf("/")));
        if(intMonth<10) month="0"+intMonth;        
        else month=""+intMonth;
        System.out.println("month : " + month);
        year=dateString.substring(dateString.lastIndexOf("/")+1,dateString.lastIndexOf("/")+5);
        System.out.println("year : " + year);
        //String newDate =day+"-"+month+"-"+year;
        String newDate =year+"-"+month+"-"+day;
        return newDate;
   } 
   
%>     

<%
String stat = request.getParameter("status");
String sDate = request.getParameter("sDate");

String newDate = null;
String dateCondition=null;
String condition2=null;

int status =0;
String loginname;
loginname=(String) session.getAttribute("logname");
if(loginname == null) {
	System.out.println("session is null for loginname so taking from request");
	loginname = request.getParameter("loginname");
}
System.out.println("login name--"+loginname);

	/*if(sDate==null ||sDate.length()<5){
	  dateCondition="";
	  sDate="";	  
	}
	else{
		sDate=sDate.trim();
		String day="";
		String month="";
		String year="";
	    int intDate=Integer.parseInt(sDate.substring(0,2));
	    if(intDate<10) day="0"+intDate;
	    else day=""+intDate;
	    int intMonth=Integer.parseInt(sDate.substring(3,sDate.lastIndexOf("-")));
	    if(intMonth<10) month="0"+intMonth;
	    else month=""+intMonth;
	    year=sDate.substring(sDate.length()-4,sDate.length());
	    //newDate= day+"-"+month+"-"+year;
	    newDate= month+"-"+day+"-"+year;
	    dateCondition=" and  ScheduleTime >=convert(datetime,'"+newDate+"')";
	    
	}*/
	if(sDate==null ||sDate.length()<5){
		  dateCondition="";
		  sDate="";
		  DateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
		  Date now = new Date();
		  sDate = dateFormat.format(now);
	} else{
		System.out.println("sDate : " +  sDate);
		sDate=sDate.trim();	
		if(sDate.length() > 10) {
			sDate = convertDate(sDate);
		}
	    dateCondition=" and  ScheduleTime >='"+sDate+"'";
	    System.out.println("sDate : " +  sDate);
	}
	

if(stat==null)
{
	stat="0";
	
}
	status=Integer.parseInt(stat);
	if(status==3)
		condition2=" where ScheduleStatus in (0,1,2) ";
	else
		condition2=" where ScheduleStatus="+status;
		
%>

<html>
<head>
<title>HoujeratSubscription</title>
<link rel="stylesheet" type="text/css" href="mobilinkStyles.css">
<script language="javascript" type="text/javascript" src="datetimepicker.js">
function submit()
{
	document.schedule.submit();
}

</script>
</head>
<body>
<form name=schedule>
<table width="90%" border="0" cellspacing="1" cellpadding="0"
	style="border-collapse: collapse">
	<tr class="H1">
		<td>Schedules</td>
	</tr>
	<tr class="H2">
		<td width="5%"><font size="4" color="#3366FF"><b><i>SlNo</i></b></font></td>
		<td width="5%"><font size="4" color="#3366FF"><b><i>Contest Id</i></b></font></td>

   <td width="31%"><i><b><font size="4" color="#3366FF">Schedule Date
	<input type="text" id="sDate" name="sDate" value='<%=sDate%>' size="10" readonly>
	  <a href="javascript:NewCal('sDate','ddmmyyyy',true,24)">
	  <img src="cal.gif" width="16" height="16" border="0" alt="Pick a date"></a>
	  <input type="submit" value="Submit" name="Search"> 
     </font></b></i></td>
    <td width="15%"><font size="4" color="#3366FF"><b><i></i></b></font><font color="#3366FF">
    <select size="1" name="status" onChange="submit()">
    <option value=3  <% if(status==3) { %> selected <% } %> >ALL</option>
    <option value=2  <% if(status==2) { %> selected <% } %> >Processed</option>
    <option value=1  <% if(status==1) { %> selected <% } %> >Processing</option>
    <option value=0  <% if(status==0) { %> selected <% } %> >Not Processed</option>
    </select ><font size="4"><b><i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </i></b></font></font><font color="#3366FF"></td>
	<td width="50%"><font size="4" color="#3366FF"><b><i>Scheduled Contents</i></b></font></td>
	 <%
  if(loginname.equals("alain")){
	  %>
	  <td width="10%"><a class="sublinks2" 
			href="Scheduler.jsp?loginname=<%=loginname%>">Refresh</a></td>
	<%   
  }
  else
  {
	 %>
	  <td width="10%"><font  color="#3366FF">&nbsp;</font></td>
	<%   
  }
  %> 
	</tr>

	<%
	
	Connection con=null;
   	DataSource ds=null;
   	PreparedStatement pstmt1=null;
   	ResultSet rs1=null;
   	
   	String id=null;
	String Cid=null;
	String stime=null;
    String schContent=null;
    String schstatus = null;
    String userName = "";
    
try{
	InitialContext context = new InitialContext();
    ds = (DataSource)context.lookup("java:HoujeratSubscription");
	con = ds.getConnection();		
	String sql="select id,Cid,ScheduleTime, CASE ScheduleStatus WHEN '0' THEN 'Not Processed' WHEN '1' THEN 'Processing' WHEN '2' THEN 'Processed' end,ScheduleContent,username from SubsSchedule ";
	sql=sql+condition2+ dateCondition;
	sql=sql+" order by ScheduleTime ";
	System.out.println("sql : " + sql);
	pstmt1 = con.prepareStatement(sql);
	rs1 = pstmt1.executeQuery();

	
	while(rs1.next())
	{
		id=rs1.getString(1);
		Cid=rs1.getString(2).trim();
		stime=rs1.getString(3);
		schstatus=rs1.getString(4).trim();
		schContent=rs1.getString(5).trim();
		userName = rs1.getString(6).trim();
		
		if(userName.equals("alain") && !loginname.equals("alain")){
			continue;
		}
		else
		{
		
	%>
  <TR class="content">
	<td width="5%"><font color="#3366FF"><a class="sublinks" target="I1"  href='schedulemodify.jsp?id=<%=id%>&loginname=<%=loginname%>&Cid=<%=Cid%>&stime=<%=stime%>&schContent=<%=java.net.URLEncoder.encode(schContent,"windows-1256") %>' > <%=id%></a>  </font></td>
    <td width="5%"><font color="#3366FF"><%=Cid%>&nbsp;</font></td>
    <td width="31%"><font color="#3366FF"><%=stime%>&nbsp;</font></td>
   <td width="15%"><font  color="#3366FF"><%=rs1.getString(4)%>&nbsp;</font></td>
   <td width="50%"><font  color="#3366FF"><%=schContent%>&nbsp;</font></td>
  <%
  if( loginname.equals("alain")){
	  %>
	  <td width="10%"><font  color="#3366FF"><a class="sublinks" target="I1"
			href="scheduledelete.jsp?id=<%= id %>">Delete</a></font></td>
	<%   
  }
  else
  {
	 %>
	  <td width="10%"><font  color="#3366FF">&nbsp;</font></td>
	<%   
  }
  %> 
 
   
 </tr>
	<%
		}
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
<input type="hidden" name="loginname" value="<%=loginname%>">
<table width="100%">
	<tr>
		<td width="10%" align="left"><a class="sublinks" target="I1"
			href="schedulemodify.jsp?loginname=<%=loginname%>">Add</a></td>
		
		<td width="70%" align="left"><a class="sublinks" href="Scheduler.jsp?loginname=<%=loginname%>">Refresh</a>
		</td>
	</tr>
</table>
<p><iframe name="I1" width="570" height="318" border="0" frameborder="0">
Your browser does not support inline frames or is currently configured
not to display inline frames. </iframe></p>
</form>
</body>

</html>
