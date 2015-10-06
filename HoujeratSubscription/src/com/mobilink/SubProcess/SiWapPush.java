package com.mobilink.SubProcess;

/*
 * Copyright (c) 2007
 * Art of Mobile
 * All rights reserved.
 *
 * This software is distributed under GNU General Public License Version 2.0
 * You shall use it and distribute only in accordance with the terms of the
 * License Agreement.
 *
 */


public class SiWapPush {

  private static final String HEXINDEX = "0123456789abcdef          ABCDEF";

  private String href;
  private String siId;
  private String action = "signal-medium";
  private String value;

  public SiWapPush(String href,String value) {
    setHref(href);
    setValue(value);
  }

  public String getHref() {
    return href;
  }

  public void setHref(String value) {
    this.href = value;
  }

  public String getSiId() {
    return siId;
  }

  public void setSiId(String value) {
    this.siId = value;
  }

  public String getAction() {
    if (action == null) {
      return "signal-medium";
    }
    else {
      return action;
    }
  }

  public void setAction(String value) {
    this.action = value;
  }

  public String getDecodedAction() {
    if (action.compareToIgnoreCase("signal-none") == 0)return "05";
    if (action.compareToIgnoreCase("signal-low") == 0)return "06";
    if (action.compareToIgnoreCase("signal-high") == 0)return "08";
    if (action.compareToIgnoreCase("signal-delete") == 0)return "09";
    return "07";

  }

  public String getValue() {
    return value;
  }

  public void setValue(String value) {
    this.value = value;
  }


  public String toSmsBinary() {
	  Util.logger("SendContent", "in toSmsBinary");
    /**
     GSM SMS User Data
     06: UDH Length which is 6
     05: 16 bit address
     04: Length(4)
     0B84: Destination Port(2948)
     23F0: Source Port(9200)

     Wireless Session Protocol
     90: Transaction ID
     06: PDU Type(Push)
     01: Headers Length is 1
     AE: Content-Type is application/vnd.wap.sic

     */
	  StringBuffer ud = null;
	  try
	  {
	    ud = new StringBuffer().append("0605040b8423f0900601ae");
	    ud.append(toWBXML());
	  }
	  catch(Exception e)
	  {
		  Util.logError("SendContent", "in toSmsBinary" + e.getMessage());
	  }
    return ud.toString();

  }

  public String toWBXML() {
	  Util.logger("SendContent", "in toWBXML");
    /**
     02: Version number - WBXML version 1.2
     05: SI 1.0 Public Identifier
     6A: Charset=UTF-8 (MIBEnum 106)
     00: String table length
     45: si, with content
     */
	  StringBuffer wbxml = new StringBuffer().append("02056a0045");
    wbxml.append(indicationToWBXML());
    wbxml.append("01");
    return wbxml.toString();
  }

  public String indicationToWBXML() {
	  Util.logger("SendContent", "in indicationToWBXML");
	  StringBuffer wbxml = new StringBuffer().append("c6");
    if (siId != null && siId.length() > 0) {
//si-id attribute
      wbxml.append("11");
// string literal
      wbxml.append("03");
// si-id string
      wbxml.append(hexDump(siId.getBytes()));
// end string
      wbxml.append("00");
    }

    if (href != null && href.length() > 0) {
      if (href.startsWith("http://www.")) {
        wbxml.append("0d");
        href = href.substring(11);
      }
      else if (href.startsWith("https://www.")) {
        wbxml.append("0f");
        href = href.substring(12);
      }
      else if (href.startsWith("http://")) {
        wbxml.append("0c");
        href = href.substring(7);
      }
      else if (href.startsWith("https://")) {
        wbxml.append("0e");
        href = href.substring(8);
      }
//String literal
      wbxml.append("03");
      wbxml.append(hexDump(href.getBytes()));
// end string
      wbxml.append("00");

      wbxml.append(getDecodedAction());

// >
      wbxml.append("01");
// now the text
      wbxml.append("03");

      byte[] bytes = value.getBytes();
      wbxml.append(hexDump(bytes));
      wbxml.append("00");

    }
    wbxml.append("01");
    return wbxml.toString();
  }

  public static byte[] hexToByte(String s) {
    int l = s.length() / 2;
    byte data[] = new byte[l];
    int j = 0;

    for (int i = 0; i < l; i++) {
      char c = s.charAt(j++);
      int n, b;

      n = HEXINDEX.indexOf(c);
      b = (n & 0xf) << 4;
      c = s.charAt(j++);
      n = HEXINDEX.indexOf(c);
      b += (n & 0xf);
      data[i] = (byte) b;
    }

    return data;
  }

  public static String hexDump(String buffer) {
    return hexDump(buffer.getBytes(), -1);
  }

  public static String hexDump(byte[] buffer) {
    return hexDump(buffer, -1);
  }

  public static String hexDump(byte[] buffer, int len) {
    if (buffer == null)return null;
    if (len == 0) {
      return "";
    }
    else if (len < 0 || len > buffer.length) {
      len = buffer.length;
    }
    String dump = "";
    try {
      for (int i = 0; i < len; i++) {
        dump += Character.forDigit( (buffer[i] >> 4) & 0x0f, 16);
        dump += Character.forDigit(buffer[i] & 0x0f, 16);
      }
    }
    catch (Throwable t) {
      t.printStackTrace(System.err);
      dump = null;
    }
    return dump;
  }



}

