--  2 DML триггера
-- 1) after
-- 2) instead of 

-- after
drop table students;
create table if not exists students
(
	st_name varchar(100) not null,
	st_group varchar(100) not null
);

drop table history;
create table if not exists history
(
	operation varchar(100) not null
);

drop function add_history();
create or replace function add_history()
returns trigger 
language plpgsql
as $test$
begin
	insert into history(operation)
	values ('Добавлен студент ' || cast(new.st_name as varchar) || ' из группы ' || cast(new.st_group as varchar));
	return new;
end
$test$;


create trigger history
	after insert on students
	for each row
	execute procedure add_history();


insert into students(st_name, st_group)
values('Danya', 'iu7-55');

select * from history;

-- instead of 
create view teams_view as
select *
from teams;

create or replace function update_player()
returns trigger 
language plpgsql
as 	$$
begin
	update teams
	set country = 'Canada'
	where id = old.id ;
	return old;
end;
$$;

create trigger delete_player
	instead of delete on teams_view
	for each row 
	execute procedure update_player();
	
delete
from teams_view
where id = 1;

select *
from teams_view
where id = 1;
