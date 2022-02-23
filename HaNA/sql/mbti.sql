-- mbti 질문
create table mbti_question(
        no number not null,
        question varchar2(250) not null,
        type varchar2(10) not null,
        constraint pk_mbti_question primary key(no)
);
select * from mbti_question;
commit;

select no,question
from mbti_question
where no between 1 and 6;

-------- I , E  유형  문항 --------
INSERT INTO mbti_question
values(1,'다소 내성적이고 조용한 성격입니다.','I');
INSERT INTO mbti_question
values(2,'보통 대화를 먼저 시작하지 않습니다.','I');
INSERT INTO mbti_question
values(3,'주목받는 일에는 관심이 없습니다.','I');
INSERT INTO mbti_question
values(4,'재미있는 책이나 비디오 게임이 종종 사교 모임보다 더 낫습니다.','I');
INSERT INTO mbti_question
values(5,'다른 사람들에게 자신을 소개하는 것을 어려워 합니다.','I');
INSERT INTO mbti_question
values(6,'대게 의욕적이고 활동적입니다.','E');
INSERT INTO mbti_question
values(7,'금방 새로운 직장 사람들과 어울리기 시작합니다.','E');
INSERT INTO mbti_question
values(8,'많은 사람들과 시간을 보낸 후에 에너지가 넘친다고 느낍니다.','E');
INSERT INTO mbti_question
values(9,'종종 사회적 상황에서 주도적으로 행동합니다.','E');
----------------------------------------------
------------------T 와 F 문항--------------------
INSERT INTO mbti_question
values(10,'중요한 결정을 내려야 할 때 일반적으로 가슴보다 논리가 더 중요합니다.','T');
INSERT INTO mbti_question
values(11,'논쟁에서 이기는 것이 상대방을 불쾌하지 않도록 하는 것보다 더 중요합니다.','T');
INSERT INTO mbti_question
values(12,'토론 시 사람들의 민감한 반응보다 진실을 더 중요시 해야합니다.','T');
INSERT INTO mbti_question
values(13,'사람들 때문에 화나는 일이 거의 없습니다.','T');
INSERT INTO mbti_question
values(14,'협동 작업을 수행하는 경우 협력적인 자세보다 올바르게 행동하는 것이 더욱 중요합니다.','T');
INSERT INTO mbti_question
values(15,'부모로서 자녀가 똑똑하기보다는 착하게 성장하기를 바랍니다.','F');
INSERT INTO mbti_question
values(16,'사업을 하는 경우, 충실하지만 실적을 못내는 직원을 해고하기를 어려워합니다.','F');
INSERT INTO mbti_question
values(17,'권력을 쥐는 것 보다 다른 사람들의 호의를 얻는 것이 더 보람 있다고 생각합니다.','F');
INSERT INTO mbti_question
values(18,'사실이 뒷받침되는지에 상관없이 모든 사람의 견해가 존중되어야 한다고 생각합니다.','F');
-------------------------------------------------
------------------S와 N문항-----------------------
INSERT INTO mbti_question
values(19,'본인이 창의적이기보다 현실적인 사람이라고 생각합니다.','S');
INSERT INTO mbti_question
values(20,'공상과 아이디어 때문에 흥분하는 일은 없습니다.','S');
INSERT INTO mbti_question
values(21,'꿈이 현실 세계와 사건에 중점을 두는 경향이 있습니다.','S');
INSERT INTO mbti_question
values(22,'다른 사람들이 본인의 행동에 영향을 주는 것을 허용하지 않습니다.','S');
INSERT INTO mbti_question
values(23,'순전히 호기심 때문에 행동을 하는 경우는 거의 없습니다.','S');
INSERT INTO mbti_question
values(24,'종종 주변을 무시하거나 잊어버리는 생각에 빠지곤 합니다.','N');
INSERT INTO mbti_question
values(25,'종종 비현실적이고 터무니없지만 흥미로운 생각을 하며 시간을 보냅니다.','N');
INSERT INTO mbti_question
values(26,'종종 인간 실존에 대한 이유를 생각합니다.','N');
INSERT INTO mbti_question
values(27,'종종 자연 속에 거닐고 있을 때 생각에 잠기곤 합니다.','N');
-------------------------------------------------
------------------P와 J문항-----------------------
INSERT INTO mbti_question
values(28,'주의깊게 미리 계획하기 보다는 즉흥적으로 움직입니다.','P');
INSERT INTO mbti_question
values(29,'구체적인 계획을 갖고 시간을 보내기보다는 다소 즉흥적으로 움직입니다.','P');
INSERT INTO mbti_question
values(30,'업무 스타일이 체계적이고 조직적이라기보다는 그때그때 몰아서 처리하는 편입니다.','P');
INSERT INTO mbti_question
values(31,'시간이 부족할 때까지 일을 미루는 경향이 있습니다.','P');
INSERT INTO mbti_question
values(32,'선택을 보류하는 것이 해야할 일을 정확히 알고 있는 것 보다 중요합니다.','P');
INSERT INTO mbti_question
values(33,'이메일에 가능한 빨리 회신하려고 하고 지저분한 편지함은 참을 수 없습니다.','J');
INSERT INTO mbti_question
values(34,'적응을 잘 하는 것 보다 체계적인 것이 더 중요합니다.','J');
INSERT INTO mbti_question
values(35,'보통 여행 계획은 철저하게 세우는 편입니다.','J');
INSERT INTO mbti_question
values(36,'계획의 수립과 이행은 모든 프로젝트에서 가장 중요한 부분입니다.','J');
-------------------------------------------------



