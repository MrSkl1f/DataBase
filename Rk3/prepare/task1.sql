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
values (1, '14-12-2018', 'Суббота', '09:00', 1),
(1, '14-12-2018', 'Суббота', '09:20', 2),
(1, '14-12-2018', 'Суббота', '09:25', 1),
(2, '14-12-2018', 'Суббота', '09:05', 1);

insert into staff(fio, birth, department)
values ('Иванов Иван Иванович', '25-09-1990', 'ИТ'),
('Петров Петр Петрович', '12-11-1987', 'Бухгалтерия');

drop function if exists latecomers;
create function latecomers(need_date date)
returns bigint
as $$
	select count(*)
	from (
		select arrival_leaving.id
		from arrival_leaving
		where dt = '14-12-2018' and tp = 1
		group by arrival_leaving.id
		having min(arrival_leaving.tm) > '8:00'
	) as res;
$$ language sql;

select * from latecomers('14-12-2018'); 







