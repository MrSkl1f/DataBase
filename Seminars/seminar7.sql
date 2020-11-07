-- Хранимые процедуры 
create procedure имя <список параметров>
[with <опции>]
as 
begin 
    <тело>
end;

-- пример
create procedure dbo.Factorial @ValIn bigint, @ValOut bigint
as 
begin 
    if @ValIn > 20
    begin
        print 'ERROR'
        return -99
    end
    declare @WorkValIn bigint,
                   @WorkValOut bigint
    if @ValIn != 1
    begin 
        set @WorkValIn = @ValIn - 1
        print @@NestLevel
        exec dbo.Factorial @WorkValIn, @WorkValOut output
        set @ValOut = @ValIn * @WorkValOut
    end
    else
        set @ValOut = 1
end;

declare @FactIn bigint,
               @FactOut bigint
set @FactIn = 8
exec dbo.Factorial @FactIn, @FactOut output
print 'Fact = ' + convert(varchar(10), @FactOut)
-- cast(@FactIn as varchar(10))

-- Хранимые процедуры доступа к метданным
-- ЗАДАНИЕ --
табличка Test
id | name
1  | test1
2  | test2
...
n  | testn
выполнить insert n + 1 теста

(1) найти max
(2) сделать insert

create function testMaker ()
returns void
language PLgpSQL
as $$
declare maxId int, maxName text
begin 
    select max(id) + 1, 'test' || max(id) + 1
    from test
    into maxId, maxName
    insert into Test values(maxId, maxName)
end $$;

create function testMaker ()
returns void
language PLgpSQL
as $$
declare maxName text
begin 
    select 'insert into test test values(' || max(id) + 1 || ',''test' || max(id) + 1 ||' '');' ??????
    from test
end $$;
------------------------
| ДАНЯ КРАСАВЧИК |
------------------------
            ДА          
-- Триггеры
--devil trigger
- DDL-триггер - create/drop/alter
- DML-триггер - insert/update/delete

                        instead of      after/before
тип объекта table               table
                        view
число              1                      бесконечность

create trigger <имя>
on <таблица/представление>
<класс триггера> <действие>
-- есть технические поля is_actual и в случае удаления ставится 0 (where is_actual = 1)

-- Пример
create trigger afterSPinsert
ob SP
after insert, update
as
    begin
        raiserror('Новая поставка')
    end