-- 사용자 mbti 
create table member_mbti(
    member_id varchar2(500) not null,
    mbti varchar2(30),
    constraint fk_member_mbti foreign key(member_id) references member(id) on delete cascade
);
select * from member_mbti;
commit;
delete  from  member_mbti where member_id ='tksemf2543';


-- mbti  검사 데이터 
create table mbti_data(
    question_no number not null,
    member_id varchar2(500) not null,
    result  number ,
    constraint fk_mbti_data foreign key(member_id) references member(id) on delete cascade
);
select * from mbti_data;  where member_id ='k33';
commit;

constraint fk_code foreign key(tag_id)
         references hashtag(tag_id) on delete cascade



select *
 from hashtag;

-- 조인 쿼리 -- 
select *
from hashtag  a inner join shop_info  b
on a.tag_id = b.id;


--------------
select
            *
        from
             	hashtag a 
           inner join 
           		shop_info b
          on a.tag_id = b.id
        where
           b.location_x <  127.1322903
            and
            b.location_y  <  37.542603799999995
            and
            b.id != 'k333'
            and
            a.tag_name in('해물탕','매운탕');
  ------------- 
select * from shophashtag;
select * from hashtag;
select * from shop_info;
select * from member;
commit;
select
    *
from 
    shop_info i
    left join shophashtag s on i.id = s.member_id 
    left join hashtag h on s.tag_id = h.tag_id 
where member_id = 'shop111';


create table ranking ( 
    member_id varchar2(50),
	tag_id varchar2(50),   	 
	tag_date date,	
	constraint tag_ranking_fk foreign key(tag_id)
        references hashtag(tag_id) on delete cascade
);

  select *from ranking;
  select * from hashtag;
  
  
update ranking set tag_date = '22/02/19' where member_id = 'k666';
  
  insert  into ranking(tag_id , tag_date , count);
  
  select * 
  from ranking r left join hashtag h 
  on r.tag_id = h.tag_id;

insert  into ranking(member_id,tag_id , tag_date)
values ('k333','shop-hashtag-30','2022-02-09');

