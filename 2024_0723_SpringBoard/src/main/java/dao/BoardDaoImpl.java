package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import vo.BoardVo;

// 컴포넌트로 인식하고 자동 생성 해줌
@Repository("board_dao")
public class BoardDaoImpl implements BoardDao {
	
	public BoardDaoImpl() {
		// TODO Auto-generated constructor stub
	System.out.println("--BoardDaoImpl()--");
	}
	

	// injection 받기 위해 만듦
	@Autowired
	SqlSession sqlSession;
	
	@Override
	public List<BoardVo> selectList() {
		// TODO Auto-generated method stub
		
		return sqlSession.selectList("board.board_list");
	}

	@Override
	public int insert(BoardVo vo) {
		// TODO Auto-generated method stub
		return sqlSession.insert("board.board_insert", vo);		// vo 줄테니 insert해라
	}

	@Override
	public BoardVo selectOne(int b_idx) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("board.board_one", b_idx);
	}

	@Override
	public int update_readhit(int b_idx) {
		// TODO Auto-generated method stub
		return sqlSession.update("board.board_update_readhit", b_idx);		// board 맵퍼에 b_idx에 해당하는 게시물의 조회수를 수정
	}

}
