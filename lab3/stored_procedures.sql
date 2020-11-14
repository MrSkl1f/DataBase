-- 4 хранимые процедуры
-- 1) хранимую процедуру без параметров или с параметрами
-- 2) рекурсивную хранимую процедуру или хранимую процедуру с рекурсивным ОТВ
-- 3) хранимую процедуру с курсором
-- 4) хранимую процедуру доступа к метаданным

-- хранимую процедуру без параметров или с параметрами
drop procedure promotion_of_management;
drop table management_copy;

select *
into temp management_copy
from management;

create or replace procedure promotion_of_management(find_country varchar(40))
language plpgsql
as $$
begin
	update management_copy
	set	general_director = general_manager,
		general_manager = (
			select general_director
			from teams join management on teams.management = management.id
			where teams.country = find_country and management_copy.id = management.id
		)
	where id in (
		select teams.management as id 
		from teams join management on teams.management = management.id
		where teams.country = find_country
	);
end $$;

call promotion_of_management('Canada');

select * 
from management_copy join management on management_copy.id = management.id
where management.id = 251;

-- рекурсивную хранимую процедуру или хранимую процедуру с рекурсивным ОТВ
drop procedure change_age;
drop table players_copy;

select *
into temp players_copy
from players;

create or replace procedure change_age(new_age int, cur_id int, last_id int, need_age int) 
language plpgsql
as $$
begin
	if cur_id <= last_id then
		update players_copy
		set player_age = new_age
		where id = cur_id and player_age = need_age;
		call change_age(new_age, cur_id + 1, last_id, need_age);
	end if;
end;
$$;

call change_age(27, 800, 900, 26);

select players.player_age as age_1, players_copy.player_age as age_2
from players join players_copy on players.id = players_copy.id
where players.id between 800 and 900 and players.player_age = 26;

-- хранимую процедуру с курсором
drop procedure change_weight;
drop table players_copy;

select *
into temp players_copy
from players;

create or replace procedure change_weight(new_weight int, start_id int, end_id int, need_weight int) 
language plpgsql
as $$
declare 
	my_cursor cursor
	for select *
	from players
	where id between start_id and end_id and player_weight = need_weight;
	line record;
begin
	open my_cursor;
	loop 
		fetch my_cursor into line;
		exit when not found;
		update players_copy
		set player_weight = new_weight
		where players_copy.id = line.id;
	end loop;
	close my_cursor;
end;
$$;

call change_weight(80, 1, 200, 79);

select players.player_weight as weight_1, players_copy.player_weight as weight_2
from players join players_copy on players.id = players_copy.id
where players.id between 1 and 200 and players.player_weight = 79;

-- хранимую процедуру доступа к метаданным
create or replace procedure get_total_relation_size()
language plpgsql
as $$
declare	
	my_cursor cursor
	for select table_name, total_size
	from (
		select table_name,
		pg_total_relation_size(cast(table_name as varchar)) as total_size 
		from information_schema.tables
		where table_catalog = 'basketball' and
		table_schema not in ('information_schema','pg_catalog')
		order by total_size desc
	) as name_size;
	line record;
begin
	open my_cursor;
	loop
		fetch my_cursor into line;
		exit when not found;
		raise notice 'Name of table: <%> and Total size: <%>', line.table_name, line.total_size;
	end loop;
	close my_cursor;
end;
$$;
call get_total_relation_size();