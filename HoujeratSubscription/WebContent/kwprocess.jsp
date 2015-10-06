
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
	String op = request.getParameter("op");
	String old = request.getParameter("old");
	String cid = request.getParameter("contest");
	if(cid.equals("6"))
		cid = "99";
	
	String oldkeyword = request.getParameter("oldkeyword");
	String keyword =new String(request.getParameter("keyword").trim().getBytes("Cp1252"),"Cp1256");
	String id = request.getParameter("id");
	String strKeywordType = request.getParameter("keywordtype");
	
	System.out.println("Keyword: " + keyword + " Keyword Type: " + strKeywordType); 

	//response.setContentType("charset=windows-1256");
	String action="";
	PreparedStatement pstmt=null;
	Connection con=null;
   	DataSource ds=null;
	try{
	
		InitialContext context = new InitialContext();
	    ds = (DataSource)context.lookup("java:HoujeratSubscription");
		con = ds.getConnection();			
		String error="";

		if (op.equals("addkeyword")){	
			System.out.println(" In add keyword" +  keyword + " " + cid + " " + strKeywordType);		
			pstmt = con.prepareStatement("insert into keyword (keyword,cid,type)values (?,?,?)");
			pstmt.setString(1,keyword);
			pstmt.setString(2,cid);
			if("S".equals(strKeywordType))
			{
				pstmt.setString(3,strKeywordType);
			}
			else
			{
				pstmt.setString(3,strKeywordType);
			}
			pstmt.execute();
			action="Successfully Inserted Keyword";
			System.out.println("completed");
		}
		else if(op.equals("modifykeyword")){
			System.out.println(" In modify keyword" +  keyword + " " + cid + " " + old + " " + strKeywordType);
			pstmt = con.prepareStatement("update keyword set keyword=?,cid=? where id=? and type = ?");
			pstmt.setString(1,keyword);
			pstmt.setString(2,cid);
			pstmt.setString(3,old);	
			if("S".equals(strKeywordType))
			{
				pstmt.setString(4,strKeywordType);
			}
			else
			{
				pstmt.setString(4,strKeywordType);
			}		
			pstmt.execute();
			action="Successfully Updated the Selected Keyword";
		}
		if (op.equals("deletekeyword")){
			System.out.println(" In delete keyword" +  keyword + " " + strKeywordType);
			pstmt = con.prepareStatement("delete from keyword where keyword=? and type = ?");
			pstmt.setString(1,keyword);
			if("S".equals(strKeywordType))
			{
				pstmt.setString(2,strKeywordType);
			}
			else
			{
				pstmt.setString(2,strKeywordType);
			}
			pstmt.executeUpdate();
			action="Successfully Deleted the Selected keyword";
			System.out.println("completed");
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


