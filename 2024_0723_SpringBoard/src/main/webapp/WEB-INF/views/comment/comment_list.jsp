<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<!-- Page Menu -->
<c:if test="${ not empty list }">
<div style="font-size:10px;">
	${ pageMenu }
</div>
</c:if>

<!-- <ul class="pagination">
  <li><a href="#" onclick="comment_list(1);">1</a></li>
  <li><a href="#" onclick="comment_list(2);">2</a></li>
  <li><a href="#" onclick="comment_list(3);">3</a></li>
  <li><a href="#" onclick="comment_list(4);">4</a></li>
  <li><a href="#"onclick="comment_list(5);">5</a></li>
</ul> -->

<!-- for(CommentVo cmt : list) -->
<c:forEach var="vo" items="${ list }">
	<!-- 이름, 날짜, 내용 출력  -->
	<div>${ vo.mem_name }</div>
	<div>${ vo.cmt_regdate }</div>
	<div>${ vo.cmt_content }</div>
	<hr>
	
</c:forEach>

</body>
</html>