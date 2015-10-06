package com.mobilink.SubProcess;

/*
 * Created on 01 August, 2010
 */

/**
 * @author Sheril
 *
 * This class contains the methods querying the database
 */

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.HashMap;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.PostMethod;

import com.mobilink.SubProcess.Constants;
import com.mobilink.SubProcess.Util;

public class DBTrans {

	private DataSource ds = null;
	SiWapPush siwappush = null; //jan 5 2012


	/**
	 * @return
	 */
	public synchronized DataSource getDataSource() {
		// If data source is not null, return data source
		if (ds != null) {
			return ds;
		}

		try {
			InitialContext cont = new InitialContext();
			ds = (DataSource) cont.lookup(Constants.DS_NAME);
		} catch (NamingException ne) {
			Util.logError(Constants.LOGGER,
					"Error in establishing the database connection" + ne);
		}
		return ds;

	}



	/**
	 * @param GatewayId
	 * @param MsgId
	 * @param SOA
	 * @param DA
	 * @param Content
	 * @param opCode
	 * @param MsgCount
	 * @return
	 * This method calls the stored procedure for insert the row in contest log and checking if it is a keyword or not
	 */
	public HashMap insertContestLog(String GatewayId, String MsgId, String SOA,
			String DA, String Content, String opCode, String MsgCount)
			throws Exception {

		Connection con = null;
		CallableStatement callablestatement = null;
		HashMap hmKeyword = null;

		int cid = 0;

		String strKeywordType = null;

		try {
			ds = getDataSource();
			con = ds.getConnection();
			/*Util.logger(DA, "inside SP_insertContestLog");
			Util.logger(DA,"GatewayId: " + GatewayId + " MsgId: " + MsgId
					+ " SOA: " + SOA + " DA: " + DA + " Content: " + Content
					+ " OpCode: " + opCode + " MsgCount: " + MsgCount);*/
			callablestatement = con
					.prepareCall("{call usp_insertContestLog(?,?,?,?,?,?,?,?)}");
			callablestatement.setInt(1, Integer.parseInt(GatewayId));
			callablestatement.setInt(2, Integer.parseInt(MsgId));
			callablestatement.setString(3, SOA);
			callablestatement.setString(4, DA);
			callablestatement.setString(5, Content);
			callablestatement.setInt(6, Integer.parseInt(opCode));
			callablestatement.registerOutParameter(7, Types.INTEGER);
			callablestatement.registerOutParameter(8, Types.CHAR);
			callablestatement.execute();
			cid = callablestatement.getInt(7);
			strKeywordType = callablestatement.getString(8);
			hmKeyword = new HashMap();
			hmKeyword.put("cid", new Integer(cid).toString());
			hmKeyword.put("type", strKeywordType);
			callablestatement.close();
			callablestatement = null;
			con.close();
			con = null;

		} catch (Exception e) {
			Util.logError(DA, "Error in usp_insertContestLog function "
					+ e.getMessage());
			throw e;
		} finally {
			try {
				if (con != null) {
					con.close();
					con = null;
				}
			} catch (Exception e) {
				Util.logError(DA,
						"usp_insertContestLog Method Close Connection "
								+ e.getMessage());
			}
		}
		return hmKeyword;
	}

	/**
	 * @param GatewayId
	 * @param MsgId
	 * @param SOA
	 * @param DA
	 * @param Content
	 * @param opCode
	 * @param MsgCount
	 * @return
	 * This method calls the stored procedure for insert the row in contest log and checking if it is a keyword or not
	 */
	public HashMap insertSubscribers(String strSOA, String strDA, String strOpCode,
			int iUserStatus, int iCid)
			throws Exception {

		Connection con = null;
		CallableStatement callablestatement = null;
		HashMap hmKeyword = null;

		try {
			ds = getDataSource();
			con = ds.getConnection();
			/*Util.logger(strDA, "inside insertSubscribers");
			Util.logger(strDA,"SOA: " + strSOA + "DA: " + strDA
					+ "User Status: " + iUserStatus + "Cid: " + iCid);*/
			callablestatement = con
					.prepareCall("{call usp_insertSubscribers(?,?,?,?,?)}");
			callablestatement.setString(1, strSOA);
			callablestatement.setString(2, strDA);
			callablestatement.setString(3, strOpCode);
			callablestatement.setInt(4, iUserStatus);
			callablestatement.setInt(5, iCid);
			callablestatement.execute();
			callablestatement.close();
			callablestatement = null;

		} catch (Exception e) {
			Util.logError(strDA, "Error in insertSubscribers function "
					+ e.getMessage());
			throw e;
		} finally {
			try {
				if (con != null) {
					con.close();
					con = null;
				}
			} catch (Exception e) {
				Util.logError(strDA,
						"insertSubscribers Method Close Connection "
								+ e.getMessage());
			}
		}
		return hmKeyword;
	}

