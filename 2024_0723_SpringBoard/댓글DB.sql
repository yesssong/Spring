/*

-- 일련번호
create sequence seq_comment_tb_idx

-- comment라고 이름 지으면 오라클 예악어와 겹치므로 comment_tb라고 지음(자바에서는 괜춘)
create table comment_tb(
	cmt_idx		int,			-- 일련번호
	cmt_content	varchar2(2000),	-- 내용
	cmt_ip		varchar2(200),	-- ip
	cmt_regdate date,			-- 등록일자
	b_idx		int,			-- 게시물 번호
	mem_idx		int,			-- 회원 번호(게시물 작성한 회원)
	mem_name	varchar2(200)	-- 회원 이름
)

-- 기본키
alter table comment_tb
	add constraint pk_comment_tb_idx primary key(cmt_idx);



-- 외래키
alter table comment_tb
	add constraint fk_comment_tb_b_idx foreign key(b_idx)
									   references board(b_idx);
									  
alter table comment_tb
	add constraint fk_comment_tb_mem_idx foreign key(mem_idx)
									   references member(mem_idx);

select * from comment_tb

-- paging 처리를 위한 sql문
select * from
(
	select
		rank() over(order by cmt_idx desc)as no,
		c.*
	from
	(
	 select * from comment_tb where b_idx=27
	)c
)
where no between 1 and 5

































*/