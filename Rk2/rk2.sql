Заголовок РК2 фамилия группа
просто текст sql без файлов
17 40 отправлено
Вариант 4

-- 1 задание

drop table if exists dg;
drop table if exists duty;
drop table if exists empl;
drop table if exists guard;

create table if not exists duty (
    id serial primary key not null,
    date_duty date,
    work_hours int
);
insert into duty (date_duty, work_hours)
values ('2000-01-08', 5),
        ('2000-01-09', 8),
        ('2000-01-07', 7),
        ('2000-01-06', 5),
        ('2000-01-05', 4),
        ('2000-01-04', 5),
        ('2000-01-03', 6),
        ('2000-01-02', 7),
        ('2000-01-01', 8),
        ('2000-01-05', 7);
select * from duty;


create table if not exists empl (
    id serial primary key not null,
    fio varchar(30),
    birth date,
    experience int, 
    phone varchar(30)
);
insert into empl (fio, birth, experience, phone)
values ('1', '2000-01-08', 4, '1'),
        ('2', '2000-01-09', 5, '2'),
        ('3', '2000-01-06', 3, '3'),
        ('4', '2000-01-04', 2, '4'),
        ('5', '2000-01-05', 0, '5'),
        ('6', '2000-01-06', 2, '6'),
        ('7', '2000-01-07', 1, '7'),
        ('8', '2000-01-08', 6, '8'),
        ('9', '2000-01-30', 8, '9'),
        ('10', '2000-01-14',10, '10');
select * from empl;


create table if not exists guard (
    id serial primary key not null,
    name varchar(30),
    adr varchar(30)
);
insert into guard (name, adr)
values ('1', '1'),
        ('2', '2'),
        ('3', '3'),
        ('4', '4'),
        ('5', '5'),
        ('6', '6'),
        ('7', '7'),
        ('8', '8'),
        ('9', '9'),
        ('10', '10');
select * from guard;

create table if not exists dg (
    duty_id int references duty(id),
    employee_id int references employee(id)
);
insert into dg (duty_id, employee_id)
values (1, 1),
        (2, 2),
        (3, 3),
        (4, 4),
        (5, 5),
        (6, 6),
        (7, 7),
        (8, 8),
        (9, 9),
        (10, 10);
select * from dg;

-- Задание 2
-- 1 - select, использующая поисковое выражение case
-- добавляет столбец - описание опыта (больше или меньше 5)
select *, 
    case when experience > 5 then 'больше 5'
                    when experience < 5 then 'меньше 5'
                    when experience = 5 then 'ровно 5'
    end as exp
from empl;

-- update со скалярным подзапросом в предложении и set
-- меняет стаж у сотрудника с id 3 на такой же стаж, как у сотрудника с id 6
update empl
set experience = (
    select experience
    from empl
    where id = 6
)
where id = 3;

-- select group by и having
-- вывести фамилию, максимальный и минимальный опыт, у которых средний опыт больше 5
select fio, max(experience) as max_exp, min(experience) as min_exp
from empl
group by fio
having avg(experience) > 5;

-- Задание 3
-- Создать хранимую процедуру с выходным параметром, которая уничтожает
-- все SQL DDL триггеры (триггеры типа 'TR') в текущей базе данных.
-- Выходной параметр возвращает количество уничтоженных триггеров.
-- Созданную хранимую процедуру протестировать. 


