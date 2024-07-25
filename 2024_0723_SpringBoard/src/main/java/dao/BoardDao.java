package dao;

import java.util.List;
import java.util.Map;

import vo.BoardVo;

public interface BoardDao {
	
	List<BoardVo> selectList();
	
	// 페이징 메뉴 추가(댓글 갯수 포함)
	List<BoardVo> selectList(Map<String, Object> map);
	
	int selectRowTotal(Map<String, Object> map);

	BoardVo selectOne(int b_idx);

	int insert(BoardVo vo);

	int update_readhit(int b_idx);

	int update_step(BoardVo baseVo);

	int reply(BoardVo vo);

	int update_delete(int b_idx);

	int update(BoardVo vo);

	


}
