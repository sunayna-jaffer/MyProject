
<%@ page language="java"
	import="java.sql.*,
           javax.sql.*,
           javax.naming.*,
           java.io.*, 
           java.text.*"%>

<%!	// ******************** To unicode function ********************** // 

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
	String id = request.getParameter("id");
	String cname = request.getParameter("cname");
	String cid = request.getParameter("cid");	
	String keywordcheckflag = request.getParameter("keywordcheckflag");
	
	System.out.println("cname: " + cname + " cid: " + cid + " keywordcheckflag: " + keywordcheckflag);
	
	String action="";
	
	PreparedStatement pstmt=null;
	Connection con=null;
   	DataSource ds=null;
	try{
	
		InitialContext context = new InitialContext();
	    ds = (DataSource)context.lookup("java:HoujeratSubscription");
		con = ds.getConnection();			
		String error="";
		
		pstmt = con.prepareStatement("update Contest set keywordcheckflag=? where id=?");
		pstmt.setString(1,keywordcheckflag);
		pstmt.setString(2,id);
		
		pstmt.execute();
		action="Successfully Updated the Selected Keyword Check Flag";
	
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


