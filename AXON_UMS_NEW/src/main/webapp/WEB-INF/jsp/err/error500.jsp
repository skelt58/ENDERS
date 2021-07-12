<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.12
	*	설명 : 500 에러 페이지
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>500 ERROR</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Cache-Control" content="No-Cache"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>

<body style="background-color:#eeeeee;">
오류내용
<br/>
<table>
	<tr>
		<td>status_code</td>
		<td><c:out value="${status_code}"/></td>
	</tr>
	<tr>
		<td>message</td>
		<td><c:out value="${message}"/></td>
	</tr>
	<tr>
		<td>exception_code</td>
		<td><c:out value="${exception_code}"/></td>
	</tr>
	<tr>
		<td>exception</td>
		<td><c:out value="${exception}"/></td>
	</tr>
	<tr>
		<td>request_url</td>
		<td><c:out value="${request_url}"/></td>
	</tr>
	
</table>
</body>

</html>
