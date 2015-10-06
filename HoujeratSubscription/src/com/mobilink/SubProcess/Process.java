package com.mobilink.SubProcess;

/*
 * Created on 01 August, 2010
 */

/**
 * @author Sheril
 *
 */

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

public class Process {

	// Declaring the global variables

	DBTrans dbTrans = new DBTrans();

	CheckCredits checkCredits = new CheckCredits();


	/**
	 * @param strMsgId
	 * @param strSOA
	 * @param strDA
	 * @param strNormalContent
	 * @param strOpCode
	 * @param iCid
	 * This method will be called when the Menu keyword is sent and a welcome message with the menu list is sent to the user
	 */
	public void doWelcomeSubscription(String strMsgId, String strSOA, String strDA, String strNormalContent, String strOpCode, int iCid)
	{
		String strType = null;
		String strMessage = null;

		if(iCid == 99) // Subscription Menu
		{
			strType = "WM";
			strMessage=dbTrans.getMessage(strDA,strType,iCid);
			//Util.logger(strDA, "Welcome message of HoujeratSubscription: " + strMessage);
			dbTrans.sendMessage(strMsgId,strSOA,strDA,strMessage,strOpCode, Constants.FREE_SHORTCODE_TYPE, iCid);
		}
		else if (iCid == 98) // Unsubscription Menu
		{
			strType = "UME";
			strMessage=dbTrans.getMessage(strDA,strType,iCid);
			//Util.logger(strDA, "Welcome message of HoujeratSubscription: " + strMessage);
			dbTrans.sendMessage(strMsgId,strSOA,strDA,strMessage,strOpCode, Constants.FREE_SHORTCODE_TYPE, iCid);
		}
	}




	/**
	 * @param strMsgId
	 * @param strSOA
	 * @param strDA
	 * @param strContent
	 * @param strOpCode
	 * @param iCid
	 * This method will be called when the user sends the subscribe keyword
	 */

