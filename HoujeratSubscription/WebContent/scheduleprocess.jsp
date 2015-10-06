
<%@ page language="java"
	import="java.sql.*,
           javax.sql.*,
           javax.naming.*,
           java.io.*, 
           java.text.*"%>

<%!		// ******************** Tounicode function********************** // 

	public String tounicode(String message){
		String unicodeContent = "";
		try{
			int cc = 0;
			StringReader sr = new StringReader(message);
			while((cc= sr.read()) != -1){
				String hex = Integer.toHexString(cc);
				while(hex.length() < 4)
				hex = "0" + hex;
				unicodeContent = unicodeContent + hex;
			}
		}catch(Exception e){
					//error=e.getMessage();
		}		
		unicodeContent = unicodeContent.toUpperCase().substring(0);
		return unicodeContent;
	}
%>


<%
		
		
	  String sdate = request.getParameter("sdate");
	  String smonth = request.getParameter("smonth");
	  String syear = request.getParameter("syear");
	  String shour = request.getParameter("shour");
	  String sminute = request.getParameter("sminute");
	  String ssecond = request.getParameter("ssecond");
	  String scdate = syear+"-"+smonth+"-"+sdate+" "+shour+":"+sminute+":"+ssecond;

	  String fdate = request.getParameter("fdate");
	  String fmonth = request.getParameter("fmonth");
	  String fyear = request.getParameter("fyear");
	  String fhour = request.getParameter("fhour");
	  String fminute = request.getParameter("fminute");
	  String fsecond = request.getParameter("fsecond");
	  String fcdate = fyear+"-"+fmonth+"-"+fdate+" "+fhour+":"+fminute+":"+fsecond;

	  String rdate = request.getParameter("rdate");
	  String rmonth = request.getParameter("rmonth");
	  String ryear = request.getParameter("ryear");
	  String rhour = request.getParameter("rhour");
	  String rminute = request.getParameter("rminute");
	  String rsecond = request.getParameter("rsecond");
	  String rcdate = ryear+"-"+rmonth+"-"+rdate+" "+rhour+":"+rminute+":"+rsecond;

	  String tdate = request.getParameter("tdate");
	  String tmonth = request.getParameter("tmonth");
	  String tyear = request.getParameter("tyear");
	  String thour = request.getParameter("thour");
	  String tminute = request.getParameter("tminute");
	  String tsecond = request.getParameter("tsecond");
	  String tcdate = tyear+"-"+tmonth+"-"+tdate+" "+thour+":"+tminute+":"+tsecond;
	
	  String action = request.getParameter("action");

		String rtime = rhour+":"+rminute+":"+rsecond;

		String Cid = request.getParameter("Cid");
		String schContent =new String(request.getParameter("schContent").trim().getBytes("Cp1252"),"Cp1256");
		String id = request.getParameter("id");
		
		String loginname;
		loginname=(String) session.getAttribute("logname");
		if(loginname == null) {
			System.out.println("session is null for loginname so taking from request");
			loginname = request.getParameter("loginname");
		}
	
	PreparedStatement pstmt=null;
	Connection con=null;
   	DataSource ds=null;
	
	try{
	
		InitialContext context = new InitialContext();
	    ds = (DataSource)context.lookup("java:HoujeratSubscription");
		con = ds.getConnection();	

		if (action.equals("addschedule")){
				pstmt = con.prepareStatement("insert into SubsSchedule (Cid, ScheduleTime, ScheduleContent, ScheduleStatus, ModifiedDate,username) values (?,?,?,0,getdate(),?)");
				pstmt.setString(1,Cid);
				pstmt.setString(2,scdate);
				pstmt.setString(3,schContent);
				pstmt.setString(4,loginname);
				pstmt.execute();
				action="Scheduled for " +Cid ;
				pstmt.close();
				pstmt = null;
		}
		else if (action.equals("deleteschedule")){
				pstmt = con.prepareStatement("delete from SubsSchedule where id =?");
				pstmt.setInt(1,Integer.parseInt(id));
				pstmt.execute();
				action="SlNo "+id+" Schedule deleted ";	
				pstmt.close();
				pstmt = null;
			
		}

		else if (action.equals("schedulemodify")){
				pstmt = con.prepareStatement("update SubsSchedule set Cid=?,ScheduleTime=?, ScheduleContent=? where id =?");
				pstmt.setString(1,Cid);
				pstmt.setString(2,scdate);
				pstmt.setString(3,schContent);
				pstmt.setInt(4,Integer.parseInt(id));
				pstmt.execute();
				action=" Modified (Slno "+id+")";
				pstmt.close();
				pstmt = null;

		}

	}catch(SQLException exe){
	   	System.out.println("Could not execute.."+exe.getMessage());
    }catch(NamingException ne){
       	System.out.println("Naming exception occured..."+ne.getMessage());
    }finally{
    	try{    	
    		 if (pstmt != null){
                pstmt.close();
             }
             if (con != null){
                 con.close();
//                    log.info("Connection kept back into the pool.");
             }
    	}catch(Exception e){
    		pstmt = null;
    	
    	}
    }
    
%>

<p><font size="4"> <%=action%> </font></p>


