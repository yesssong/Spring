package util;

public class MyCommon {
	
	// 게시판 페이징 정보
	public static class Board{
		// final 상수 -> public이므로 어디서든 사용 가능
		public static final int BLOCK_LIST = 8; 	// 한 화면에 보여질 게시물 수
		public static final int BLOCK_PAGE = 3; 	// 페이지 수
		
	}
	
	// 댓글 페이징 정보
	public static class Comment{
		// final 상수 -> public이므로 어디서든 사용 가능
		public static final int BLOCK_LIST = 3; 	// 한 화면에 보여질 게시물 수
		public static final int BLOCK_PAGE = 5; 	// 페이지 수
		
	}
}