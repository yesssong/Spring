package controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import dao.BoardDao;
import vo.BoardVo;
import vo.MemberVo;

@Controller
@RequestMapping("/board/")
public class BoardController {
	

	public BoardController() {
		// TODO Auto-generated constructor stub
	System.out.println("--BoardController()--");
	}
	
	
	@Autowired
	HttpServletRequest request;
	
	@Autowired
	HttpSession session;
	
	
	// BoardDaoImpl로부터 주입 받음 => Dao가 생성 관리
	@Autowired
	@Qualifier("board_dao")  //이 이름을 가진 애를 참조해서 연결해라 => 식별자
	BoardDao board_dao;		 // 지금 필요하진 않음.. 한 인터페이스를 참조하는 객체가 여래 개일 경우 뭘 참조해서 연결할지 모르니 그것에 대한 구분을 해주는 것
	
			
	
	@RequestMapping("list.do")
	public String list(Model model) {
		
		// 세션에 기록되어 있는 show 삭제 => 새로고침으로 인한 조회수 증가 방지
		session.removeAttribute("show");
		
		
		//게시판 목록 가져오기
		List<BoardVo> list = board_dao.selectList();
		// System.out.println(list.size());
		
		// List 넘기기
		model.addAttribute("list", list);

		
		return "board/board_list";
	}
	
	// 새 글 쓰기 폼 띄우기
	@RequestMapping("insert_form.do")
	public String insert_form() {
		
		return "board/board_insert_form";
	}
	
	// /board/insert.do?b_subject=제목&b_content=내용
	@RequestMapping("insert.do")
	public String insert(BoardVo vo, RedirectAttributes ra) {
		
		MemberVo user = (MemberVo) session.getAttribute("user");
		
		if(user==null) {
			
			ra.addAttribute("reason", "session_timeout");
			return "redirect:../member/login_form.do";
		}
		
		// 사용자 정보 vo에 등록
		vo.setMem_idx(user.getMem_idx());
		vo.setMem_name(user.getMem_name());
		
		// 작성자 ip
		String b_ip = request.getRemoteAddr();
		vo.setB_ip(b_ip);
		
		// \n -> <br>
		String b_content = vo.getB_content().replaceAll("\n", "<br>");
		vo.setB_content(b_content);
		
		// db insert
		int res = board_dao.insert(vo);
		
		
		return "redirect:list.do";
	}
	
	// 상세보기
	// board/view.do?b_idx=5
	@RequestMapping("view.do")
	public String virw(int b_idx, Model model) {
		
		BoardVo vo = board_dao.selectOne(b_idx);
		
		// 조회수 증가
		// 최초 한 번 조회 시에만 조회수가 올라야 함
		if(session.getAttribute("show")==null) {
			int res = board_dao.update_readhit(b_idx);
			
			session.setAttribute("show", true);
		}
		
		
		//request binding
		model.addAttribute("vo",vo);
		
		return "board/board_view";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
