<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
	width: 1000px;
	margin: auto;
	margin-top: 50px;
	
}

#title{
	text-align: center;
	font-weight: bold;
	font-size: 26px;
	color: blue;
	text-shadow: 1px 1px 1px black;
}

/* 제목 길이 길어졌을 때 ...으로 표시 */
.b_subject{
	 display: inline-block;
	 width: 300px;
	 
	 /* ellipsis */
     overflow: hidden;
	 white-space: nowrap;
	 text-overflow: ellipsis;
	 word-break: break-all;
	 
	 vertical-align: middle;
}
</style>

<script type="text/javascript">
	function insert_form() {
		
		// 로그인 여부 체크
		if("${ empty user }" == "true"){
			
			if(confirm("글쓰기는 로그인후 가능합니다\n 로그인 하시겠습니까?")==false) return;
			
			// 로그인 폼으로 이동시키기
			location.href="../member/login_form.do";
			
			return ;
		}
		// 새 글쓰기 폼 띄우기
		location.href="insert_form.do";
	}
</script>

</head>

<body>

<div id="box">

	<h3 id="title">게시판</h3>

		<div class="row" style="margin-top: 30px; margin-bottom: 5px;">
			<div class="col-sm-4">
				<input class="btn btn-info" type="button" value="글쓰기"
					   onclick="insert_form();">
			</div>
			<div class="col-sm-8" style="text-align: right;">
				<!-- 로그인 안 된 경우 -->
				<c:if test="${ empty user }">
					<input class="btn btn-info" type="button" value="로그인" onclick="location.href='../member/login_form.do'">
				</c:if>
				
				<!-- 로그인 된 경우 -->
				<c:if test="${ not empty user }">
					<b>${ user.mem_name }</b>님 환영합니다
					<input class="btn btn-info" type="button" value="로그아웃"  onclick="location.href='../member/logout.do'">	
				</c:if>
			</div>
		</div>
		
	<table class="table">
		<tr class="success">
			<th>번호</th>
			<th width="50%">제목</th>
			<th>작성자</th>
			<th>작성일자</th>
			<th>조회수</th>
		</tr>
		<!-- 데이터 없는 경우 -->
		<c:if test="${ empty list }">
			<tr>
				<td colspan="5" align="center">
					<font color="red">게시물이 없습니다</font>
				</td>
			</tr>
		</c:if>
		
		<!-- 데이터 있는 경우 = 게시물 있을 때 -->
		<c:forEach var="vo" items="${ list }">
			<tr>
				<td>${vo.no}<%-- (${ vo.b_idx }) --%></td>
				<td>
				  <span class="b_subject">
					<!-- 답글 일 경우 b_depth만큼 들여쓰기 -->
					<c:forEach begin="1" end="${ vo.b_depth }">
					&nbsp;&nbsp;&nbsp;
					</c:forEach>
					
					<!-- 답글일 경우 글 앞에 ㄴ <- 이거 붙일 것 -->
					<c:if test="${ vo.b_depth ne 0}">
					ㄴ
					</c:if>
					
					<!-- 삭제 된 게시물 -->
					<c:if test="${ vo.b_use eq 'n' }">
						<font color="re
						
						
						
						
						
						
						
						d">(삭제)${ vo.b_subject }</font>
					</c:if>
					
					<!-- 삭제 안 된 게시물 -->
	                 <c:if test="${ vo.b_use eq 'y' }">
		                 <a href="view.do?b_idx=${ vo.b_idx }">
		                      ${ vo.b_subject }
		                 </a>
	                 </c:if>
                 </span>
                 
                 <!-- 댓글갯수 배지 -->
                 <c:if test="${ vo.cmt_count ne 0 }">
                      <span class="badge">${ vo.cmt_count }</span>
                 </c:if>
				</td>
				<td>${ vo.mem_name }</td>
              	<td>${ vo.b_regdate }</td>
              	<td>${ vo.b_readhit }</td>
			</tr>
		</c:forEach>
	</table>

	<!-- pageMenu -->
	<div style="text-align: center;">
		${ pageMenu }
	</div>
</div>

</body>
</html>