	/**
	 * @param GatewayId
	 * @param MsgId
	 * @param SOA
	 * @param DA
	 * @param Content
	 * @param opCode
	 * @param MsgCount
	 * @return
	 * This method calls the stored procedure for unsubscribing the user from all the services provided by Maggy Farah
	 */
	public void unSubscribeAll(String SOA, String DA, int iCid) throws Exception {

		//Util.logger(DA,"In unSubscribeAll SOA: " + SOA + " DA: " + DA + " Cid: " + iCid);
		Connection con = null;
		ResultSet rs = null;
		CallableStatement callablestatement = null;

		try {
			ds = getDataSource();
			con = ds.getConnection();
			callablestatement = con
					.prepareCall("{call usp_unSubscribeAll(?,?,?)}");
			callablestatement.setString(1, SOA);
			callablestatement.setString(2, DA);
			callablestatement.setInt(3, iCid);
			callablestatement.execute();

			callablestatement.close();
			callablestatement = null;

		} catch (Exception e) {
			Util.logError(DA, "Error in usp_unSubscribeAll function "
					+ e.getMessage());
			throw e;
		} finally {
			try {
				if (con != null) {
					con.close();
					con = null;
				}
			} catch (Exception e) {
				Util.logError(DA, "usp_unSubscribeAll Method Close Connection "
						+ e.getMessage());
			}
		}
	}

