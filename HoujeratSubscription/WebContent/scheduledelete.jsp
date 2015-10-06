
<%@ page language="java" contentType="text/html;charset=windows-1256"
	import="java.util.*,java.sql.*,
            javax.sql.*,
            javax.naming.*"%>

<%
	String id = "";
	id = request.getParameter("id");
	PreparedStatement pstmt=null;
	Connection con=null;
   	DataSource ds=null;
   	
	if(id != null)
	{
		try{
			
			InitialContext context = new InitialContext();
		    ds = (DataSource)context.lookup("java:HoujeratSubscription");
			con = ds.getConnection();
			pstmt = con.prepareStatement("delete from subsschedule where id = ?");
			pstmt.setString(1,id);			
			pstmt.execute();			
			pstmt.close();
			pstmt = null;
			con.close();
			con = null;
		
		}catch(SQLException exe){
		   	System.out.println("Could not execute.."+exe.getMessage());
	    }catch(NamingException ne){
	       	System.out.println("Naming exception occured..."+ne.getMessage());
	    }
	    finally{
	    	try{    	
	    		 if (pstmt != null){
	                pstmt.close();
	             }
	             if (con != null){
	                 con.close();
//	                    log.info("Connection kept back into the pool.");
	             }
	    	}catch(Exception e){
	    		pstmt = null;
	    	
	    	}
	    }
		
	}
	


%>