	public void doSubscription(String strMsgId, String strSOA, String strDA,
			String strNormalContent, String strOpCode, int iCid) {

		int iUserId = 0;
		int iUserStatus = 0;
		int iNoofContentsSend = 0;

		String strUserInfo = null;
		String strQuery = null;
		String strUserType = null;
		String strMessageType = null;
		String strFromDate = null;
		String strMessage = null;
		String strCid = null;
		String strMTMsgId = null;
		String strToDate = null;
		String strRenewalDate = null;

		HashMap hmUserInfo = null;

		boolean bCreditsExist = false;
		boolean bDelivered = false;
		String strMessageWAP = null; //jan 5 2012
		String strMessageTypeWAP = "WAPIQ";//jan 5 2012
		try {

			/*Util.logger(strDA, "In doSubscription"
							+ "Cid: " + iCid + "SOA: " + strSOA);
*/

			strQuery = "Select Id,fromdate, cid, status from subscribers where SOA=? and cid=" + iCid;
			hmUserInfo = dbTrans.subscriberStatus(strSOA, strDA, strQuery);
			iUserId = Integer.parseInt((String) hmUserInfo.get("Id"));
			iUserStatus = Integer.parseInt((String) hmUserInfo.get("status"));
			strFromDate = (String) hmUserInfo.get("fromdate");
			strCid = (String) hmUserInfo.get("cid");

			// If the user exists and the subscription is inactive, then send a message that he is already subscribed
			if (iUserId != 0 && iUserStatus == 0) {
				strUserType = "UNA"; // User not active
			}

			// If the user exists and the subscription is active, then send a message that he is already subscribed
			if (iUserId != 0 && iUserStatus == 1) {
				strUserType = "UE";
			}

			// If the user exists and the user is already blocked
			else if (iUserId != 0 && iUserStatus == 2) {
				strUserType = "UN"; // Unsubscribed User
			}

			// If the user exists and the user has unsubscribed
			else if (iUserId != 0 && iUserStatus == 3) {
				strUserType = "BU"; // Blocked User
			}

			// If the user doesnot exist, then subscribe them by sending charged message
			else if (iUserId == 0) {
				strUserType = "NU"; // New User
			}

			Util.logger(strDA, "In doSubscription UserType: "
					+ strUserType);

			// If the user is new , then subscribe him to the service and send a charged message from MT charged short code
			// Insert a new row in the Subscribers table
			if (strUserType.equals("NU") || strUserType.equals("BU")
					|| strUserType.equals("UN") || strUserType.equals("UNA")){

				try {


						// Iraq
						if(strOpCode.equals("40"))
						{
							strMessageType = "RGIQ";
							strMessage = dbTrans
									.getMessage(strDA, strMessageType, iCid);
							iUserStatus = 1;
							strMTMsgId = dbTrans.sendMessage(strMsgId, strSOA, strDA,
									strMessage, strOpCode,
									Constants.FREE_SHORTCODE_TYPE, iCid);
							
							//Added by sunayna on jan 5 2012
							strMessageWAP = dbTrans
							.getMessage(strDA, strMessageTypeWAP, iCid);
							strMessageWAP = Util.getNormal(strMessageWAP);
							if(!strMessageWAP.trim().equals(""))
							{
								String strMTMsgIdWAP=dbTrans.sendContent(strDA,iCid,strMessageWAP, strSOA, strOpCode);
								Util.logger("SendContent", "SOA: " + strSOA +" strMessageWAP: "+strMessageWAP+" strMTMsgIdWAP : "+strMTMsgIdWAP);
							}
						}

						// For any other operators
						else
						{
							strMessageType = "RG";
							strMessage = dbTrans
									.getMessage(strDA, strMessageType, iCid);
							// Send charged welcome message
							
							if(strOpCode.equals("3")) {
								dbTrans.sendMessage(strMsgId, strSOA, strDA,
										strMessage, strOpCode,
										Constants.FREE_SHORTCODE_TYPE, iCid);
							} else {
								strMTMsgId = dbTrans.sendMessage(strMsgId, strSOA, strDA,
											strMessage, strOpCode,
											Constants.CHARGED_SHORTCODE_TYPE, iCid);
							}

//							 Modified on 10 Oct 2010
							// Send unsubscribe message from free SC for Zain Kuwait users
							if(strOpCode.equals("14"))
							{
								dbTrans.sendMessage(strMsgId, strSOA, strDA,dbTrans.getMessage(strDA, "UNSUB", iCid), strOpCode,
										Constants.FREE_SHORTCODE_TYPE, iCid);

							}

							Thread.sleep(6000);
							if (strMTMsgId != null)
							{
								if(strOpCode.equals("3")) {
									iUserStatus = 1;
								} else {
									bDelivered = checkCredits.checkStatus(strDA, strOpCode,
											strMTMsgId);
									if (bDelivered) {
										iUserStatus = 1;
										bCreditsExist = true;
										//Util.logger(strDA, "checkStatus  Credits Present"		+ bDelivered);
									} else {
										iUserStatus = 0;
										bCreditsExist = false;
										//strUserType = "UNA";
										//Util.logger(strDA, "checkStatus No credits"	+ bDelivered);
									}
									dbTrans.insertMTMessageQueues(strSOA, strDA,
											strMessage, strMTMsgId, iUserStatus, iCid,
											strOpCode,strMessageType);
								}
							}
						}


						if (strUserType.equals("NU"))
						{
							iUserStatus = 1;
							dbTrans.insertSubscribers(strSOA, strDA, strOpCode,  iUserStatus,
									iCid);
						}

						// If the user is blocked or unsubscribed, then subscribe him to the service and send a charged message from MT charged short code
						// Update the existing row in the Subscribers table
						else if (strUserType.equals("BU")
								|| strUserType.equals("UN")  || strUserType.equals("UNA"))
						{
							Calendar now = Calendar.getInstance();
							DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss.sss");
							now.add(Calendar.DATE, 7);
							Date date = now.getTime();
							strRenewalDate = formatter.format(date);
							strFromDate = formatter.format(new Date());
							strToDate = formatter.format(new Date());
							Date Renewaldate = formatter.parse(strRenewalDate);
							Timestamp renewalTimestamp = new Timestamp(Renewaldate.getTime());
							Date FromDate = formatter.parse(strFromDate);
							Timestamp fromTimestamp = new Timestamp(FromDate.getTime());
							Date Todate = formatter.parse(strToDate);
							Timestamp toTimestamp = new Timestamp(Todate.getTime());
							iUserStatus = 1;
							dbTrans.updateSubscriberStatus(strSOA, strDA,
									fromTimestamp, toTimestamp, renewalTimestamp,
									iUserStatus, iCid,
									iNoofContentsSend);
						}
						Thread.sleep(5000);
					} catch (Exception e) {
					Util
							.logError(strDA,
									"Error in doSubscription");
				}
			}



			// If the user exists , send a message that the user is already subscribed
			else if (strUserType.equals("UE")) {
				strMessageType = "UE";
				strMessage = dbTrans.getMessage(strDA, strMessageType, iCid);
				dbTrans.sendMessage(strMsgId, strSOA, strDA, strMessage,
						strOpCode, Constants.FREE_SHORTCODE_TYPE, iCid);
			}

		} catch (Exception e) {
			Util.logError(strDA,
					"Error in doSubscription() "
							+ e.getMessage());
		}

	}



