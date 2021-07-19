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
<c:set var="title"			value="AXON UMS NEW"	scope="request"></c:set>
<!DOCTYPE html>
<html>
<head>
<title>${title}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Cache-Control" content="No-Cache"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/layout.css'/>"></link>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/jquery-ui.css'/>"></link>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/ui.jqgrid.css'/>"></link>
<script type="text/javascript" src="<c:url value='/js/jquery-3.6.0.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.jqGrid.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/i18n/grid.locale-kr.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/ums.common.js'/>"></script>
</head>

<body style="background-color:#eeeeee;">

