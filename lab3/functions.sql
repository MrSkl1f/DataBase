-- Разработать 4 функции
-- 1. Скалярную
-- 2. Подставляемую табличную
-- 3. Многооператорную табличную
-- 4. Рекурсивную функцию или функцию с рекурсивным ОТВ

-- Скалярная функция
-- Получает средний возраст
drop function skalar_func();
create function skalar_func() returns int
language sql
as $$ 
    select avg(player_age)
    from players;
$$;

select skalar_func();

-- Подставляемая табличная
-- получает игроков, у которых рост больше заданного
drop function get_players;
create function get_players(int) returns players 
language sql
as $$
    select * 
    from players
    where player_height > $1;
$$;

select player_name, player_number, player_height
from get_players(201);

-- Многооператорная табличная
-- получает таблицу значений
drop function get_players_mult;
create function get_players_mult(int)
returns table
(
    player_name varchar(40),
    player_number int,
    player_height int
)
language sql
as $$
    select player_name, player_number, player_height
    from players
    where player_height > $1;
$$;

select *
from get_players_mult(201);

-- Рекурсивную функцию или функцию с рекурсивным ОТВ
-- факториал
drop function Fact;
create or replace function Fact (x int)
returns int
language plpgsql
as $$
begin 
	if x = 0 then
		return 1;
	else 
		return x * Factorial(x - 1);
	end if;
end $$; 

select * from Factorial(4);