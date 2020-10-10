-- детерминированные не завистят от результата
-- не детерминированные зависят от результата

-- Функции 
-- 1. Скалярные
create function [схема].имя (<параметры>)       -- параметры: id int (имя, тип)
returns <скалярный тип>
[with <опции>]                                  
[as]                                           -- переходим от описания к телу
-- declare (для постгреса) id int,
--                         name varchar(10)
Begin 
    <тело функции>
    return <скалярная переменная>               -- должна соответствовать объявленному
end[;]

-- Примеры
create function dbo.AvgPrice()
returns smallmoney
with schemabinding
as
Begin
    return (select avg(Price)
            from dbo.P)
end;
-- Пример
create function dbo.PriceDiff(
                @Price smallmoney)
                -- @@ Price - глобальная
                -- для постгреса global ...
returns smallmoney
as
Begin
    return @Price-dbo.AvgPrice()
end;
-- Пример
select Price,dbo.AvgPrice(),dbo.Pricediff(Price)
from P
-- Таблица 1

-- 2. подставляемые
create function [схема].имя (
                <параметры>)
returns table
[with <опции>]
[as]
    return <sql-запрос>
end[;]
-- Пример
create function dbo.FullSPJ(@id int)
returns table
as
    return select Sname,Pname
            from S join SP
                on S.Sno=Sp.Sno
                join P
                on P.Pno=Sp.Pno
            where S.Sno = @id

select * from dbo.FullSPJ(3)
-- у постгресса нет подставляемой функций, но зато есть многооператорные
-- 3. многооператорная
create function [схема].имя (
                <параметры>)
returns @табл.перем. table (<описание>)
[with <опции>]
[as]
Begin
    <тело>
    return
end[;]
-- Пример
create function dbo.fngetReport()
returns @Reports table(EmplID int
                       ReportId int)
as 
Begin
    declare @EID int
    insert into @Reports values (1,1)
    insert into @Reports values (1,2)
    set @EID=3
    return
end;
-- Пример для постгреса
-- Таблица Test
create function public.fnCreateTest()
returns void
language OL.pgSQL
as $func$
declare
    maxId int
    maxName varchar(10)
Begin
    select max(id) + 1, 'test' || max(id) + 1
    from test
    into maxId, maxName
    Query Execute 'insert into test values(' + maxId + ',''' + maxName + ''');'
end;