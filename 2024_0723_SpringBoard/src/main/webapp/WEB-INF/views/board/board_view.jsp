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
      min-height: 150px;
   }
   
   #cmt_content{
   	  width: 100%;
   	  height: 80px;
   	  resize: none;
   }
   
   #btn_cmt_register{
   	  width: 100%;
   	  height: 80px;
   	  
   }
</style>

<script type="text/javascript">

	// 삭제 기능
	function del() {
		
		if(confirm("정말 삭제하시겠습니까?") == false) return;
		
		location.href="delete.do?b_idx=${vo.b_idx}";
		
	}// end:del()

</script>

<script type="text/javascript">

	// 댓글 쓰기 기능
	function comment_insert(){
		
		// 로그인 여부 체크
		if( "${ empty user }" == "true"){				// 로그인 안 되어 있다면
			if(confirm("로그인 후 댓글 작성이 가능합니다\n로그인하시겠습니까?")==false) return;
		
			// alert(location.href);
			// 로그인 창으로 이동
			location.href="../member/login_form.do?url=" + encodeURIComponent(location.href);
			return;
		}
		
		// 댓글쓰기 작성
		let cmt_content = $("#cmt_content").val().trim();
		if(cmt_content==''){
			alert("댓글내용을 입력해주세요");
			$("#cmt_content").val("");
			$("#cmt_content").focus();
			return;
		}
		
		//Ajax 통해서 댓글 등록
		$.ajax({
			url		:	"../comment/insert.do",
			data	:	{
						"cmt_content":cmt_content,
						"b_idx":"${vo.b_idx}",
						"mem_idx":"${user.mem_idx}",		// 로그인된 상태이므로 session에 user정보 있음
						"mem_name":"${user.mem_name}"		// 4개의 파라미터가 Vo에 있다 => CommentController로 가서 작업
						},
			dataType:	"json",
			success	:	function(res_data){
				// res_data = {"result":true}
			   
			   //작성했던 댓글 입력창에서 지우기
			   $("#cmt_content").val("");
				
				if(res_data.result == false){
					alert("댓글 등록 실패!");
					return;
				}
				comment_list(1);		// 함수 만들기 
			},
			error	:	function(err){
				alert(err.responseText);
			}
		});
		
	}// end: comment_insert()
	
	// 전역변수 선언
	var g_page=1;	// comment_list.jsp에서 사용
	
	// 댓글 목록 요청 코드
	function comment_list(page){
		
		g_page = page;	// comment_list.jsp 작업 후 추가한 내용
		
		$.ajax({
			url		:	"../comment/list.do",
			data	:	{"b_idx":"${vo.b_idx}", "page":page},
			success	:  	function(res_data){
				
				$("#comment_display").html(res_data);
			},
			error	: 	function(err){
				alert(err.responseText);
			}
		});
	}
	
	// 초기화 : 시작 시 이것부터 실행해라
	$(document).ready(function(){
		
		//현재 게시물에 달린 댓글 목록 출력
		comment_list(1);
	});

</script>
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
				
				
				<div>
					<input class="btn btn-primary" type="button" value="목록보기" 
						   onclick="location.href='list.do'">

					<!-- 로그인 된 상태에서만 글 등록 가능 + 메인 글에만 답글 달 수 있도록  +괄호()는 이해를 위해 쓴 것 -> 작성 안 해도 됨-->
					<c:if test="${ (not empty user) and (vo.b_depth eq 0) }">
						<input class="btn btn-success" type="button" value="답글쓰기"
							   onclick="location.href='reply_form.do?b_idx=${vo.b_idx}'">
					</c:if>
					
					<!-- 글의 주인만 수정/삭제 가능 -->
					<!-- 글의 주인 mem_idx            현재 로그인된 mem_idx -->
					<c:if test="${ vo.mem_idx eq user.mem_idx }">
					<input class="btn btn-info" type="button" value="수정하기"
						   onclick="location.href='modify_form.do?b_idx=${vo.b_idx}'">
					<input class="btn btn-danger" type="button" value="삭제하기"
						   onclick="del();">	<!-- delete()로 이름 지을 시 JS? 예약어 이므로 작동 안됨 -->	
					</c:if>
					
				</div>
			</div>
		</div>
		
		<!-- 댓글창 만들기 -->
		<div class="row">
			<div class="col-sm-10" style="border:1px soild; margin:0;" >
			   <textarea rows="3" id="cmt_content" placeholder="로그인 후 댓글 작성이 가능합니다!"></textarea>
			</div>
			<div class="col-sm-2">
			   <input id="btn_cmt_register" type="button"  value="댓글쓰기" 
			   		  onclick="comment_insert();">
			</div>
		</div>
		
		<hr>
		
		<div id="comment_display"></div>
		
		
		
	</div>
</body>
</html>