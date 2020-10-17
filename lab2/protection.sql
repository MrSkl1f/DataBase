-- Защита 2 лабы по бд
-- 1. Создать временную таблицу и проверить все ли связи добавляет
select teams.id, teams.team_name
into tmp
from teams 
where teams.id < 5;

select players.team, players.player_name
into tmp2
from players
where players.team in  (
    select tmp.id
    from tmp
);

insert into tmp2 (team, player_name)
values (6, 'Denis Sklif');

select * 
from tmp join tmp2 on tmp.id = tmp2.team
order by tmp.id;

-- 2. Написать рекурсивный запрос
with recursive SelectPlayers(id, player_name, team, team_name) as 
(
    select players.id, player_name, players.team, teams.team_name
    from players join teams on players.team = teams.id
    where players.id = 1

    union all
    select (players.id + 1), players.player_name, players.team, teams.team_name
    from players inner join (
        SelectPlayers join teams on SelectPlayers.team = teams.id 
    ) on players.id = SelectPlayers.id
    where players.id < 50
)
select *
from SelectPlayers;
