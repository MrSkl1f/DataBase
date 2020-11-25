-- Разработать 4 функции
-- 1. Скалярную
-- 2. Подставляемую табличную
-- 3. Многооператорную табличную
-- 4. Рекурсивную функцию или функцию с рекурсивным ОТВ

-- Скалярная функция
-- Получает средний возраст
drop function if exists skalar_func();
create function skalar_func() 
returns numeric 
as $$ 
    select avg(player_age)
    from players;
$$ language sql;

select skalar_func();

-- Подставляемая табличная
-- получает игроков, у которых рост больше заданного
-- //DONE исправить под setof 
drop function if exists get_players;
create function get_players(int) 
returns setof players
as $$
    select *
    from players
    where player_height > $1;
$$ language sql;

select * from get_players(219);

-- Многооператорная табличная
-- получает таблицу значений
-- //DONE несколько операторов
drop table if exists plh;
create table plh (
	name varchar(40),
	number int,
	height int
);

drop function if exists get_players_mult;
create function get_players_mult(int)
returns table
(
    name varchar(40),
    number int,
    height int
)
language sql
as $$
    insert into plh
	select player_name, player_number, player_height
    from players
    where player_height > $1;
   
   	select *
    from plh;
$$;

select *
from get_players_mult(219);

-- Рекурсивную функцию или функцию с рекурсивным ОТВ
-- //DONE исправить под свои данные
-- вывести игроков и команду в заданном интервале

drop function if exists get_players_in_interval;
create function get_players_in_interval(cur_id int, end_id int)
returns table
(
    pid int,
    pn varchar(40)
)
language plpgsql
as $$
begin
    return query select id, player_name
    from players
    where id = cur_id;
    if cur_id < end_id then
        return query select *
            from get_players_in_interval(cur_id + 1, end_id);
    end if;
end;
$$;

select * from get_players_in_interval(115, 121);