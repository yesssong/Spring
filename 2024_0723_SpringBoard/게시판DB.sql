/*

-- 게시판 일련번호 관리 객체
create sequence seq_board_idx

create table board(

	b_idx		int,						--일련번호
	b_subject	varchar2(100) not null,		-- 제목
	b_content	clob not null,				-- 내용 -> clob 대용량 파일
	b_ip		varchar2(100) not null,		-- ip
	b_regdate	date,						-- 작성일자
	b_readhit	int default 0,				-- 조회수
	b_use		char(1) default 'y',		-- 사용유무 (게시글 삭제된 내용인지)
	mem_idx		int,						-- 작성자 회원번호
	mem_name	varchar2(100),				-- 작성자 이름
	b_ref		int,						-- 참조글번호(댓글)
	b_step		int,						-- 글 순서
	b_depth		int							-- 글 깊이
)

-- 기본키
alter table board 
	add constraint pk_board_idx primary key(b_idx);

-- 외래키
alter table board
	add constraint fk_board_mem_idx foreign key(mem_idx)
									references member(mem_idx); 

select * from member




-- sample data

-- 새글 쓰기
insert into board values(seq_board_idx.nextVal,
						 '내가 1등',
						 '내가 첫번째로 등록함',
						 '192.168.10.123',
						 sysdate,
						 0,
						 'y',
						 2,
						 '일길동',
						 seq_board_idx.currVal,
						 0,
						 0
						 )

						 
-- 답글 쓰기
insert into board values(seq_board_idx.nextVal,
						 '2등',
						 '까비',
						 '192.168.10.123',
						 sysdate,
						 0,
						 'y',
						 9,
						 '홍삼',
						 1,					-- 1번 글에 대한 댓글
						 1,
						 1
						 )				
						 
-- strp, depth가 0이 아니면 답글이라는 뜻	

- 답글에 답글 쓰기
insert into board values(seq_board_idx.nextVal,
						 '담에는 니가 1등해',
						 '아닐걸.. 다음에도 내가 1등이야',
						 '192.168.10.123',
						 sysdate,
						 0,
						 'y',
						 2,
						 '일길동',
						 1,					-- 1번 글에 대한 댓글
						 2,					-- 1번 글의 2번째 댓글
						 2					-- 첫번째 댓글에 댓글 -> 대댓글이므로 깊이가 2번
						 )	 						 
						 						 						 						 
select * from board order by b_idx desc, b_step asc  -- 최신글이 상단에 위치
















*/