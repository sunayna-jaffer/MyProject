
<%@ page language="java" import="java.util.*" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>HoujeratSubscription  </title>
</head>

<body bgcolor="white">

<form method="POST" action="./Login">
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" width="100%" height="100%" id="AutoNumber1">
    <tr>
      <td width="100%" bgcolor="#FF9900">
      <p align="center"><font face="Arial Black" size="6">Houjerat Subscription</font></td>
    </tr>
    <tr>
      <td width="100%" height="90%">
      <table border="0" cellpadding="2" style="border-collapse: collapse" width="100%" id="AutoNumber2">
        <tr>
          <td width="33%">&nbsp;</td>
          <td width="33%">&nbsp;</td>
          <td width="34%">&nbsp;</td>
        </tr>
        <tr>
          <td width="33%">&nbsp;</td>
          <td width="33%">
          <table border="0" cellpadding="2" style="border-collapse: collapse" width="100%" id="AutoNumber3">
            <tr>
              <td width="25%" bgcolor="#FF9900">&nbsp;</td>
              <td width="13%" bgcolor="#FF9900"><font face="Arial Black">Login</font></td>
              <td width="12%" bgcolor="#FF9900">&nbsp;</td>
              <td width="50%" bgcolor="#FF9900">
              <input type="text" name="login" size="20"></td>
            </tr>
            <tr>
              <td width="50%" colspan="3">&nbsp;</td>
              <td width="50%">&nbsp;</td>
            </tr>
            <tr>
              <td width="25%" bgcolor="#FF9900">&nbsp;</td>
              <td width="13%" bgcolor="#FF9900"><font face="Arial Black">Password</font></td>
              <td width="12%" bgcolor="#FF9900">&nbsp;</td>
              <td width="50%" bgcolor="#FF9900">
              <input type="password" name="passwd" size="20"></td>
            </tr>
            <tr>
              <td width="50%" colspan="3">&nbsp;</td>
              <td width="50%">&nbsp;</td>
            </tr>
            <tr>
              <td width="50%" colspan="3" bgcolor="#FF9900">
              <p align="center"><input type="submit" value="Submit" name="B1"></td>
              <td width="50%" bgcolor="#FF9900">
              <p align="center"><input type="reset" value="Reset" name="B2"></td>
            </tr>
          </table>
          </td>
          <td width="34%">&nbsp;</td>
        </tr>
        <tr>
          <td width="33%">&nbsp;</td>
          <td width="33%">&nbsp;</td>
          <td width="34%">&nbsp;</td>
        </tr>
      </table>
      </td>
    </tr>
    <tr>
      <td width="100%" bgcolor="#FF9900">
      <p align="center"><b><font face="Verdana" size="1">Copyright (C) 2006 
      MobiLink W.L.L</font></b></td>
    </tr>
  </table>
</form>

</body>

</html>