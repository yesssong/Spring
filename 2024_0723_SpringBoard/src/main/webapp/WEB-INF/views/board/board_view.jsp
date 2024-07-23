<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- BootStrap 3.x-->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>


<style type="text/css">

   #box{
      width: 800px;
      margin: auto;
      margin-top: 150px;
   }
   
   .common{
      border: 1px solid #cccccc;
      padding: 5px;
      margin-bottom: 5px;
      box-shadow: 1px 1px 1px #333333;
   }
   
   .content{
      min-height: 120px;
   }
   
</style>



</head>
<body>

	<div id="box">
		<!--BootStrap Panel-->
		<div class="panel panel-success">
			<!-- 제목 -->
			<div class="panel-heading">
				<h4><b>${ vo.mem_name }</b>님의 글</h4>  
			</div>
			
			<div class="panel-body">
				<div class="common subject">${ vo.b_subject }</div>
				<div class="common content">${ vo.b_content}</div>
				<div class="common regdate">${ vo.b_regdate }(${ vo.b_ip })</div>
				
				
				<div style="magin: 10px;">
					<input class="btn btn-primary" type="button" value="목록보기" 
						   onclick="location.href='list.do'">

					<!-- 로그인 된 상태에서만 글 등록 가능 -->
					<c:if test="${ not empty user }">
						<input class="btn btn-success" type="button" value="답글쓰기">
					</c:if>
					
					<!-- 글의 주인만 수정/삭제 가능 -->
					<!-- 글의 주인 mem_idx            현재 로그인된 mem_idx -->
					<c:if test="${ vo.mem_idx eq user.mem_idx }">
					<input class="btn btn-info" type="button" value="수정하기">
					<input class="btn btn-danger" type="button" value="삭제하기">
					</c:if>
					
				</div>
			</div>
		</div>
	</div>


</body>
</html>