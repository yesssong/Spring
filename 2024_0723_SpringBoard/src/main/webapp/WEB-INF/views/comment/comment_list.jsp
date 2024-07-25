<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<script type="text/javascript">

	function comment_delete(cmt_idx){
		
		if(confirm("정말 삭제하시겠습니까?")==false)return;
		
		//ajax 이용해서 삭제 요청
		// comment_list가 작동되는 곳이 board_view이므로 jquery $ 사용 가능(board_view 부트스트랩 코드 안에 jquery 있음)
		$.ajax({
			url		:	"../comment/delete.do",
			data	:	{"cmt_idx":cmt_idx},
			dataType:	"json",
			success	: 	function(res_data){
				
				//res_data = {"result" : true } or {"result" : false }
				if(res_data==false){
					alert("삭제 실패");
					return;
				}
				
				comment_list(g_page); // g_page = 글로벌 페이지 -> 전역변수
				
			},
			error	:	function(err){
				alert(err.responseText);
			}
		});
	}

</script>

</head>
<body>

<!-- 댓글 페이지  -->
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
</ul> -->


<!-- 댓글 내용 -->
<!-- for(CommentVo cmt : list) -->
<c:forEach var="vo" items="${ list }">
	<!-- 자신의 글에 대해서만 삭제 메뉴 활성화 -->
		<c:if test="${ user.mem_idx eq vo.mem_idx }">
			<div style="text-align: right;">
				<input type="button" value="x" onclick="comment_delete('${vo.cmt_idx}');">
			</div>
		</c:if>
	<div>${ vo.mem_name }</div>
	<div>${ vo.cmt_regdate }</div>
	<div>${ vo.cmt_content }</div>
	<hr>
	
</c:forEach>

</body>
</html>