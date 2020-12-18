-- копируем во временную
drop table if exists pl_import;
create temp table pl_import(doc jsonb);
\copy pl_import from '/var/lib/postgres/teams.json';

----- TASK 1 -----
-- Извлечь XML/JSON фрагмент из XML/JSON документа
-- создаем основную
drop table if exists task1;
create table if not exists task1
(
	team jsonb
);

-- извлекаем фрагменты
insert into task1 (team)
select  doc
from pl_import
where cast(doc::jsonb->>'id' as int) = 36;

select * from task1;
------------------

----- TASK 2 -----
-- Извлечь значения конкретных узлов или атрибутов   XML/JSON документа
-- создаем основную
drop table if exists task2;
create table if not exists task2
(
	id int not null,
	team text, 
	country text
);
-- извлекаем
insert into task2 (id, team, country)
select  cast(doc::jsonb->>'id' as int), doc::jsonb->>'team_name', doc::jsonb->>'country' 
from pl_import;

select * from task2;
------------------

----- TASK 3 -----
-- Выполнить проверку существования узла или атрибута
SELECT doc::jsonb ? 'country' as result
from pl_import
where cast(doc::jsonb->>'id' as int) = 36;

SELECT doc::jsonb ? 'cntry' as result
from pl_import
where cast(doc::jsonb->>'id' as int) = 36;
------------------

----- TASK 4 -----
-- Изменить XML/JSON документ
select doc->>'team_name'
from pl_import
where cast(doc->>'id' as int) = 36;

update pl_import
set doc = jsonb_set(doc, '{team_name}', '"Delaware"')
where cast(doc->>'id' as int) = 36;

update pl_import
set doc = jsonb_set(doc, '{team_name}', '"Delaware 87ers"')
where cast(doc->>'id' as int) = 36;
------------------

----- TASK 5 -----
-- Разделить XML/JSON документ на несколько строк по узлам
drop table if exists task4_1;
drop table if exists task4_2;
create table if not exists task4_1
(
	doc jsonb
);
create table if not exists task4_2
(
	doc jsonb
);
insert into task4_1(doc)
select doc - 'stadium' - 'country' - 'team_name'
from pl_import;

insert into task4_2(doc)
select doc - 'id' - 'management' - 'headquarter'
from pl_import;