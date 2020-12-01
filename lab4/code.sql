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
-- join на питон
-- в агрегат

create or replace function avg_state(prev numeric[2], next numeric) returns numeric[2] as
$$
	return prev if next == 0 or next == None else [0 if prev[0] == None else prev[0] + next, prev[1] + 1]
$$ language plpython3u;

create or replace function avg_final(num numeric[2]) returns numeric as
$$
    return 0 if num[1] == 0 else num[0] / num[1]
$$ language plpython3u;


create aggregate my_avg(numeric) (
    sfunc = avg_state,
    stype = numeric[],
    finalfunc = avg_final,
    initcond = '{0,0}'
);

select my_avg(players.player_height::numeric)
from players join teams on players.team = teams.id
where country = 'Canada';

-- 3) Определяемую пользователем табличную функцию CLR
-- получить все команды из страны
drop function if exists get_all_teams_from_country;
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
drop procedure if exists add_management;
create or replace procedure add_management(id int, director varchar, manager varchar, sp_director varchar)
language plpython3u
as $$
request = plpy.prepare("insert into management(id, general_director, general_manager, sports_director) values($1, $2, $3, $4);", ["int", "varchar", "varchar", "varchar"])
plpy.execute(request, [id, director, manager, sp_director])
$$;

call add_management(1002, 'Denis', 'Denis', 'Denis');

select * from management m 
where m.id = 1002;

-- 5) Триггер CLR
-- при добавлении записать в новую таблицу
-- //DONE исправить под свои данные

drop table if exists directors;
create table if not exists directors
(
    id serial not null,
    management_id int,
    old_director varchar(40),
    new_director varchar(40)
);

drop trigger if exists change_director on directors;

create or replace function change_director()
returns trigger
as $$
new_management = TD['new']
old_management = TD['old']
management_id = new_management["id"]
old_director = old_management["general_director"]
new_director = new_management["general_director"]
if old_director != new_director:
    request = plpy.prepare("insert into directors(management_id, old_director, new_director) values($1, $2, $3);", ["int", "varchar", "varchar"])
    rv = plpy.execute(request, [management_id, old_director, new_director])
return None
$$ language plpython3u;

create trigger change_director
after update on management
for each row
execute procedure change_director();

select * from management m 
where id = 900;

update management
set general_director = 'Denis Sklifasovsky'
where management.id = 900;

select * from directors d ;

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