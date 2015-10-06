package com.mobilink.SubProcess;

/*
 * Created on 01 August, 2010
 */

/**
 * @author Sheril
 *
 */

import java.util.Properties;

import javax.sql.DataSource;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;

public class CheckCredits {

	private DataSource ds = null;
	DBTrans dbTrans=new DBTrans();



 /**
 * @param DA
 * @param OpCode
 * @param MtMsgId
 * @param GatewayId
 * @return
 */
public  boolean checkStatus(String DA,String OpCode,String MtMsgId){

		//Util.logger(DA, "In checkstatus: OpCode - " + OpCode + " MtMsgId - " + MtMsgId);

		String strCheckStatusURL = null;
		String strDeliveryStatus = null;

	    Properties prop=new Properties();

	    int iMsgCount = 0;
	    int iDrMsgPartsRcvd = 0;

	    boolean bDelivered = false;

		try
		{
			if(OpCode.equals("11") || OpCode.equals("52"))
				strCheckStatusURL=Constants.FOREIGN_CHECK_STATUS_URL;
			else if (OpCode.equals("5")) // STC
				strCheckStatusURL=Constants.STC_CHECK_STATUS_URL;
			else if (OpCode.equals("47") || OpCode.equals("60")) // MOBILY & ZAIN
				strCheckStatusURL=Constants.MOBILY_CHECK_STATUS_URL;
			else if (OpCode.equals("15")) // Wataniya
				strCheckStatusURL=Constants.WATANIYA_CHECK_STATUS_URL;
			else if(OpCode.equals("40"))
				strCheckStatusURL=Constants.IRAQ_STATUS_URL;
			else
				strCheckStatusURL=Constants.CHECK_STATUS_URL;

			strCheckStatusURL+="MsgId="+MtMsgId;
			//Util.logger(DA,"checkCreditsStatus--checkStatusUrl"+strCheckStatusURL);

			HttpClient client = new HttpClient();
			client.setConnectionTimeout(10000);
			HttpMethod method = new GetMethod(strCheckStatusURL);
			if(method.validate()){
				int statusCode = client.executeMethod(method);
				if (statusCode == HttpStatus.SC_OK) {
					String mtResponse= method.getResponseBodyAsString();
					//Util.logger(DA,"MTResponse in checkCredits: " + mtResponse);
	  				prop.load(method.getResponseBodyAsStream());
	  				String MsgCount=prop.getProperty("MsgCount");

	  				// Modified on 12 Oct 2010 for Delivery status check.
	  				// If status is 0, then we consider that the charged message is successfully delivered to the customer for Zain Kuwait
	  				if(OpCode.equals("14"))
	  				{
		  				String status = prop.getProperty("Status");
		  				if(status.equals("0"))
		  				{
		  					 bDelivered=true;
		  				}
		  				else
		  				{
		  					bDelivered=false;
		  				}
	  				}
	  				else
	  				{
		  				String DR_MsgPartsRcvd=prop.getProperty("DR.MsgPartsRcvd");
		  				if(DR_MsgPartsRcvd!=null)
		  				{
		  					iMsgCount=Integer.parseInt(MsgCount);
		  					iDrMsgPartsRcvd=Integer.parseInt(DR_MsgPartsRcvd);
			  				  if(iMsgCount==iDrMsgPartsRcvd) {
			  				   	for(int i=1; i<=iMsgCount; i++) {
			  				   		strDeliveryStatus=prop.getProperty("DR.Status."+i);
			  					  if(strDeliveryStatus.equalsIgnoreCase("DELIVRD")) {
			  						  bDelivered=true;
			  					   }else {
			  						 bDelivered=false;
			  					   }
			  					}
			  				 }
		  				}
	  				}
				}
			}
			  //	release connection

			  method.releaseConnection();

	 	}catch(Exception e){
	 		Util.logError(DA,"Error in sendMessage Method "+e.getMessage());
	 	}
	 	return bDelivered;
	}




}
