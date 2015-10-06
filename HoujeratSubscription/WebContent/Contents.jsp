<%@ page contentType="text/html;charset=UTF-8" language="java"
	import="java.sql.*, javax.sql.*, javax.naming.*, java.util.*"%>

<html>
<head>
<title>File Contents</title>
<link rel="stylesheet" type="text/css" href="mobilinkStyles.css">
<SCRIPT>
function submit()
{
	document.schedule.submit();
}
</SCRIPT>
</head>
<body>
<form name=schedule>
<% 

String ContestId = request.getParameter("ContestId");
String CategoryName = null;
int gp=0;
String condition="";
String loginname;
loginname=(String) session.getAttribute("logname");
if(loginname == null) {
	System.out.println("session is null for loginname so taking from request");
	loginname = request.getParameter("loginname");
}
System.out.println("login name--"+loginname);

if(ContestId!=null)
{
	gp=Integer.parseInt(ContestId);
	if(gp==0)
		condition="";
	else
		condition=" and contest.Cid='"+gp+"'";
}
 %>
<table width="100%" border="0" cellspacing="1" cellpadding="0"
	style="border-collapse: collapse">
	<tr class="H1">
		<td colspan="4">File Contents List</td>
	</tr>
	<tr class="H2">
		<td width="15%">ContentID</td>
		<td width="20%">FileName</td>
		<td width="40%">ContentURL</td>
		<td width="25%">
		<select size="1" name="ContestId" onChange="submit()">
			<option value="0" <% if(gp==0) { %> selected <% } %>>ALL</option>
			<option value="1" <% if(gp==1) { %> selected <% } %>>SMS Content</option>
			<option value="12" <% if(gp==2) { %> selected <% } %>>MMS Content</option>
			<option value="13" <% if(gp==3) { %> selected <% } %>>MMS Content</option>
		</select></td>
		<%
  if( loginname.equals("baher")){
	  %>
	  <td width="10%"><a class="sublinks2" 
			href="Contents.jsp?loginname=<%=loginname%>">Refresh</a></td>
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
	ArrayList ContestIdList =new ArrayList();
	ArrayList ContestNameList =new ArrayList();
	
	Connection con=null;
   	DataSource ds=null;
   	PreparedStatement pstmt1=null;
   	ResultSet rs1=null;
	try{
		String ContentId = null;
		String FileName = null;
		String contestname = null;
		String cid = null;
		String ContentURL = null;
		InitialContext context = new InitialContext();
	    ds = (DataSource)context.lookup("java:HoujeratSubscription");
		con = ds.getConnection();
		
		pstmt1 = con.prepareStatement("select Cid, ContestName from Contest order by Cid");
		ResultSet rs = pstmt1.executeQuery();
		String act;
		while(rs.next()){
		 ContestIdList.add(rs.getString(1));
		 ContestNameList.add(rs.getString(2));
		}
		rs.close();
		rs = null;
		pstmt1.close();
		pstmt1 = null;
		
		
		pstmt1 = con.prepareStatement("select contentURL.ContentId, contentURL.FileName, contest.ContestName, contest.cid, contentURL.ContentURL from ContentURL contentURL, contest contest where contentURL.cid = contest.cid" + condition + " order by contentURL.ContentId ");
		rs1 = pstmt1.executeQuery();
		
		while(rs1.next())
		{
			ContentId=rs1.getString(1).trim();
			FileName=rs1.getString(2).trim();
			contestname=rs1.getString(3).trim();
			cid = rs1.getString(4).trim();
			ContentURL = rs1.getString(5).trim();
%>
	<tr class="content">
		<td width="25%"><%= ContentId%></td>
		<td width="25%"><%= FileName%></td>
		<td width="25%"><%= ContentURL%></td>
		<td width="50%"><%= contestname%></td>
		<%
  if(  loginname.equals("baher")){
	  %>
	  <td width="10%"><font  color="#3366FF"><a class="sublinks" target="I1"
			href="ContentDelete.jsp?ContentId=<%= ContentId %>">Delete</a></font></td>
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
		%>
	<tr>
		<td width="10%" align="left"><a class="sublinks" target="I1"
			href='ContentsAdd.jsp'>Add</a></td>
		<td width="70%" align="left"><a class="sublinks" href="Contents.jsp?loginname=<%=loginname%>">Refresh</a>
		</td>
	</tr>
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
</table>

<p><iframe name="I1" width="570" height="318" border="0" frameborder="0">
Your browser does not support inline frames or is currently configured
not to display inline frames. </iframe></p>
</body>
</html>
