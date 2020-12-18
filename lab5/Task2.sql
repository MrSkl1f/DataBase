-- Выполнить загрузку и сохранение XML или JSON файла в таблицу. 
-- Созданная таблица после всех манипуляций должна соответствовать таблице базы данных, 
-- созданной в первой лабораторной работе.

-- сохраняем в файл 
\copy (select row_to_json(teams) from teams) to '/var/lib/postgres/teams.json';
-- создаем временную таблицу
create temp table teams_import(doc json);
\copy teams_import from '/var/lib/postgres/teams.json';

-- json_populate_record
-- Расширяет объект в from_json до строки, столбцы которой соответствуют типу записи, заданному базой.
select team.*
from teams_import, json_populate_record(null::teams, doc) as team;

drop table teams_import;


drop table players_import;
\copy (select row_to_json(players) from players) to '/var/lib/postgres/players.json';
create temp table players_import(doc json);

\copy players_import from '/var/lib/postgres/players.json';
select player.*
from players_import, json_populate_record(null::players, doc) as player;

