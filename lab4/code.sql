-- Создать, развернуть и протестировать 6 объектов SQL CLR
-- 1) Определяемую пользователем скалярную функцию CLR
create or replace function get_player_by_id(id int) 
returns varchar
language plpython3u
as $$
players = plpy.execute("select * from players")
for player in players:
    if player['id'] == id:
        return player['player_name']
return 'None'
$$;

select * from get_player_by_id(500);
select * from get_player_by_id(5000);

-- 2) Пользовательскую агрегатную функцию CLR
-- получить всех игроков из страны
drop function get_n_players;
create or replace function get_n_players(country varchar)
returns int
language plpython3u
as $$
p_t = plpy.execute("select players.player_name as name, teams.country as country from players join teams on players.team = teams.id")
summ = 0
for player in p_t:
    if player['country'] == country:
        summ += 1
return summ
$$;

select * from get_n_players('Canada');

-- 3) Определяемую пользователем табличную функцию CLR
-- получить все команды из страны
drop function get_all_teams_from_country;
create or replace function get_all_teams_from_country(country varchar)
returns table(id int, management int, headquarter int, team_name varchar, country varchar, stadium varchar)
language plpython3u
as $$
teams = plpy.execute("select * from teams")
res_table = list()
for team in teams:
    if team['country'] == country:
        res_table.append(team)
return res_table
$$;

select * from get_all_teams_from_country('Canada');

-- 4) Хранимую процедуру CLR
drop procedure add_management;
create or replace procedure add_management(id int, director varchar, manager varchar, sp_director varchar)
language plpython3u
as $$
request = plpy.prepare("insert into management(id, general_director, general_manager, sports_director) values($1, $2, $3, $4);", ["int", "varchar", "varchar", "varchar"])
plpy.execute(request, [id, director, manager, sp_director])
$$;

call add_management(1001, 'Denis', 'Denis', 'Denis');

-- 5) Триггер CLR
-- при добавлении записать в новую таблицу
drop table history;
create table if not exists history
(
	operation varchar(100) not null
);

drop table students;
create table if not exists students
(
	st_name varchar(100) not null,
	st_group varchar(100) not null
);

drop trigger history on students;
drop function add_history();

create or replace function add_history()
returns trigger
as $$
cur = TD['new']
request = plpy.prepare("insert into history(operation) values($1);", ["varchar"])
operation = 'Добавлен студент ' + cur["st_name"] + ' в группу ' + cur["st_group"]
rv = plpy.execute(request, [operation])
return None
$$ language plpython3u;

create trigger add_history
after insert on students
for each row
execute procedure add_history();

insert into students(st_name, st_group)
values('Danya', 'iu7-55');
insert into students(st_name, st_group)
values('Denis', 'iu7-55');
select * from history;

-- 6) Определяемый пользователем тип данных CLR
drop function get_characteristics();
drop type characteristics;

create type characteristics as (
    player_height int,
    player_weight int,
    player_age int
);

create or replace function get_characteristics(id int)
returns characteristics
language plpython3u
as $$
request = plpy.prepare("select player_height, player_weight, player_age from players where id = $1", ["int"])
cur_characteristic = plpy.execute(request, [id])
return (cur_characteristic[0]['player_height'], cur_characteristic[0]['player_weight'], cur_characteristic[0]['player_age'])
$$;

select * from get_characteristics(500);
select player_height, player_weight, player_age from players where id = 500;