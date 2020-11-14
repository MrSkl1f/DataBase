-- Разработать 4 функции
-- 1. Скалярную
-- 2. Подставляемую табличную
-- 3. Многооператорную табличную
-- 4. Рекурсивную функцию или функцию с рекурсивным ОТВ

-- Скалярная функция
create function skalar_func() returns int
language sql
as $$ 
    select id
    from players
    order by player_age;
$$;

select skalar_func();

-- Подставляемая табличная
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
create or replace function Factorial (x int)
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