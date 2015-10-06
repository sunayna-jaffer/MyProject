
<%@ page language="java"
	import="java.sql.*,
		   javax.sql.*,
           java.util.*,
           javax.naming.*,           
           org.apache.commons.fileupload.DiskFileUpload,
           org.apache.commons.fileupload.FileItem,
           org.apache.commons.fileupload.*,
           java.io.*"%>



<%
	String op = null;
	String cid = null;
	String ContentId = null;
	String FileName = null;
	String ContentURL = null;	
	String action="";
	String Country = null;
	
	int iCount = 0;
	
	PreparedStatement pstmt=null;
	Connection con=null;
   	DataSource ds=null;
	
    DiskFileUpload upload = new DiskFileUpload();
    
    // If file size exceeds, a FileUploadException will be thrown
    upload.setSizeMax(60000000);
	List items = null;
	File savedFile = null;
		   
   try {
	   items = upload.parseRequest(request);
   } catch (FileUploadException e) {
	   e.printStackTrace();
   }
   
   	try
   	{	
		InitialContext context = new InitialContext();
	    ds = (DataSource)context.lookup("java:HoujeratSubscription");
		con = ds.getConnection();		

	   Iterator itr = items.iterator();
	   while (itr.hasNext()) 
	   {
		   FileItem item = (FileItem) itr.next();
		   System.out.println("Item No: " + iCount++ );
		   
		   if (item.isFormField()) {
		   
		   	 String fieldName = item.getFieldName();
		   	 if("contest".equals(fieldName))
		   	 {
		   	 	cid = item.getString();
	    	 }
	    	 if("ContentId1".equals(fieldName))
		   	 {
		   	 	ContentId = item.getString();
	    	 }
	    	 if("ContentId2".equals(fieldName))
		   	 {
		   	 	ContentId = item.getString();
	    	 }
	    	 if("ContentId3".equals(fieldName))
		   	 {
		   	 	ContentId = item.getString();
	    	 }		
	   		 if("op".equals(fieldName))
		   	 {
		   	 	op = item.getString();
	    	 }
	    	 if("Country".equals(fieldName))
		   	 {
		   	 	Country = item.getString();
		   	 	System.out.println("Country: " + Country);
	    	 }  	   
		   } 
		   else if(!item.isFormField())
		   {
			   try 
			   {
				   String itemName = item.getName();
				   FileName = itemName.substring(itemName.lastIndexOf("\\") + 1).trim();
				   System.out.println("itemName: " + itemName + " FileName: " + FileName + " Cid: " + cid + " Country: " + Country);
				     if (cid.equals("1") && Country.equals("1"))
				   {
				   	    savedFile = new File("/web/JBoss_AS/server/80/userapps/ContentDownload.war/HoujeratSubscription/",FileName);
				   	    ContentURL = "http://168.187.115.163/ContentDownload/HoujeratSubscription/";
				   }
				   
				   else if (cid.equals("1") && Country.equals("2"))
				   {
				   	    savedFile = new File("/gateway/JBoss_AS/54321/server/default/deploy/ContentDownload.war/HoujeratSubscription/",FileName);
				   	    ContentURL = "http://213.165.36.131:54321/ContentDownload/HoujeratSubscription/";
				   }
				   
				   item.write(savedFile);  
				   
				   	System.out.println("Before inserting: " + "ContentId: " + ContentId + " FileName: " + FileName);
		           	pstmt = con.prepareStatement("insert into [ContentURL] (ContentURL,ContentId,FileName,cid)values (?,?,?,?)");
					pstmt.setString(1,ContentURL);
					pstmt.setString(2,ContentId);
					pstmt.setString(3,FileName);
					pstmt.setString(4,cid);
					pstmt.execute();
					action="Successfully Inserted Content";
					
		           String url = response.encodeRedirectURL("thankyou.html");
		           response.sendRedirect(url);
		           

			   }
			   catch(Exception e)
			   {
			   		e.printStackTrace();
			   }
			}
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
             }
    	}catch(Exception e){
    		pstmt = null;
    	
    	}
    }
    
%>

<p><font size="4"> <%=action%> </font></p>