merge into  ranking 
    using DUAL
       on ('shop-hashtag-30' = tag_id and '22/02/08' = tag_date)
    when matched then
        update set  count = +1 
    when not matched then
        insert (tag_id, tag_date , count) 
        values ('shop-hashtag-25','22/02/12',28);
select * from ranking;
select * from hashtag;

update ranking set count = count+1;



------------오늘 날짜 데이터 구하기 --------------------
select * from hashtag h left join   ranking r  
on r.tag_id = h.tag_id
WHERE TO_CHAR(SYSDATE, 'MM/dd') = TO_CHAR(r.tag_date, 'MM/dd') ;
----------------------------------------------------
-----------------이번달 데이터 구하기 ----------------------
select * 
from hashtag h left join   ranking r  
on r.tag_id = h.tag_id
WHERE tag_date BETWEEN TRUNC(SYSDATE, 'MM')  and LAST_DAY(SYSDATE)
ORDER BY r.count  desc;
--------------------------------------------------------
-----------------이번주 데이터 구하기 ----------------------
select *
from  hashtag h left join   ranking r  
on r.tag_id = h.tag_id
where tag_date between
(SELECT TRUNC(sysdate, 'iw') dt_date
FROM dual)
and
(SELECT TRUNC(sysdate, 'iw') + 6 dt_date
FROM dual)
ORDER BY r.count  desc;

------------------------------------------------------


------------------------이번달 --------------------------
select count(*)as count ,h.tag_name
from ranking r left join   hashtag h  
on r.tag_id = h.tag_id
WHERE tag_date BETWEEN TRUNC(SYSDATE, 'MM')  and LAST_DAY(SYSDATE)
group by h.tag_name
order by count desc;
--------------------------------------------------------
--------------오늘 ---------------------------------
select count(*)as count,h.tag_name
from ranking r left join   hashtag h  
on r.tag_id = h.tag_id
WHERE TO_CHAR(SYSDATE, 'MM/dd') = TO_CHAR(r.tag_date, 'MM/dd')
group by h.tag_name
order by count desc;
-----------------------------------------------------
----------------이번주-------------------------
select count(*)as count,h.tag_name
from ranking r left join   hashtag h    
on r.tag_id = h.tag_id
where tag_date between
(SELECT TRUNC(sysdate, 'iw') dt_date
FROM dual)
and
(SELECT TRUNC(sysdate, 'iw') + 6 dt_date
FROM dual)
group by h.tag_name
order by count desc;





WHERE tag_date BETWEEN TRUNC(SYSDATE, 'MM')  and LAST_DAY(SYSDATE)
ORDER BY r.count  desc;

select * from ranking;


select count(*),tag_id
from     ranking 
group by tag_id;

select sysdate from dual;


 select *from mbti_data;
 
 
  select
            *
        from
            shop_info ;
  		  	left join shophashtag s on i.id = s.member_id 
    		left join hashtag h on s.tag_id = h.tag_id
        where
            tag_name = '감자탕';
 

select * from member;
select * from shop_info;

select
            *
        from
            shop_info i	
            left join member m
            on i.id = m.id
           	left join shophashtag s on i.id = s.member_id 
    		left join hashtag h on s.tag_id = h.tag_id;

            
            

    		left join hashtag h 
            on s.tag_id = h.tag_id
        where
            tag_name = '삼겹살'
;
select * from member;

select
            *
        from
            shop_info i	
            left join member m
            on i.id = m.id
        where i.id = 'k333'; 
        
select *from shop_info;
 select * from hashtag;
 
            

         select  
            i.id,i.SHOP_NAME, i.ADDRESS , h.TAG_NAME , m.PICTURE
        from
            shop_info i	
            left join member m
            on i.id = m.id
           	left join shophashtag s on i.id = s.member_id 
    		left join hashtag h on s.tag_id = h.tag_id 
             where
            i.location_x  <  127.1257064
            and
            i.location_y  <  37.5612273;
            
           
     