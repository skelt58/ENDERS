<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.12
	*	설명 : 404 에러 페이지
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>404 ERROR</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Cache-Control" content="No-Cache"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>

<body style="background-color:#eeeeee;">
<table>
	<tr>
		<td>status_code</td>
		<td><c:out value="${status_code}"/></td>
	</tr>
	<tr>
		<td>message</td>
		<td>페이지를 찾을 수 없습니다.</td>
	</tr>
</table>
</body>

</html>
