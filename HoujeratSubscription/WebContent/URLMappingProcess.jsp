
<%@ page language="java"
	import="java.sql.*,
           javax.sql.*,
           javax.naming.*,
           java.io.*, 
           java.text.*"%>

<%!			// ******************** Tounicode function********************** // 

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
	String ShortCode = request.getParameter("ShortCode");
	String URL = request.getParameter("URL");	
	String ShortCodeType = request.getParameter("ShortCodeType");
	
	System.out.println("ShortCode: " + ShortCode + " URL: " + URL + " ShortCodeType: " + ShortCodeType);
	
	String action="";
	
	PreparedStatement pstmt=null;
	Connection con=null;
   	DataSource ds=null;
	try{
	
		InitialContext context = new InitialContext();
	    ds = (DataSource)context.lookup("java:HoujeratSubscription");
		con = ds.getConnection();			
		String error="";
		
		if(ShortCodeType.equals("C"))
		{
			URL = "http://192.168.1.221:8080/SMSGateway/SMSender?SrvcId=1457&OpCode=40&login=mtgapp&passwd=Mc3n00sjc8";
			ShortCode = "3574";
		}
		else if(ShortCodeType.equals("F"))
		{
			URL = "http://192.168.1.221:8080/SMSGateway/SMSender?SrvcId=1423&OpCode=40&login=mtgapp&passwd=Mc3n00sjc8";
			ShortCode = "MulaBasim";
		}
		
		pstmt = con.prepareStatement("update SC_URL_MAPPING set URL=?, ShortCode=?, ShortCodeType = ? where id=?");
		pstmt.setString(1,URL);
		pstmt.setString(2,ShortCode);
		pstmt.setString(3,ShortCodeType);
		pstmt.setString(4,id);
		
		pstmt.execute();
		action="Successfully Updated the MT URL";
	
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