	/**
	 * @param strMsgId
	 * @param strSOA
	 * @param strDA
	 * @param strNormalContent
	 * @param strOpCode
	 * @param iCid
	 * This method is called when the user send the Unsubscription keyword to unsubscribe from the service.
	 */
	public void doUnSubscription(String strMsgId, String strSOA, String strDA,
			String strNormalContent, String strOpCode, int iCid) {

		//Util.logger(strDA, "In doUnSubscription SOA: " + strSOA + " Cid: " + iCid);
		String strQuery = null;
		String strType = null;
		String strTypeAd = "UMAD"; //added on jul 17 2013 for sending additional message when user gets unsubscribed
		String strMessage = null;

		int iUserId = 0;
		int iUserStatus = 0;

		HashMap hmUserInfo = null;

		try {

			strQuery = "Select Id,fromdate, cid, status from subscribers where SOA=? and cid= " + iCid;
			hmUserInfo = dbTrans.subscriberStatus(strSOA, strDA, strQuery);
			if((String) hmUserInfo.get("Id") != null || ((String) hmUserInfo.get("Id")).length() > 0)
				iUserId = Integer.parseInt((String) hmUserInfo.get("Id"));
			if((String) hmUserInfo.get("status") != null || ((String) hmUserInfo.get("status")).length() > 0 )
				iUserStatus = Integer.parseInt((String) hmUserInfo.get("status"));


			//Util.logger(strDA, "UserId: " + iUserId + " User Status: " + iUserStatus + " Cid: " + iCid);

			// Not a subscriber
			if(iUserId == 0)
			{
				if(strOpCode.equals("40"))
					strType = "UNEIQ"; // subscriber does not exist
				else
					strType = "UNE"; // subscriber does not exist
			}

			// User is not active
			else if(iUserId != 0 && iUserStatus == 0)
			{
				if(strOpCode.equals("40"))
					strType = "UMIQ";
				else
					strType = "UM";
				dbTrans.unSubscribeAll(strSOA, strDA, iCid);
			}

			// User is subscribed
			else if(iUserId != 0 && iUserStatus == 1)
			{
				if(strOpCode.equals("40"))
					strType = "UMIQ";
				else
					strType = "UM";
				dbTrans.unSubscribeAll(strSOA, strDA, iCid);
			}

			// User is already unsubscribed
			else if(iUserId != 0 && iUserStatus != 1)
			{
				if(strOpCode.equals("40"))
					strType = "UUNIQ";
				else
					strType = "UUN";
			}


			//Util.logger(strDA, "Type in  doUnSubscription " + strType);
			strMessage = dbTrans.getMessage(strDA, strType, iCid);
			dbTrans.sendMessage(strMsgId, strSOA, strDA, strMessage,
					strOpCode, Constants.FREE_SHORTCODE_TYPE, iCid);
			
			if(strType.equals("UMIQ")) //block added on jul 17 2013 for sending additional message during unsubscription
			{
				Util.logger(strDA, "Type in  doUnSubscription " + strTypeAd);
				strMessage = dbTrans.getMessage(strDA, strTypeAd, iCid);
				if(!strMessage.equals(""))
				{
					dbTrans.sendMessage(strMsgId, strSOA, strDA, strMessage,
							strOpCode, Constants.FREE_SHORTCODE_TYPE, iCid);
				}
			}
			
			}
		catch (Exception e) {
			Util.logError(strDA,
					"Error in doUnSubscription() "
							+ e.getMessage());
		}
	}

}
