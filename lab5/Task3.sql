drop table if exists json_test;
create table if not exists json_test
(
	id serial primary key,
	player varchar(40),
	games json
);

insert into json_test (player, games) 
values ('Stephen Curry', '{"2016/17" : 79, "2017/18" : 51, "2018/19" : 69, "2019/20" : 5}');
insert into json_test (player, games) 
values ('Klay Thompson', '{"2016/17" : 78, "2017/18" : 73, "2018/19" : 78, "2019/20" : 0}');
insert into json_test (player, games) 
values ('Lebron James', '{"2016/17" : 74, "2017/18" : 82, "2018/19" : 55, "2019/20" : 67}');
insert into json_test (player, games) 
values ('Russell Westbrook', '{"2016/17" : 81, "2017/18" : 81, "2018/19" : 81, "2019/20" : 57}');
insert into json_test (player, games) 
values ('James Harden', '{"2016/17" : 81, "2017/18" : 72, "2018/19" : 78, "2019/20" : 68}');
insert into json_test (player, games) 
values ('Kyrie Irving', '{"2016/17" : 72, "2017/18" : 60, "2018/19" : 67, "2019/20" : 20}');

select * from json_test;