	/**
	 * @param DA
	 * @param type
	 * @param cid
	 * @return
	 * This method returns the message from the database.
	 */
	public String getMessage(String DA, String type, int cid) {
		/*Util.logger(DA,"In getMessage() " + "Type : " + type + "Cid: "
				+ cid);*/
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String responseString = "";
		try {
			ds = getDataSource();
			conn = ds.getConnection();
			pstmt = conn
					.prepareStatement("select unicode from message where type =? and cid=? ");
			pstmt.setString(1, type);
			pstmt.setInt(2, cid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				responseString = rs.getString(1).trim();
			}

		} catch (Exception E) {
			Util.logError(DA, "Type  " + type
					+ "Error occured in getting  message " + E);
		} finally {
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (Exception e) {
				Util.logError(DA, "getMessage Method Close result set  "
						+ e.getMessage());
			}
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception e) {
				Util.logError(DA, "getMessage Method Close Statement "
						+ e.getMessage());
			}
			try {
				if (conn != null) {
					conn.close();
					conn = null;
				}
			} catch (Exception e) {
				Util.logError(DA, "getMessage Method Close Connection "
						+ e.getMessage());
			}
		}
		return responseString;

	}

	/**
	 * @param strSOA
	 * @param strDA
	 * @param strFromDate
	 * @param strToDate
	 * @param strRenewalDate
	 * @param iUserStatus
	 * @param iCid
	 * @param iNoofContentsSend
	 * @param iNoofContentsEligible
	 * @param iScheduledContent
	 */
	public void  updateSubscriberStatus(String strSOA, String strDA,
			Timestamp strFromDate, Timestamp strToDate, Timestamp strRenewalDate,
			int iUserStatus, int iCid, int iNoofContentsSend) {

		/*Util.logger(strDA, "inside updateSubscriberStatus" + strSOA + " "
				+ iUserStatus + " " + "FromDate: " + strFromDate + "ToDate: " + strToDate
				+ "RenewalDate: " + strRenewalDate );*/
		Connection conn = null;
		CallableStatement callablestatement = null;
		ResultSet rs = null;
		try {
			ds = getDataSource();
			conn = ds.getConnection();
			callablestatement = conn
					.prepareCall("{call usp_updateSubscribers(?,?,?,?,?,?,?,?)}");
			callablestatement.setString(1, strSOA);
			callablestatement.setString(2, strDA);
			callablestatement.setTimestamp(3, strFromDate);
			callablestatement.setTimestamp(4, strToDate);
			callablestatement.setTimestamp(5, strRenewalDate);
			callablestatement.setInt(6, iUserStatus);
			callablestatement.setInt(7, iCid);
			callablestatement.setInt(8, iNoofContentsSend);
			callablestatement.execute();
			callablestatement.close();
			callablestatement = null;
		} catch (Exception e) {
			Util.logError(strDA, "Error in updateSubscriberStatus table"
					+ e.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (Exception e) {
				Util.logError(strDA,
						"updateSubscriberStatus Method Close result set  "
								+ e.getMessage());
			}
			try {
				if (callablestatement != null) {
					callablestatement.close();
					callablestatement = null;
				}
			} catch (Exception e) {
				Util.logError(strDA,
						"updateSubscriberStatus Method Close Statement "
								+ e.getMessage());
			}
			try {
				if (conn != null) {
					conn.close();
					conn = null;
				}
			} catch (Exception e) {
				Util.logError(strDA,
						"updateSubscriberStatus Method Close Connection "
								+ e.getMessage());
			}
		}
	}


	 /* @param strDA
	 * @param MsgId
	 * @param GatewayId
	 * @param cid
	 * @return
	 */
	public void updateContestLog(String MsgId, String strSOA, String strDA,
			String response) {
		Connection con = null;
		CallableStatement callablestatement = null;
		try {
			//Util.logger(strDA, "inside usp_updateContestLog SOA: " + strSOA + " REsponse: " + response);
			ds = getDataSource();
			con = ds.getConnection();
			callablestatement = con
					.prepareCall("{call usp_updateContestLog(?,?)}");
			callablestatement.setInt(1, Integer.parseInt(MsgId));
			callablestatement.setString(2, response);
			callablestatement.execute();
			callablestatement.close();
			callablestatement = null;
		} catch (Exception e) {
			Util.logError(strDA, "Error in updating contestLog table"
					+ e.getMessage());
		} finally {
			try {
				if (callablestatement != null) {
					callablestatement.close();
					callablestatement = null;
				}
			} catch (Exception e) {
				Util.logError(strDA,
						"updateContestLog Method Close callablestatement "
								+ e.getMessage());
			}
			try {
				if (con != null) {
					con.close();
					con = null;
				}
			} catch (Exception e) {
				Util.logError(strDA,
						"updateContestLog Method Close Connection "
								+ e.getMessage());
			}
		}
	}


	/**
  	 * @param strSOA
  	 * @param strDA
  	 * @return
  	 */
  	public  HashMap getAccessFlag(String strSOA, int iCid, String strContentId ){
		  Connection conn = null;
		  PreparedStatement pstmt = null;
		  ResultSet rs=null;
		  HashMap hmAccessFlag = null;

		  int userId = 0;
		  int accessFlag = 0;
		  int iDownloadStatus = 0;
		try{
			ds =getDataSource();
			conn = ds.getConnection();
			pstmt = conn.prepareStatement("select top 1 Id, AccessFlag, DownloadFlag from SubsQueues(nolock) where SOA=? and Cid=? and ContentId=?  order by id desc");
			pstmt.setString(1, strSOA);
			pstmt.setInt(2, iCid);
			pstmt.setString(3, strContentId);
			rs= pstmt.executeQuery();
			if (rs.next()) {
			    userId=rs.getInt(1);
			    accessFlag=rs.getInt(2);
			    iDownloadStatus = rs.getInt(3);
			}

			hmAccessFlag = new HashMap();
			hmAccessFlag.put("Id", new Integer(userId).toString());
			hmAccessFlag.put("AccessFlag", new Integer(accessFlag).toString());
			hmAccessFlag.put("DownloadFlag", new Integer(iDownloadStatus).toString());



		}catch(Exception E){
			Util.logError("ContentDownload","Error occured in getAccessFlag  "+E.getMessage());
		}finally{
		    try{
		    	 if(rs!=null){
		            rs.close();
		            rs=null;
		            }
		    }catch(Exception e){ Util.logError("ContentDownload","getAccessFlag Method Close result set  "+e.getMessage());}
		    try{
		    	if(pstmt!=null){
		            pstmt.close();
		            pstmt=null;
		            }
		    }catch(Exception e){ Util.logError("ContentDownload","getAccessFlag Method Close Statement "+e.getMessage());}
		    try{
		      	if(conn!=null){
		            conn.close();
		            conn=null;
		          }
		     }catch(Exception e){ Util.logError("ContentDownload","getAccessFlag Method Close Connection "+e.getMessage());}
		 }
		 return hmAccessFlag;

	}


	/**
	 * @param strSOA
	 * @param strContentId
	 * @param iCid
	 * @param iStatus
	 * @param strBrowser
	 * @return
	 */
	public  void updateQueues(String strSOA, String strContentId, int iCid, int iDownloadStatus, String strBrowser, int iAccessFlag, int id ){

		/*Util.logger("ContentDownload","inside updateQueues SOA: " + strSOA + " ContentID: " + strContentId +
				" Cid: " + iCid + " Status: " + iDownloadStatus + " Browser: " + strBrowser);*/
		Connection con = null;
		CallableStatement callablestatement = null;
	    try {
	    	ds =getDataSource();
			con = ds.getConnection();
	        callablestatement = con.prepareCall("{call usp_UpdateQueues(?,?,?,?,?,?,?)}");
	        callablestatement.setString(1, strSOA);
	        callablestatement.setString(2, strContentId);
	        callablestatement.setInt(3, iCid);
	        callablestatement.setInt(4, iDownloadStatus);
	        callablestatement.setString(5, strBrowser);
	        callablestatement.setInt(6, iAccessFlag);
	        callablestatement.setInt(7, id);
	        callablestatement.execute();
	        callablestatement.close();
	        callablestatement = null;

	    }
	    catch (Exception e) {
	        Util.logError("ContentDownload","Error in usp_UpdateQueues function " + e.getMessage());
	    }
	    finally{
			     try{
		      	if(con!=null){
		            con.close();
		            con=null;
		          }
		     }catch(Exception e){ Util.logError("ContentDownload","updateQueues Method Close Connection "+e.getMessage());}
	        }
	}

	/**
	 * @param strDA
	 * @param strNormalContent
	 * @param iCid
	 * @return
	 */
	public HashMap getContentURL(String strDA, String strNormalContent, int iCid)
	{
	//	Util.logger(strDA, "Inside getContentURL");

		HashMap hmContent = null;

		String strContentURL = null;
		String strFileName = null;

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;

		try
		{
			ds =getDataSource();
			conn = ds.getConnection();
			System.out.println (" Inside getContentURL: " + strNormalContent + " " + iCid);
			pstmt = conn.prepareStatement("select ContentURL, FileName from ContentURL where ContentId =? AND CID=?");
			pstmt.setString(1, strNormalContent);
			pstmt.setInt(2, iCid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				strContentURL =rs.getString(1).trim();
				strFileName=rs.getString(2).trim();
				}
			hmContent = new HashMap();
			hmContent.put("ContentURL", strContentURL);
			hmContent.put("FileName", strFileName);
		}
		catch(Exception E)
		{
			Util.logError(strDA,"Error occured in getContentURL  "+E);
		 }
		finally
		 {
		    try
		    {
		    	 if(rs!=null)
		    	 {
		            rs.close();
		            rs=null;
		         }
		    }catch(Exception e){ Util.logError(strDA,"getContentURL Method Close result set  "+e.getMessage());}
		    try{
		    	if(pstmt!=null){
		            pstmt.close();
		            pstmt=null;
		            }
		    }catch(Exception e){ Util.logError(strDA,"getContentURL Method Close Statement "+e.getMessage());}
		    try{
		      	if(conn!=null){
		            conn.close();
		            conn=null;
		          }
		     }catch(Exception e){ Util.logError(strDA,"getContentURL Method Close Connection "+e.getMessage());}
		}
		return hmContent;

	}


	/**
	 * @param strMsgId
	 * @param strSOA
	 * @param strDA
	 * @param messages
	 * @param strOpCode
	 * @param strFlags
	 * @param strShortCodeType
	 */
	public String sendMessage(String strMsgId, String strSOA, String strDA,
			String messages, String strOpCode, String strShortCodeType, int iCid) {

		String responseString = null;
		String Flags = "2";
		String MtMsgId = null;
		String strPostingURL = null;

		HashMap postingURL = null;
		boolean success = false;

		try {
			/*Util.logger(strDA, "In sendMessage() MsgId: " + strMsgId + "SOA: "
					+ strSOA + "DA: " + strDA + "Content: " + messages
					+ "OpCode: " + strOpCode + "ShortCodeType: "
					+ strShortCodeType);*/
			responseString = messages;
			long id = System.currentTimeMillis();

			// Set the flags to 102 to get the delivery receipt
			if(Constants.CHARGED_SHORTCODE_TYPE.equals(strShortCodeType))
				Flags="102";

			postingURL = getPostingURL(strDA, strOpCode, strShortCodeType, iCid);
			strDA = (String)postingURL.get("DA");
			strPostingURL = (String)postingURL.get("URL");
			//Util.logger(strDA, "DA:= " + strDA + "Posting URL: " + strPostingURL);

			//  Instantiate an HttpClient
			HttpClient client = new HttpClient();

			//  Setting Timeout period of 10 seconds
			client.setTimeout(10000);
			client.setConnectionTimeout(30000);


			PostMethod postMethod = new PostMethod(strPostingURL.toString());

			//			 Set parameters on POST

			postMethod.setParameter("MsgId", new Long(id).toString());
			postMethod.addParameter("DA", strSOA);
			postMethod.addParameter("SOA", "Hujairat");
			postMethod.addParameter("Flags", Flags);
			postMethod.addParameter("Content", responseString);
			postMethod.addParameter("OpCode", strOpCode);
			postMethod.addParameter("lang", "A");

			client.executeMethod(postMethod);
			int statusCode = postMethod.getStatusCode();
			//Util.logger(strDA, "statusCode: " + statusCode);

			// If http status is OK proceed
			if (statusCode == HttpStatus.SC_OK) {
				String responseMessage = postMethod.getResponseBodyAsString();
				MtMsgId = responseMessage.substring(6).trim();
				/*Util.logger(strDA, "Response String: " + responseMessage
						+ " MtMsgId: " + MtMsgId);*/

				success = true;
			}
			//	release connection
			postMethod.releaseConnection();

			responseString = Util.getNormal(responseString);
			updateContestLog(strMsgId, strSOA, strDA, responseString);

		} catch (Exception e) {
			Util.logError(strDA, "Error in sending message " + e.getMessage());
		}

		return MtMsgId;
	}

	/**
	 * @param DA
	 * @param OpCode
	 * @param strShortCodeType
	 * @return
	 */
	public HashMap getPostingURL(String DA, String OpCode,
			String strShortCodeType, int iCid) {

		//Util.logger(DA, "In postingURL OpCode: " + OpCode + " shortCodeType: " + strShortCodeType + " Cid: " + iCid);

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String URL = null;
		String strDA = null;

		HashMap postingURL = new HashMap();

		try {
			ds = getDataSource();
			conn = ds.getConnection();
			pstmt = conn
					.prepareStatement("select ShortCode,url from SC_URL_MAPPING where shortCodeType = ? and OpCode = ? and Cid = ?");
			pstmt.setString(1, strShortCodeType);
			pstmt.setInt(2, Integer.parseInt(OpCode));
			pstmt.setInt(3, iCid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				strDA = rs.getString(1).trim();
				URL = rs.getString(2).trim();
			}
			postingURL.put("DA", strDA);
			postingURL.put("URL", URL);
			//Util.logger(DA, "URL" + URL);

		} catch (Exception E) {
			Util.logError(DA, "Error occured in Selecting posting URL"
					+ E.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (Exception e) {
				Util.logError(DA, "getPostingURL Method Close result set  "
						+ e.getMessage());
			}
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception e) {
				Util.logError(DA, "getPostingURL Method Close Statement "
						+ e.getMessage());
			}
			try {
				if (conn != null) {
					conn.close();
					conn = null;
				}
			} catch (Exception e) {
				Util.logError(DA, "getPostingURL Method Close Connection "
						+ e.getMessage());
			}
		}
		return postingURL;
	}


	/**
	 * @param SOA
	 * @param DA
	 * @param query
	 * @return
	 * This method checks the subscription master table for the status of the subscriber
	 */
	public HashMap subscriberStatus(String SOA, String DA, String query) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap userInfo = new HashMap();

		int Id = 0;
		int status = 0;

		String strFromDate = null;
		String strCid = null;
		try {
			ds = getDataSource();
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, SOA.trim());
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Id = rs.getInt("Id");
				status = rs.getInt("status");
				strFromDate = rs.getString("fromdate");
				strCid = rs.getString("cid");
			}
			userInfo.put("Id", new String("" + Id));
			userInfo.put("status", new String("" + status));
			userInfo.put("fromdate", new String("" + strFromDate));
			userInfo.put("cid", new String("" + strCid));

		} catch (Exception e) {
			Util.logError(DA, "subscriberStatus Method  " + e.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (Exception e) {
				Util.logError(DA, "subscriberStatus Method Close result set  "
						+ e.getMessage());
			}
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception e) {
				Util.logError(DA, "subscriberStatus Method Close Statement "
						+ e.getMessage());
			}
			try {
				if (conn != null) {
					conn.close();
					conn = null;
				}
			} catch (Exception e) {
				Util.logError(DA, "subscriberStatus Method Close Connection "
						+ e.getMessage());
			}
		}
		return userInfo;

	}


	/**
	 * @param strSOA
	 * @param strDA
	 * @param strMessage
	 * @param strMTMsgId
	 * @param iUserStatus
	 * @param iCid
	 * @throws Exception
	 */
	public  void insertMTMessageQueues(String strSOA,String strDA,String strMessage,String strMTMsgId,int iUserStatus,int iCid, String strOpCode, String strMessageType) throws Exception
	{

		Connection con = null;
		CallableStatement callablestatement = null;

	    try
	    {
	    	ds =getDataSource();
			con = ds.getConnection();
	       	//Util.logger(strDA,"inside insertMTMessageQueues");
	       	//Util.logger(strDA,"In insertMTMessageQueues SOA: "+ strSOA + "DA: " + strDA + "User Status: " + iUserStatus + "Cid: " + iCid);
	        callablestatement = con.prepareCall("{call usp_insertMTMessageQueues(?,?,?,?,?,?,?,?,?)}");

	        callablestatement.setString(1, strSOA);
	        callablestatement.setString(2, strDA);
	        callablestatement.setString(3, Util.getNormal(strMessage));
	        callablestatement.setString(4, strMTMsgId);
	        callablestatement.setInt(5, iUserStatus);
	        callablestatement.setInt(6, 1);
	        callablestatement.setInt(7, iCid);
	        callablestatement.setString(8, strOpCode);
	        callablestatement.setString(9, strMessageType);
	        callablestatement.execute();
	        callablestatement.close();
	        callablestatement = null;

	     } catch (Exception e) {
	        Util.logError(strDA,"Error in insertMTMessageQueues function " + e.getMessage());
	        throw e;
	    }finally{
			     try{
		      	if(con!=null){
		            con.close();
		            con=null;
		          }
		     }catch(Exception e){ Util.logError(strDA,"insertMTMessageQueues Method Close Connection "+e.getMessage());}
	        }
	}
	//Added on jan 5 2012 by sunayna for sending WAP content for new users
	public String sendContent(String strDA,int iCid, String ScheduledContent, String strSOA, String strOpCode) {

		Util.logger("SendContent","In  sendContentProcess()...Cid: " + iCid + " ScheduledContent: " + ScheduledContent + " SOA: " + strSOA);
		String strMtMsgId = null;
		String strRequestParam = null;
		String strURL = null;
		String strMsgId = null;
		HashMap hmContent = null;

		try
		{
			strRequestParam = strSOA + '|' + ScheduledContent ;
			strURL = "http://168.187.115.163:8080/HoujeratSubscription/CD";
			strURL += "?Req=" + strRequestParam;
			Util.logger("SendContent","In  sendContentProcess() URL: " + strURL);
			strMtMsgId = sendServiceIndication(strMsgId, strSOA, strDA, strURL, strOpCode, iCid);
		}

		catch(Exception e){
			Util.logError("SendContent", "Error in sendContent function "+ e.getMessage());
		}
		return strMtMsgId;



	}
	public String sendServiceIndication(String strMsgId, String strSOA,
			String strDA, String strContentURL, String strOpCode, int iCid) {

		Util.logger("SendContent", "In sendServiceIndication SOA: " + strSOA + " DA: "
				+ strDA + " ContentURL: " + strContentURL + " OpCode: "
				+ strOpCode + " Cid: " + iCid);

		long id = System.currentTimeMillis();

		String Flags = "9"; // WAP
		String strServiceIndicationUrl = null;
		String strShortCodeType = "F";
		String strMtMsgId = null;
		try {
			//
			strServiceIndicationUrl = getServiceIndicationUrl(strDA, iCid);

			

			// Instantiate an HttpClient
			HttpClient client = new HttpClient();

		//  Setting Timeout period of 10 seconds
			client.setTimeout(10000);
			client.setConnectionTimeout(30000);

			PostMethod postMethod = new PostMethod(strServiceIndicationUrl);

			Util.logger("SendContent", "Service Indication URL: "
					+ strServiceIndicationUrl);

			siwappush = new SiWapPush(strContentURL, "Houjerat");

			strContentURL = siwappush.toSmsBinary();
			//strContentURL = strContentURL.substring(14);
			Util.logger("SendContent", "In sendServiceIndication ContentURL: " + strContentURL);

			postMethod.setParameter("MsgId", new Long(id).toString());
			postMethod.addParameter("DA", strSOA);
			postMethod.addParameter("SOA", "Hujairat");
			postMethod.addParameter("Flags", Flags);
			postMethod.addParameter("Content", strContentURL);
			postMethod.addParameter("lang", "A");


			client.executeMethod(postMethod);
			int statusCode = postMethod.getStatusCode();
			System.out.println(statusCode);
			

			// If http status is OK proceed
			if (statusCode == HttpStatus.SC_OK) {
				String responseMessage = postMethod.getResponseBodyAsString();
				strMtMsgId = responseMessage.substring(6).trim();
				Util.logger("SendContent","Response String in sendServiceIndication(): " + responseMessage
						+"MsgId: " + strMsgId + " MtMsgId: " + strMtMsgId);
			}			
			
			// release connection
			postMethod.releaseConnection();
			
			
			
			// }
		} catch (Exception e) {
			Util.logError("SendContent", "Error in sendServiceIndication "
					+ e.getMessage());
		}
		return strMtMsgId;
	}
	
	public  String getServiceIndicationUrl(String strDA, int iCid ){

		Util.logger("SendContent","inside getServiceIndicationUrl: " + strDA);
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		String strServiceIndicationUrl="";


		try
		{
			ds =getDataSource();
			con = ds.getConnection();
			pstmt = con.prepareStatement("select URL from SC_URL_MAPPING where shortcode=? and ShortCodeType = 'F' and cid = ?");
			pstmt.setString(1, strDA);
			pstmt.setInt(2, iCid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				strServiceIndicationUrl =rs.getString(1).trim();
				}
			Util.logger("SendContent","Service Indication URL: " + strServiceIndicationUrl);
			rs.close();
            rs=null;
            pstmt.close();
            pstmt=null;
			con.close();
			con = null;


		}catch(Exception E)
		{
			Util.logError("SendContent","Error occured in getting  getServiceIndicationUrl  "+E);
		 }
		finally
		 {
		    try
		    {
		    	 if(rs!=null)
		    	 {
		            rs.close();
		            rs=null;
		         }
		    }catch(Exception e){ Util.logError("SendContent","getServiceIndicationUrl Method Close result set  "+e.getMessage());}
		    try{
		    	if(pstmt!=null){
		            pstmt.close();
		            pstmt=null;
		            }
		    }catch(Exception e){ Util.logError("SendContent","getServiceIndicationUrl Method Close Statement "+e.getMessage());}
		    try{
		      	if(con!=null){
		            con.close();
		            con=null;
		          }
		     }catch(Exception e){ Util.logError("SendContent","getServiceIndicationUrl Method Close Connection "+e.getMessage());}
		}
		return strServiceIndicationUrl;

	}

}
