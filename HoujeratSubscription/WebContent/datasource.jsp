<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<sql:setDataSource
	var="ds"
	driver="net.sourceforge.jtds.jdbcx.JtdsDataSource"
	url="jdbc:jtds:sqlserver://192.168.1.220:850/HoujeratSubscription"
	user="mluser"
	password="dbuser"
/>

<sql:setDataSource
	var="ds1"
	driver="net.sourceforge.jtds.jdbcx.JtdsDataSource"
	url="jdbc:jtds:sqlserver://192.168.1.220:850/HoujeratSubscription"
	user="mluser"
	password="dbuser"
/>

