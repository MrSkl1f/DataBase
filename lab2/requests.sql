-- Инструкция SELECT, использующая предикат сравнения.
select *
from teams
where country = 'Spain';

-- Инструкция SELECT, использующая предикат BETWEEN.
-- Получить имена игроков и их номера, у которых рост от 190 до 200
select player_name, player_number
from players
where player_height between 190 and 200;

-- Инструкция SELECT, использующая предикат LIKE.
-- Получить названия команд и их стадион, у которых названия команды начинается с BC
select team_name, stadium
from teams
where team_name like 'BC%';

-- Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
-- Получить имена игроков, их возраст и команду, у которых возраст от 18 до 21. Отсортировать по возрасту.
select player_name, player_age, team_name
from players join teams on players.team = teams.team_id
where player_name in
(
    select player_name
    from players
    where player_age between 18 and 21
)
order by player_age;

-- Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом.
-- Получить имена игроков и их номера, которые играют за команду в Канаде
select player_name, player_number
from players as tmp
where exists
(
    select player_name, team_name
    from players join teams on players.team = teams.team_id
    where teams.country = 'Canada' and
        player_name = tmp.player_name 
);
--  Christopher Tillman     79
-- Luetta Maxwell            18
-- Terresa Schneider       67
-- Waldo Sexton               16
-- Krysta Griffith             72
-- Проверка: select * from teams where team_country = 'Canada';

-- Инструкция SELECT, использующая предикат сравнения с квантором.
-- Получить список игроков, рост которых больше чем рост любого игрока 42 команды
select *
from players
where player_height > all
(
    select player_height
    from players
    where team = 42
)
order by player_height;
-- Проверка: select player_height from players where team = 42;

-- Инструкция SELECT, использующая агрегатные функции в выражениях столбцов.
-- средний вес и рост по каманде
select teams.team_id as Id, avgTeams.team_name as Team, avW as average_weight, avH as average_height
from (
    select team_name, avg(player_weight) as avW, avg(player_height) as avH
    from players join teams on players.team = teams.team_id
    group by team_name
) as avgTeams
        join teams on avgTeams.team_name = teams.team_name;

-- Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.
-- Получить средний вес и рост игроков 15 команды
select team_id, team_name,
    (
        select avg(player_weight)
        from players
        where team = 15
    ) as average_weight,
    (
        select avg(player_height)
        from players 
        where team = 15
    ) as average_height
from teams
where team_id = 15;

-- Инструкция SELECT, использующая простое выражение CASE.
select player_name, player_number,
    case player_age when 16 then 'Young'
            when 40 then 'Old'
            else 'norm'
    end as Age
from players;

-- Инструкция SELECT, использующая поисковое выражение CASE.
select player_name, player_number,
    case when player_age <= 18 then 'Young'
            when player_age >= 40 then 'Old'
            else 'norm'
    end as Age
from players;

-- Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT.
select team_name as tname, country as tcountry
into tmp
from teams;
-- drop table tmp;

-- Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM.