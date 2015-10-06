 <%@ page contentType="text/html;charset=UTF-8" language="java"
	import="java.sql.*,
           javax.sql.*,
           javax.naming.*,
           java.io.*, 
           java.text.*"%>

<%!			// ******************** Tounicode function********************** // 
 
			public String tounicode(String message)	{
				String unicodeContent = "";
				try	{
					int cc = 0;
					StringReader sr = new StringReader(message);
					while((cc= sr.read()) != -1){
						String hex = Integer.toHexString(cc);
						while(hex.length() < 4)
						hex = "0" + hex;
						unicodeContent = unicodeContent + hex;
					}
				}
				catch(Exception e){
					//error=e.getMessage();
				}		
				unicodeContent = unicodeContent.toUpperCase().substring(0);
				return unicodeContent;
			}
			
%>

<%
			// ***************************** Declaring and initialising variables ***********************//	
			
			String strMessage =new String(request.getParameter("mesg").trim().getBytes("Cp1252"),"Cp1256");
			String strMessageId =new String(request.getParameter("id"));		
			String strAction = request.getParameter("action");
			String strContest = request.getParameter("contest");
			String unicodeContent = "";
			String unicodeMesg = "";
			String error="";
			String strMsgDesc = request.getParameter("Description");
			String strType = request.getParameter("type");
  
			  PreparedStatement pstmt=null;	 
			  
				//********************** Establising the Connection ****************************//
			Connection con=null;
		   	DataSource ds=null;				
			try{			
					if (!(strMessage==null)){
						int cc = 0;
						StringReader sr = new StringReader(strMessage);
						while((cc= sr.read()) != -1){
							String hex = Integer.toHexString(cc);
							while(hex.length() < 4)
								hex = "0" + hex;
							unicodeContent = unicodeContent + hex;
							}
						unicodeContent = unicodeContent.toUpperCase().substring(0);
						}

			
				InitialContext context = new InitialContext();
			    ds = (DataSource)context.lookup("java:HoujeratSubscription");
				con = ds.getConnection();
				if (strAction.equals("deleteMessage")){
						pstmt = con.prepareStatement("delete from message where id=?");
						pstmt.setString(1,strMessageId);
						pstmt.executeUpdate();
						strAction="Successfully Deleted Messages ";
						pstmt.close();
						pstmt = null;
				}

				else if (strAction.equals("addMessage")){
						pstmt = con.prepareStatement("insert into message(message, unicode, type, Description, Cid) values (?,?,?,?,?)");
						pstmt.setString(1,strMessage);
						pstmt.setString(2,unicodeContent);
						pstmt.setString(3,strType);
						pstmt.setString(4,strMsgDesc);
						pstmt.setString(5,strContest);
						pstmt.execute();
						strAction="Successfully Inserted Message ";
						pstmt.close();
						pstmt = null;
				}							
				else if (strAction.equals("modifyMessage"))
				{
						pstmt = con.prepareStatement("update message set message=?, unicode=?, description=?, type=?, Cid=? where id=?");
						pstmt.setString(1,strMessage);
						pstmt.setString(2,unicodeContent);
						pstmt.setString(3,strMsgDesc);
						pstmt.setString(4,strType);
						pstmt.setString(5,strContest);
						pstmt.setString(6,strMessageId);
						pstmt.executeUpdate();
						strAction="Successfully Modified Message";
						pstmt.close();
						pstmt = null;
				}
			}catch(SQLException S){
        	strAction="Error insering data. Probably duplicate entry of level and Quesno"+S;  	
   		} 
	    catch(Exception ne){
        	strAction="Some Error occured."+ne;  	
    	}finally{
    			try{
    	   			if (pstmt != null){
		                pstmt.close();
        		     }
		             if (con != null){
        		         con.close();// log.info("Connection kept back into the pool.");
        		         con=null;
             	}
    			}catch(Exception e){
    				pstmt = null;
    			}
    	}
    

%>
<p><font size="4"><%=strAction%> </font></p>