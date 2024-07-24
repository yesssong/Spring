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
	
	// 생성자 잘 생기나 확인하기 위한 코드(=없어도 됨)
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
	@Qualifier("board_dao")  // 이 이름을 가진 애를 참조해서 연결해라 => 식별자
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
		
		// 로그인 유저 정보 얻어오기
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
	
	
	
	
	
	// 답글 쓰기 폼 띄우기
	@RequestMapping("reply_form.do")
	public String reply_form() {
		
		return "board/board_reply_form";
	}
	
	// /bbs/board/reply.do?b_idx=12&b_subject=답글&b_content=내용
	@RequestMapping("reply.do")
						// 3개의 파라미터 한 번에 받기
						// DS에게 파라미터 정보 받아서 Vo로 여기에 넣어줘 요청함
	public String reply(BoardVo vo, RedirectAttributes ra) {	// <- 요 안에 파라미터 정보 있음
		
		// 로그인 유저 정보 얻어오기
		MemberVo user = (MemberVo) session.getAttribute("user");
		
		if(user==null) {
			
			ra.addAttribute("reason", "session_timeout");
			return "redirect:../member/login_form.do";
		}
		
		// 사용자 정보 vo에 등록
		vo.setMem_idx(user.getMem_idx());
		vo.setMem_name(user.getMem_name());
		
		// 기준 글 정보 얻어오기 => baseVo는 기준 글 하나인 셈
		BoardVo baseVo = board_dao.selectOne(vo.getB_idx());
		
		// 기준 글보다 step이 큰 게시물의 step을 1씩 증가 시키기
		int res = board_dao.update_step(baseVo); // 기준글에 대한 정보가 담겨 있는 baseVo를 인자로 넘김
		
		// 답글의 b_ref, b_step, b_depth 설정
		vo.setB_ref(baseVo.getB_ref());			// 기준 글의 b_ref(글번호) 받아온 것
		vo.setB_step(baseVo.getB_step()+1);		// 기준 글의 b_step + 1 
		vo.setB_depth(baseVo.getB_depth()+1);   // 기준 글의 b_depth + 1
		
		// ip 넣기 -> 글 작성 시 필요한 정보니까..
		String b_ip = request.getRemoteAddr();
		vo.setB_ip(b_ip);
		
		// \n -> <br> => b_content에 내용 작성 시 처리해야 할 부분 => 이거 처리하기 싫으면 웹에디터 쓰면 됨(나중에 써볼 예정)
		String b_content = vo.getB_content().replaceAll("\n","<br>");
		vo.setB_content(b_content);
		
		// DB에 답글 추가 => 이 코드는 순번이 맨 나중에 와야함 -> 정보 들어오기 전에 이 코드가 먼저 있으면 그 정보를 받아올 수 없음
		res = board_dao.reply(vo);
		
		return "redirect:list.do";
	}
	
	// 삭제
	// /bbs/board/delete.do?b_idx=4
	@RequestMapping("delete.do")
	public String delete(int b_idx) {
		//				
		// 삭제 처리 -> b_use를 'n'으로 변경
		int res = board_dao.update_delete(b_idx);	// 삭제 정보를 업뎃하겠다는 의미로 이름지음
		
		return "redirect:list.do";
	}
	
	// 수정폼 띄우기
	// /bbs/board/modify_form.do?b_idx=16
	@RequestMapping("modify_form.do")
	public String modify_form(int b_idx, Model model) {
		
		// 수정 할 원본데이터 정보 받아오기
		BoardVo vo = board_dao.selectOne(b_idx);
		
		// content 수정 시 엔터 처리 => <br> -> \n로 변경
		String b_content = vo.getB_content().replaceAll("<br>", "\n");
		vo.setB_content(b_content); 	// vo에 바뀐 내용 저장
		
		// request binding
		model.addAttribute("vo", vo);
		
		return "board/board_modify_form";		// 수정 뷰 페이지로 이동	
		
	}
	
	
	
	// /board/modify.do?b_idx=5&b_subject=제목&b_content=내용
	@RequestMapping("modify.do")
	public String modify(BoardVo vo,RedirectAttributes ra) {
		
		//로그인 유저정보 얻어온다
		MemberVo user = (MemberVo) session.getAttribute("user");
		
		if(user==null) {
			
			ra.addAttribute("reason", "session_timeout");
			
			return "redirect:../member/login_form.do";
		}
		
		//사용자정보 vo에 등록
		//vo.setMem_idx(user.getMem_idx());
		//vo.setMem_name(user.getMem_name());
		
		//작성자 IP
		String b_ip = request.getRemoteAddr();
		vo.setB_ip(b_ip);
				
		
		// \n -> <br>
		String b_content = vo.getB_content().replaceAll("\n", "<br>");
		vo.setB_content(b_content);
		
		//DB update
		int res = board_dao.update(vo);
		
		
		ra.addAttribute("b_idx", vo.getB_idx());
		
		return "redirect:view.do";	
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
}
