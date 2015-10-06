package com.mobilink.SubProcess;
/*
 * Created on 01 August, 2010
 */

/**
 * @author Sheril
 *
 * This class declares the constants
 */
public class Constants {

	// General constants
	public static final String LOGGER = "HoujeratSubscription";
	public static final String DS_NAME = "java:HoujeratSubscription";

	public static final String FREE_SHORTCODE_TYPE = "F";
	public static final String CHARGED_SHORTCODE_TYPE = "C";


	public static final String CHECK_STATUS_URL = "http://192.168.1.221:54321/SMSGateway/CheckStatus?";
	public static final String WATANIYA_CHECK_STATUS_URL = "http://192.168.1.222:12345/SMSGateway/CheckStatus?";
	public static final String FOREIGN_CHECK_STATUS_URL = "http://192.168.1.221:8080/SMSGateway/CheckStatus?";
	public static final String IRAQ_STATUS_URL = "http://172.16.3.76:54321/SMSGateway/CheckStatus?";
	public static final String STC_CHECK_STATUS_URL = "http://192.168.1.61:8080/SMSGateway/CheckStatus?";
	public static final String MOBILY_CHECK_STATUS_URL = "http://192.168.1.61/SMSGateway/CheckStatus?";


	public Constants() {
		super();
		// TODO Auto-generated constructor stub
	}

}
