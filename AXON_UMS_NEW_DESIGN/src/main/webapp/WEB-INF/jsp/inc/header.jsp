<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.06
	*	설명 : 공통 헤더(header) 파일
	**********************************************************/
--%>
<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<c:set var="title"         value="AXON UMS DESIGN"	scope="request"></c:set>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="x-ua-compatible" content="IE=EDGE">
<meta name="Author" content="enders">
<meta name="keywords" content="UMS">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${title}</title>
<link rel="shortcut icon" href="<c:url value='/img/favicon.ico'/>" type="image/x-icon">
<link rel="icon" href="<c:url value='/img/favicon.ico'/>" type="image/x-icon">
<link rel="stylesheet" href="<c:url value='/css/reset.css'/>">
<link rel="stylesheet" href="<c:url value='/css/jquery-ui.css'/>">
<link rel="stylesheet" href="<c:url value='/css/common.css'/>">
<link rel="stylesheet" href="<c:url value='/css/style.css'/>">
<link rel="stylesheet" href="<c:url value='/css/style_ems.css'/>">
<script type="text/javascript" src="<c:url value='/js/jquery-2.1.1.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/common.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/ems.js'/>"></script>

</head>
