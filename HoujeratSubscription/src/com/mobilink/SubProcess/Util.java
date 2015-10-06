package com.mobilink.SubProcess;

/*
 * Created on 18 April 2010
 *
 */

/**
 * @author Sheril
 *
 * This class contains the utility methods
 */

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.Calendar;



public class Util {

	public static void logger(String DA,String Message) {

		String dirName=Constants.LOGGER;
		String serviceName = DA;
		String logDate = "";

		File logDir = new File("./"+dirName);
		if (!logDir.exists()) {
			logDir.mkdir();
		} else {
			if (logDir.isFile()) {
				logDir.mkdir();
			}
		}
		File serviceDir = new File("./"+dirName+"/" + serviceName);
		if (!serviceDir.exists()) {
			serviceDir.mkdir();
		} else {
			if (serviceDir.isFile()) {
				serviceDir.mkdir();
			}
		}

		File successDir = new File("./"+dirName+"/" + serviceName + "/success");
		if (!successDir.exists()) {
			successDir.mkdir();
		} else {
			if (successDir.isFile()) {
				successDir.mkdir();
			}
		}
		try {
			PrintWriter pw = new PrintWriter(new FileOutputStream("./"+dirName+"/"+ DA + "/success/" + getLogDate(), true));
			pw.println(new java.util.Date() + "\t:\t[WELCOME] " +Message);
			pw.flush();
			pw.close();
		} catch (Exception ee) {
	  }
	}


	public static void logError(String DA, String Error) {

		String dirName=Constants.LOGGER;
		String serviceName = DA;
		String logDate = "";

		File logDir = new File("./"+dirName);
		if (!logDir.exists()) {
			logDir.mkdir();
		} else {
			if (logDir.isFile()) {
				logDir.mkdir();
			}
		}
		File serviceDir = new File("./"+dirName+"/" + serviceName);
		if (!serviceDir.exists()) {
			serviceDir.mkdir();
		} else {
			if (serviceDir.isFile()) {
				serviceDir.mkdir();
			}
		}
		File errorDir = new File("./"+dirName+"/" + serviceName + "/error");
		if (!errorDir.exists()) {
			errorDir.mkdir();
		} else {
			if (errorDir.isFile()) {
				errorDir.mkdir();
			}
		}
		try {
			PrintWriter pw = new PrintWriter(new FileOutputStream("./"+dirName+"/"+ DA + "/error/" + getLogDate(), true));
			pw.println(new java.util.Date() + "\t:\t " + Error);
			pw.flush();
			pw.close();
		} catch (Exception ee) {
			System.out.println("Error"+ee);
			}
	}

	public static String getUnicode(String message) {
		String unicodeContent = "";
		try {
			int cc = 0;
			StringReader sr = new StringReader(message);
			while ((cc = sr.read()) != -1) {
				String hex = Integer.toHexString(cc);
				while (hex.length() < 4)
					hex = "0" + hex;
				unicodeContent = unicodeContent + hex;
			}
		} catch (Exception e) {
			//error=e.getMessage();
		}
		unicodeContent = unicodeContent.toUpperCase().substring(0);
		return unicodeContent;
	}

	/**
	 * @param Content
	 * @return
	 *
	 * This method converts unicode value to normal content
	 */
	public static String getNormal(String Content) {
		String normalContent = "";
		try {
			//Content = uniRemoveJunk(Content);
			StringWriter sw = new StringWriter();
			for (int i = 0; i < Content.length(); i += 4) {
				sw.write(Integer.valueOf(Content.substring(i, i + 4), 16)
						.intValue());
			}
			sw.flush();
			sw.close();
			normalContent = sw.toString();
		} catch (Exception convertError) {
		}
		return normalContent;
	}

	/**
	 * @param str
	 * @param pattern
	 * @param replace
	 * @return
	 */
	public static String replace(String str, String pattern, String replace) {
        int s = 0;
        int e = 0;
        StringBuffer result = new StringBuffer();

        while ((e = str.indexOf(pattern, s)) >= 0) {
            result.append(str.substring(s, e));
            result.append(replace);
            s = e+pattern.length();
        }
        result.append(str.substring(s));
        return result.toString();
    }

	/**
	 * @param str
	 * @return
	 */
	public static String uniRemoveJunk(String str) {
		String s = "";
		if(str != null && str.length() > 0) {
			// remove Right-to-left mark U+200F
			s = replace(str, "200F", " ");
			// remove Allow Line-break Space U+0020
			s = replace(s, "0020", " ");
		}
		return s;
	}

	public static String getLogDate() {
		String logDate = "";
		try {
			Calendar c = Calendar.getInstance();
			String mnth = "" + (c.get(Calendar.MONTH) + 1);
			String dt = "" + c.get(Calendar.DATE);

			if (mnth.length() == 1)
				mnth = "0" + mnth;
			if (dt.length() == 1)
				dt = "0" + dt;
			logDate = c.get(Calendar.YEAR) + "" + mnth + "" + dt;
		} catch (Exception ee) {
		}
		return logDate;
	}

 public static String getIntContent(String Content) {
		String IntContent = "";
		for(int i=0;i<Content.length();i++){
			String c = ""+Content.charAt(i);
			try{
				int j = Integer.parseInt(c);
				c = ""+j;
			   IntContent =IntContent+c;
			}catch(Exception e){
			}
		}
		return IntContent;
	}

 public static String tounicode(String message)	{
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


}


