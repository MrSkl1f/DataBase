-- Извлечь XML/JSON фрагмент из XML/JSON документа
-- копируем во временную
drop table if exists pl;
create temp table pl_import(doc json);
\copy pl_import from '/home/mrskl1f/Desktop/BMSTU/DataBase/lab5/Task4/players.json';
-- создаем основную
drop table if exists json_test;
create table if not exists json_test
(
	id int,
	player varchar(40),
	games json
);
-- извлекаем фрагменты
insert into json_test(id, player, games)
select ... 
from (
    select 
)