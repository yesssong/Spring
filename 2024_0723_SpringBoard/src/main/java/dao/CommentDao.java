package dao;

import java.util.List;
import java.util.Map;

import vo.CommentVo;

public interface CommentDao {
	
	// 조회
	List<CommentVo>selectList(int b_idx);
	
	// 추가
	int insert(CommentVo vo);
	
	// 삭제
	int delete(int cmt_idx);

	// 페이징별 조회
	List<CommentVo> selectList(Map<String, Object> map);

	// b_idx의 댓글 갯수 구하기(페이징 처리 갯수 처리하기 위해)
	int selectRowTotal(int b_idx);
}
