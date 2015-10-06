/*
 * Created on 01 August, 2010
 */
package com.mobilink.SubProcess;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.sql.*;
import java.awt.*;
import javax.sql.*;


import java.util.HashMap;
import java.util.zip.*;

public class ContentDownload extends HttpServlet{

    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

		doPost(request,response);
	}

    public void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

    	//Util.logger("ContentDownload", "In doPost()");

    	DBTrans dbTrans = new DBTrans();

		String strContentURL = null;
		String strFileName = null;
		String strContentType = null;
		String strSOA = null;
		String strContentId = null;
		String strBrowser = null;
		String ReqDetails = null;

		byte b[] = null;

		int iDownloadStatus = 0;
		int iCid = 0;
		int iAccessFlag = 0;
		int id = 0;

		HashMap hmAccessDetails = null;
		HashMap hmContentURL = null;

		CRC32 inChecker = new CRC32();
		CRC32 outChecker = new CRC32();

		File uploadFile = null;

		try
		{
			strBrowser = (String)request.getHeader("User-Agent");
			ReqDetails = request.getParameter("Req");

			strSOA = ReqDetails.substring(0, ReqDetails.indexOf(","));
			strContentId = ReqDetails.substring(ReqDetails.lastIndexOf(",") +  1, ReqDetails.length());
			iCid = 1;

			hmAccessDetails = dbTrans.getAccessFlag(strSOA, iCid, strContentId);
			id = Integer.parseInt((String)hmAccessDetails.get("Id"));
			iAccessFlag = Integer.parseInt((String)hmAccessDetails.get("AccessFlag"));
			iDownloadStatus = Integer.parseInt((String)hmAccessDetails.get("DownloadFlag"));

			/*Util.logger("ContentDownload","User Agent: " + strBrowser
					+ " SOA: " + strSOA + " ContentId: " + strContentId
					+ " Cid: " + iCid + " AccessFlag: " + iAccessFlag
					+ " DownloadFlag: " + iDownloadStatus);*/
				hmContentURL = dbTrans.getContentURL("ContentDownload", strContentId, iCid);
				strContentURL = (String)hmContentURL.get("ContentURL");
				strFileName = (String)hmContentURL.get("FileName");
				strContentURL = strContentURL + strFileName;

				/*Util.logger("ContentDownload","FileName: " + strFileName
						+ " ContentURL: " + strContentURL);*/

				if(strContentURL.indexOf("109.224.8.172") != -1)
				{
					strContentURL = strContentURL.replaceAll("109.224.8.172", "172.16.3.76");
					uploadFile = new File("/gateway/JBoss_AS/54321/server/default/deploy/ContentDownload.war/HoujeratSubscription/",strFileName);


				}
				else if(strContentURL.indexOf("168.187.115.163") != -1)
				{
					strContentURL = strContentURL.replaceAll("168.187.115.163", "192.168.1.223");
					uploadFile = new File("/web/JBoss_AS/server/80/userapps/ContentDownload.war/HoujeratSubscription/",strFileName);

				}
				
				//Util.logger("ContentDownload", "Modified ContentURL: " + strContentURL);

/*				URL url = new URL(strContentURL);
				URLConnection uc = url.openConnection();
				uc.connect();*/

				FileInputStream inputStream = new FileInputStream(uploadFile);
				long size = uploadFile.length();

				DataInputStream dis = new DataInputStream(inputStream);
				b = new byte[dis.available()];
				CheckedInputStream cis = new CheckedInputStream(dis,inChecker);


	            //Read the extensions and assign appropriate contenttype.
	            if(strFileName.toLowerCase().indexOf(".mid") != -1) strContentType = "audio/mid";
	            if(strFileName.toLowerCase().indexOf(".amr") != -1) strContentType = "audio/amr";
	            if(strFileName.toLowerCase().indexOf(".awb") != -1) strContentType = "audio/awb";
	            if(strFileName.toLowerCase().indexOf(".mp3") != -1) strContentType = "audio/mp3";
	            if(strFileName.toLowerCase().indexOf(".mp4") != -1) strContentType = "audio/mp4";
	            if(strFileName.toLowerCase().indexOf(".rm") != -1) strContentType = "audio/rm";
	            if(strFileName.toLowerCase().indexOf(".midi") != -1) strContentType = "audio/midi";
	            if(strFileName.toLowerCase().indexOf(".rmi") != -1) strContentType = "audio/rmi";
	            if(strFileName.toLowerCase().indexOf(".wav") != -1) strContentType = "audio/wav";
	            if(strFileName.toLowerCase().indexOf(".wave") != -1) strContentType = "audio/wave";

	            if(strFileName.toLowerCase().indexOf(".3gp") != -1) strContentType = "video/3gpp";
	            if(strFileName.toLowerCase().indexOf(".3gpp") != -1) strContentType = "video/3gpp";

	            if(strFileName.toLowerCase().indexOf(".jpe") != -1) strContentType = "audio/jpeg";
	            if(strFileName.toLowerCase().indexOf(".jpeg") != -1) strContentType = "image/jpeg";
	            if(strFileName.toLowerCase().indexOf(".jpg") != -1) strContentType = "image/jpeg";
	            if(strFileName.toLowerCase().indexOf(".gif") != -1) strContentType = "image/gif";
	            if(strFileName.toLowerCase().indexOf(".bmp") != -1) strContentType = "image/bmp";

	            if(strFileName.toLowerCase().indexOf(".rtx") != -1) strContentType = "text/richtext";
	            if(strFileName.toLowerCase().indexOf(".rttl") != -1) strContentType = "text/richtext";
	            if(strFileName.toLowerCase().indexOf(".txt") != -1) strContentType = "text/plain";

	            if(strFileName.toLowerCase().indexOf(".jar") != -1) strContentType = "application/java-archive	";
	            if(strFileName.toLowerCase().indexOf(".jad") != -1) strContentType = "text/vnd.sun.j2me.app-descriptor";
	      	    if(strFileName.toLowerCase().indexOf(".sis") != -1) strContentType = "application/vnd.symbian.install";

	      	    //Util.logger("ContentDownload","fileName: " + strFileName + "ContentType: " + strContentType);

	      	    // Writing the file to the output stream and setting the appropriate ContentType

				CheckedOutputStream cos = new CheckedOutputStream(response.getOutputStream(),outChecker);
				response.setContentType(strContentType);

				cis.read(b);
				cis.close();
				dis.close();

				cos.write(b);
				cos.flush();
			    cos.close();

			    iAccessFlag = 1;
			    //Util.logger("ContentDownload",inChecker.getValue() + " " + outChecker.getValue());
				if(inChecker.getValue() == outChecker.getValue()){
					iDownloadStatus = 1;
				}

				/*Util.logger("ContentDownload","DownloadStatus: " + iDownloadStatus + "SOA: " + strSOA + "ContentId: " + strContentId
						+ "Cid: " + iCid);*/


		}
		catch(Exception e)
		{
			Util.logError("ContentDownload","Error message: " + e.getMessage());
			iDownloadStatus = 2;
			Util.logError("ContentDownload","Download Status: " + iDownloadStatus + "SOA: " + strSOA + "ContentId: " + strContentId
					+ "Cid: " + iCid);
		}
		try
		{
			dbTrans.updateQueues(strSOA, strContentId, iCid, iDownloadStatus, strBrowser, iAccessFlag, id);
		}
		catch(Exception e)
		{
			Util.logError("ContentDownload","Error in updating queues: " + e.getMessage());
		}
    }
}

