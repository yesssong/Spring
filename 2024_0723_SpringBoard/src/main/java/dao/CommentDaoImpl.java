package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import vo.CommentVo;

public class CommentDaoImpl implements CommentDao {
	
	// 수동생성 해보기 -> context-3-dao에 가서 작업
	@Autowired
	SqlSession sqlSession;

	// 조회
	@Override
	public List<CommentVo> selectList(int b_idx) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("comment.comment_list", b_idx);
	}

	// 추가
	@Override
	public int insert(CommentVo vo) {
		// TODO Auto-generated method stub
		return sqlSession.insert("comment.comment_insert", vo);
	}

	// 삭제
	@Override
	public int delete(int cmt_idx) {
		// TODO Auto-generated method stub
		return sqlSession.delete("comment.comment_delete", cmt_idx);
	}

	// 페이징별 조회
	@Override
	public List<CommentVo> selectList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("comment.comment_page_list", map);
	}

	// b_idx의 댓글 갯수 구하기 -> 페이징 처리 할 갯수 처리하기 위해
	@Override
	public int selectRowTotal(int b_idx) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("comment.comment_row_total", b_idx);
	}

}
