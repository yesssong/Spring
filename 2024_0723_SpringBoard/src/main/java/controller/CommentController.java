package controller;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.CommentDao;
import util.MyCommon;
import util.Paging;
import vo.CommentVo;

@Controller
@RequestMapping("/comment/")  // 대표경로 붙이기 -> 경로 계속 써야하므로 미리 붙인 것
public class CommentController {
	
	@Autowired   // injection 받기 -> 자동으로 연결해줘
	CommentDao comment_dao;
	
	@Autowired
	HttpServletRequest request;
	
	// 잘 생성되나 확인~
	public CommentController() {
		// TODO Auto-generated constructor stub
	System.out.println("--CommentController()--");
	}
	
	// 조회
	@RequestMapping("list.do")
	public String list(int b_idx,
					   @RequestParam(name="page", defaultValue="1") int nowPage,
					   Model model) {
		
		//가져올 범위 계산
		int start = (nowPage-1) * MyCommon.Comment.BLOCK_LIST + 1;
		int end   = start + MyCommon.Comment.BLOCK_LIST - 1;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("b_idx", b_idx);
		map.put("start", start);
		map.put("end", end);
		
		List<CommentVo> list = comment_dao.selectList(map);		// Dao 추가
		
		//Paging Menu 만들기
		// b_idx의 댓글 갯수 구하기
		int rowTotal = comment_dao.selectRowTotal(b_idx);		// Dao 추가
		
		String pageMenu = Paging.getCommentPaging(nowPage,
												  rowTotal,
												  MyCommon.Comment.BLOCK_LIST,
												  MyCommon.Comment.BLOCK_PAGE);	
		
		//request binding
		model.addAttribute("list", list);
		model.addAttribute("pageMenu", pageMenu);
		
		return "comment/comment_list";		// spring mvc 구조 -> jsp 붙임 comment폴더 안에 comment_list.jsp 파일 만들기(보여질 화면 페이지)
	}
	
	// 추가
	// /comment/insert.do?cmt_content=내용&b_idx=5&mem_idx=2&mem_name=일길동
	@RequestMapping(value="insert.do", produces="applcation/json; charset=utf-8;")  // ; 세미콜론 주의
	@ResponseBody
	public String insert(CommentVo vo) {
		
		// ip
		String cmt_ip = request.getRemoteAddr();
		vo.setCmt_ip(cmt_ip);
		
		// enter 처리
		String cmt_content = vo.getCmt_content().replaceAll("\n", "<br>");
		vo.setCmt_content(cmt_content);
		
		int res = comment_dao.insert(vo);
		
		// json데이터 받기
		JSONObject json = new JSONObject();
		json.put("result", res=1);		// res=1(행 하나 추가 됐느냐) -> 제대로 insert 됐는지 묻는 것
										// {"result":true} or {"result":false}로 처리
		
		return json.toString();		// json 데이터 반환
	}
	
	
	
	
	
	
	
	
	
}
