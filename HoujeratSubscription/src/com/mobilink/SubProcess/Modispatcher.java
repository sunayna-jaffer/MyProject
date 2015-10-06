package com.mobilink.SubProcess;

/*
 * Created on 01 August, 2010
 */

/**
 * @author Sheril
 *
 * Entry point for HoujeratSubscription project
 *
 */

import java.io.IOException;
import java.util.HashMap;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mobilink.SubProcess.Util;


public class Modispatcher extends HttpServlet {

	String strMessage = null;
	DBTrans dbTrans = new DBTrans();
	Process process = new Process();
	PriorityQueue MsgIdQueue = new PriorityQueue();

	public Modispatcher() {
		super();
	}

	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request,response);
	}

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
				throws ServletException, IOException {


			String strMsgId = null;
			String strSOA = null;
			String strDA = null;
			String strContent = null;
			String strNormalContent=null;
			String strGatewayId = null;
			String strMsgCount = null;
			String strFlags=null;
			String strOpCode=null;
			String strType=null;
			String strKeywordType = null;
			String strMessage = null;
			String strCid = null;
			String  intContent = "";

			int iCid=0;

			boolean bContestLogPresent=false;
			boolean bUnsubKeys = false; // True if the content sent by user is Unsubscribe keyword
			boolean bSubKeys = false; // True if the content sent by user is keyword for subscription
			boolean bMenuKeys = false; // True if the content sent by user is keyword for menu list

			HashMap hmKeywordData = null; // Holds the query result of the type of keyword and the cid

			response.setContentType("text/html");
			PrintWriter out = response.getWriter();

			try
			{
				// Get the request parameters
				strMsgId=request.getParameter("MsgId").trim();
				strSOA=request.getParameter("SOA").trim();
				strDA=request.getParameter("DA").trim();
				strContent=request.getParameter("Content").trim();
				strFlags = request.getParameter("Flags").trim();
				strOpCode = request.getParameter("OpCode").trim();
				strGatewayId = request.getParameter("GatewayId").trim();
				strMsgCount = request.getParameter("MsgCount").trim();
	            strNormalContent=Util.getNormal(strContent).trim();
	            intContent=Util.getIntContent(strNormalContent).trim();

	            /*Util.logger(strDA, "Input data: MsgId: " + strMsgId + " SOA: " + strSOA + " DA: " + strDA
	            		+ " Content: " + strContent + " Flags: " + strFlags + " OpCode: " + strOpCode
	            		+ " NormalContent: " + strNormalContent + " IntContent: " + intContent);*/
			 }
			 catch(Exception e){
			 	Util.logError(strDA,"Exception in geting params"+e.getMessage());
			 }

			  //Inserting row in ContestLog table
			  try
			  {
				  // Storing 500 ContestLog primarykeys (MsgId & GatewayId)in the queue
				  // Before inserting into ContestLog table , first check if the queue contains the combination of primary key
				  // This is used to avoid primary key violation

				  String ContestlogPrimaryKey = strMsgId + "," + strGatewayId;

				  // If queue contains the primary key combination, then throw exception and give "9999" response to the gateway
				  if(MsgIdQueue.contains(ContestlogPrimaryKey))
				  {
					  Util.logError(strDA, "Combination of MsgId and GatewayId is present in ContestLog table");
					  throw new Exception();
				  }

				  // If the queue doesnt contain the primary key combination, then insert the row in the contest log table
				  else
				  {
					  	hmKeywordData=dbTrans.insertContestLog(strGatewayId,strMsgId,strSOA,strDA,strNormalContent, strOpCode,strMsgCount );
						strKeywordType = (String)hmKeywordData.get("type");
						strCid = (String)hmKeywordData.get("cid");
						iCid = Integer.parseInt(strCid);
						//Util.logger(strDA, " cid " +iCid + "strKeywordType: " + strKeywordType);

						if(iCid != 0)
						{
							if("U".equals(strKeywordType))
								bUnsubKeys=true;
							else if("S".equals(strKeywordType))
								bSubKeys=true;
							else if("M".equals(strKeywordType))
								bMenuKeys=true;

						}
					  // Start flushing the queue when it reaches a size of 500
					  // It will remove the oldest record in the queue FIFO mechanism.
					  if(MsgIdQueue.size() > 500)
					  {
						  MsgIdQueue.add(ContestlogPrimaryKey);
					  }
					  else
					  {
						  //System.out.println("Added ContestlogPrimaryKey: "+ ContestlogPrimaryKey);
						  MsgIdQueue.add(ContestlogPrimaryKey);
					  }
				  }
			  }
			  catch (Exception e)
			  {
				  bContestLogPresent = true;
				  Util.logError(strDA, "Error in inserting row in Contest table");
			  }

			  // Continue with the rest of the flow only if ContestLogPresent status is false

			  if(!bContestLogPresent)
			  {
				  if(iCid != 0)
				  {
					  if(bMenuKeys)
					  {
						  // For Menu
						  process.doWelcomeSubscription(strMsgId, strSOA, strDA, strContent, strOpCode, iCid);
					  }
					  else if(bUnsubKeys)
					  {
							//For Unsubscription
							  process.doUnSubscription(strMsgId, strSOA, strDA, strContent, strOpCode, iCid);
					  }
					  else if(bSubKeys)
					  {

						//For Subscription
							  process.doSubscription(strMsgId, strSOA, strDA, strContent, strOpCode, iCid);
					  }
				  }
				  else if (iCid == 0)
				  {
					  if(strOpCode.equals("40"))
					  	strType = "XEIQ";
					  else
					  	strType = "XE";
					  iCid = 1;

					strMessage = dbTrans.getMessage(strDA, strType, iCid);
					dbTrans.sendMessage(strMsgId,strSOA,strDA,strMessage,strOpCode, Constants.FREE_SHORTCODE_TYPE,iCid);
				}
			  }


	}

	public void init() throws ServletException {
		// Put your code here
	}

}

