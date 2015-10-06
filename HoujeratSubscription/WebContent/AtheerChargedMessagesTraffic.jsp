<%@ page contentType="text/html;charset=UTF-8" language="java"
    import="java.util.*,
            java.sql.*,
            javax.sql.*,
            javax.naming.*,
            java.text.DateFormat,
            java.text.SimpleDateFormat,
            java.util.Date"%>

<html>
<head>
<title>HoujeratSubscription </title>
<link rel="stylesheet" type="text/css" href="mobilinkStyles.css">

<script language="javascript" type="text/javascript" src="datetimepicker.js">
</script>

</head>

<body>
<form method="Post" name="list" action="displayAtheerChargedMessagesTraffic.jsp" target="I1"><%
      Calendar calendar = new GregorianCalendar(new Locale("ar","KW"));
      int date = calendar.get(Calendar.DAY_OF_MONTH);
      int month = calendar.get(Calendar.MONTH) + 1; //Month index starts with 0
      int year = calendar.get(Calendar.YEAR);
      int yearRange = 2;
      Hashtable data = null;   
      data = new Hashtable();
      
      	String contest = request.getParameter("contest");
    	String time1=" 00:00:00";
	   	String time2=" 23:59:59";
	    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
		Date now = new Date();
		String dd1=dateFormat.format(now);
        String fdd1=dd1+time1;
	    String fdd2=dd1+time2;
	    
	    String loginname;
	    loginname=(String) session.getAttribute("logname");
	    if(loginname == null) {
	    	System.out.println("session is null for loginname so taking from request");
	    	loginname = request.getParameter("loginname");
	    }
	    System.out.println("login name--"+loginname);
  
%>
<table width="100%" border="0" cellspacing="1" cellpadding="0"
    style="border-collapse: collapse">
  <tr class="H1"> 
    <td colspan="4">Zain Iraq HoujeratSubscription (MT charged) </td>
  </tr>
  <tr class="content"> 
    <td  width="10%"><b>From Date</b></td>
    <td><input id="fromdate" name="fromdate" type="Text" size="25" value="<%=fdd1%>" readonly=true  >
		 <a href="javascript:NewCal('fromdate','mmddyyyy',true,24)">
		 <img src="cal.gif" width="16" height="16" border="0" alt="Pick a date"></a></td>
  
    <td  width="10%"><b>To Date</b></td>
     <td><input id="todate" name="todate" type="Text" size="25" value="<%=fdd2%>" readonly=true  >
		 <a href="javascript:NewCal('todate','mmddyyyy',true,24)">
		<img src="cal.gif" width="16" height="16" border="0" alt="Pick a date"></a></td>
  
  </tr>
  <tr class="content">
    <td  width="10%"><b>Contest</b></td>
    <td width="29%"><select name="contest">
        
     <%  
    Connection con=null;
    DataSource ds=null;
    PreparedStatement pstmt1=null;
    ResultSet rs1=null;
	String contestname = null;
	String cid = null;
    try{
        
        InitialContext context = new InitialContext();
        ds = (DataSource)context.lookup("java:HoujeratSubscription");
        con = ds.getConnection();       
        pstmt1 = con.prepareStatement("SELECT cid, contestname from contest(nolock) order by Cid");
        rs1 = pstmt1.executeQuery();
        
        
      %>
        <option value="all">All</option>
	<%        
        
        while(rs1.next())
        {
        	cid = rs1.getString(1);
            contestname=rs1.getString(2);
        %>
        <option value="<%=cid%>"><%=contestname%></option>
        <% }
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
      </select></td>
	      <td> </td>
	<td> </td>


	</tr>
 </table>
 <input type="hidden" name="username" value='<%=loginname%>' > </input>
<table width="100%" border="0" cellspacing="1" cellpadding="0"
    style="border-collapse: collapse">
    <tr>
        <td colspan=2>
        <p align="center"><input type="submit" value="Submit" name="B1"
            target="I1"> <input type="reset" value="Reset" name="B2"></p>
        </td>
    </tr>
</table>
<p><iframe name="I1" width="800" height="400" border="0" frameborder="0"
    > Your browser does not support inline frames or is
currently configured not to display inline frames. </iframe></p>
</body>
</html>
