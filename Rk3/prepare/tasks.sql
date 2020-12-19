drop table if exists arrival_leaving;
create table if not exists arrival_leaving(
    id int not null,
    dt date,
    day_of_week varchar(30),
    tm time,
    tp int
);

drop table if exists staff;
create table if not exists staff(
    id serial not null primary key,
    fio varchar(50),
    birth date,
    department varchar(30)
);

insert into arrival_leaving(id, dt, day_of_week, tm, tp)
values (1, '2018-12-14', 'Суббота', '09:00', 1),
(1, '2018-12-14', 'Суббота', '09:20', 2),
(1, '2018-12-14', 'Суббота', '09:25', 1),
(2, '2018-12-14', 'Суббота', '09:05', 1);

insert into staff(fio, birth, department)
values ('Иванов Иван Иванович', '1990-09-25', 'ИТ'),
('Петров Петр Петрович', '1987-12-11', 'Бухгалтерия');

drop function if exists latecomers;
create function latecomers(need_date date)
returns bigint
as $$
	select count(*)
	from (
        select arrival_leaving.id
        from arrival_leaving
        where dt = need_date and tp = 1
	    group by arrival_leaving.id
	    having min(arrival_leaving.tm) > '08:00'
    ) as res
    
$$ language sql;

select * from latecomers('2018-12-14');

insert into arrival_leaving(id, dt, day_of_week, tm, tp)
values (3, '2018-12-14', 'Суббота', '09:55', 1)

----------------------------------------------

insert into arrival_leaving(id, dt, day_of_week, tm, tp) VALUES
(1, '2018-12-10', 'Monday', '9:30', 1),
(2, '2018-12-10', 'Monday', '8:30', 1),
(3, '2018-12-10', 'Monday', '10:30', 1),
(3, '2018-12-10', 'Monday', '11:30', 2),
(3, '2018-12-10', 'Monday', '11:45', 1),
(1, '2018-12-10', 'Monday', '20:30', 2),
(2, '2018-12-10', 'Monday', '17:30', 2),
(3, '2018-12-10', 'Monday', '19:30', 2),
(3, '2018-12-14', 'Suturday', '8:50', 1),
(1, '2018-12-14', 'Suturday', '9:00', 1),
(1, '2018-12-14', 'Suturday', '9:20', 2),
(1, '2018-12-14', 'Suturday', '9:25', 1),
(2, '2018-12-14', 'Suturday', '9:05', 1);



insert into staff(fio, birth, department) VALUES
('Ivanov II', '1990-09-25', 'IT'),
('Petrov PP', '1987-11-12', 'Counter'),
('Sidorov SS', '1999-01-10', 'Counter');

-----3--------
select dep, count(id)
from (
    select arrival_leaving.id as id, staff.department as dep
    from arrival_leaving join staff
    on arrival_leaving.id = staff.id
    where tp = 1
    group by arrival_leaving.id, staff.department
    having min(tm) > '8:00'
) as foo
group by dep;

update staff
set department = 'IT' where department = 'ИТ';

---1---
select department
from(
    select id, wk, yr, count(*)
    from(
        select id, extract (week from dt) as wk, extract (year from dt) as yr
        from 
        (
            select arrival_leaving.id as id, arrival_leaving.dt, min(tm) as mt
            from arrival_leaving
            where tp = 1
            group by arrival_leaving.id, dt
        ) as foo
        where mt > '8:00'
    ) as foo2
    group by id, wk, yr
    having count(*) > 1
) as foo3
join staff on foo3.id = staff.id
group by department


insert into arrival_leaving(id, dt, day_of_week, tm, tp) VALUES
(1, '2018-12-30', 'Monday', '12:30', 1)


