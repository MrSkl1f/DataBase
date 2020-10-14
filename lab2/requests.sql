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
from players join teams on players.team = teams.id
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
    from players join teams on players.team = teams.id
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
select teams.id as Id, avgTeams.team_name as Team, avW as average_weight, avH as average_height
from (
    select team_name, avg(player_weight) as avW, avg(player_height) as avH
    from players join teams on players.team = teams.id
    group by team_name
) as avgTeams
        join teams on avgTeams.team_name = teams.team_name;

-- Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.
-- Получить средний вес и рост игроков 15 команды
select id, team_name,
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
where id = 15;

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
-- Сопопоставить игроков тренерам
select players.player_name as Player, info.head_coach as Coach
from players join
(
    select teams.id as team_id, headquarters.head_coach as head_coach
    from teams join headquarters on teams.headquarter = headquarters.id
) as info on players.team = info.team_id
order by info.head_coach;

-- Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3.
-- Вывести спортивных директоров у которых игроки больше среднего возраста
select sports_director
from management
group by management.id
having management.id in(
    select management
    from teams
    group by teams.id
    having management in (
        select players.id
        from players
        where player_age > (
            select AVG(player_age) as AvgAge
            from players
        )
    )
);

-- Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING.
select team,
            avg(players.player_weight) as AvgWeight,
            avg(players.player_height) as AvgHeight,
            max(players.player_age) as MaxPlayerAge
from players
group by team;

-- Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING.
select player_name as "Player Name", player_age as "Player Age", player_weight as "Player Weight", player_height as "Player Height"
from players
where player_weight > 80 and player_height > 200
group by player_name, player_age, player_weight, player_height
having avg(player_age) > (
    select avg(player_age)
    from players
);

-- Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений.
insert into players (id, team,player_name, player_age, player_country)
values (2426, 227, 'Denis Sklifasovsky', 20, 'Russia');

-- Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса.
insert into players(id, team, player_name, player_number) 
select (
    select max(players.id) + 1
    from players
), teams.id, 'Denis Sklifasovsky', 21
from teams
where teams.country = 'Canada';

-- Простая инструкция UPDATE.
update players
set player_country = 'Russia'
where players.id = 2427;

-- Инструкция UPDATE со скалярным подзапросом в предложении SET.
update players
set player_age = (
    select max(player_age)
    from players
    where player_number = 21
)
where players.id = 2427;

-- Простая инструкция DELETE.
delete from players
where players.id = 2427;

-- Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE.
delete from players
where team in (
    select teams.id 
    from teams
    where teams.country = 'Canada'
) and players.id = 2427;

-- Инструкция SELECT, использующая простое обобщенное табличное выражение
with TmpPlayer (id, team, player_name, player_age)
as (
    select players.id, players.team, players.player_name, players.player_age
    from players
    where player_age > 40 and player_weight > 80
)
select team, player_name
from TmpPlayer
where player_age = 50;

-- Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение.
with recursive diff(n) as
(
	select 10
	union all
	select n - 1 from diff
	where n > 0
)
select n from diff;

-- Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
select player_name as "Player name", team,  
	min(player_weight) over (partition by team), 
    max(player_height) over (partition by team),
	avg(player_age) over (partition by team)
from players;

-- Оконные фнкции для устранения дублей
