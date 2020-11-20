-- Задание 1. Создать базу данных RK2. Создать в ней структуру, соответствующую указанной на ER-диаграмме. 
-- Заполнить таблицы тестовыми значениями (не менее 10 в каждой таблице)

-- ПРИМЕР ИЗ ПОДГОТОВКИ
create table if not exists medication (
	id serial not null primary key,
	name varchar(30) not null,
	instruction varchar(30),
	cost int,
);

create table if not exists employee (
	id serial not null primary key,
	department_id int references department(id) not null,
	position varchar(30),
	fio varchar(30),
    salary int
);

create table if not exists department (
	id serial not null primary key,
	department_name varchar(30) not null,
	number varchar(30),
	manager int references employee(id)
);

create table if not exists em (
    id_medication int references medication(id),
    id_employee int references employee(id)
);

-- ПРИМЕР У ПУМЫ 
-- ВАРИАНТ 2
drop table currency;
drop table exchange_rate;
drop table employee;
drop table operation;

create table if not exists currency (
    id serial not null primary key,
    name varchar(30)
);

create table if not exists exchange_rate (
    id serial not null primary key,
    currency_id int references currency(id),
    sale real,
    purchase real
);

create table if not exists employee (
    id serial not null primary key,
    fio varchar(30),
    birth date,
    position varchar(30)
);

create table if not exists operation (
    id serial not null primary key,
    employee_id int references employee(id) not null,
    exchange_rate_id int references exchange_rate(id),
    summ int
);

-- INTO CURRENCTY
insert into currency(name)
values ('Canadian dollar');
insert into currency(name)
values ('European Euro');
insert into currency(name)
values ('Kuwaiti Dinar');
insert into currency(name)
values ('Bahrain Dinar');
insert into currency(name)
values ('Oman Rial');
insert into currency(name)
values ('Jordan Dinar');
insert into currency(name)
values ('British Pound Sterling');
insert into currency(name)
values ('Cayman Islands Dollar');
insert into currency(name)
values ('Swiss Franc');
insert into currency(name)
values ('US Dollar');
-- INTO EXCHANGE_RATE
insert into exchange_rate(currency_id, sale, purchase)
values(1, 0.75, 0.77);
insert into exchange_rate(currency_id, sale, purchase)
values(2, 1.19, 1.21);
insert into exchange_rate(currency_id, sale, purchase)
values(3, 3.27, 3.29);
insert into exchange_rate(currency_id, sale, purchase)
values(4, 2.66, 2.68);
insert into exchange_rate(currency_id, sale, purchase)
values(5, 2.60, 2.62);
insert into exchange_rate(currency_id, sale, purchase)
values(6, 1.41, 1.43);
insert into exchange_rate(currency_id, sale, purchase)
values(7, 1.31, 1.33);
insert into exchange_rate(currency_id, sale, purchase)
values(8, 1.22, 1.24);
insert into exchange_rate(currency_id, sale, purchase)
values(9, 1.10, 1.12);
insert into exchange_rate(currency_id, sale, purchase)
values(10, 1, 1.02);
-- INTO employee
insert into employee(fio, birth, position)
values ('1', '1999-01-09', '1');
insert into employee(fio, birth, position)
values ('2', '1999-01-10', '2');
insert into employee(fio, birth, position)
values ('3', '1999-01-05', '3');
insert into employee(fio, birth, position)
values ('4', '1999-01-03', '4');
insert into employee(fio, birth, position)
values ('5', '1999-01-02', '5');
insert into employee(fio, birth, position)
values ('6', '1999-01-01', '6');
insert into employee(fio, birth, position)
values ('7', '1999-01-12', '7');
insert into employee(fio, birth, position)
values ('8', '1999-01-13', '8');
insert into employee(fio, birth, position)
values ('9', '1999-01-15', '9');
insert into employee(fio, birth, position)
values ('10', '1999-01-23', '10');
-- INTO OPERATION
insert into operation(employee_id, exchange_rate_id, summ)
values (5, 5, 412);
insert into operation(employee_id, exchange_rate_id, summ)
values (4, 1, 765);
insert into operation(employee_id, exchange_rate_id, summ)
values (6, 2, 123);
insert into operation(employee_id, exchange_rate_id, summ)
values (3, 3, 856);
insert into operation(employee_id, exchange_rate_id, summ)
values (7, 6, 523);
insert into operation(employee_id, exchange_rate_id, summ)
values (1, 10, 567);
insert into operation(employee_id, exchange_rate_id, summ)
values (2, 9, 345);
insert into operation(employee_id, exchange_rate_id, summ)
values (9, 8, 54);
insert into operation(employee_id, exchange_rate_id, summ)
values (10, 7, 345);
insert into operation(employee_id, exchange_rate_id, summ)
values (8, 6, 745);
insert into operation(employee_id, exchange_rate_id, summ)
values (8, 6, 456);

-- Задание 2
-- 1) select использующую простой case
select *, 
    case operation.summ when 856 then 'rich'
                        when 123 then 'not rich'
                        when 523 then 'middle'
    end as summ
from operation;

-- 2) инструкцию, использующую оконную функцию
select max(operation.summ) over (partition by exchange_rate_id)
from operation;

-- 3) select, group by и having
select employee_id
from operation 
group by employee_id
having avg(summ) > (
	select avg(summ)
	from operation 
);

-- Задание 3
-- с божьей помощью