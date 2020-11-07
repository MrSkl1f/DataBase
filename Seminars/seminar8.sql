Курсоры
похож на список с указателем
курсор - указатель на список

Курсоры
------>   ---
            ---
            ---
            ---

использовать в реальной жизни нежелательно

Классификация курсоров
1. по области видимости:
    - глобальные (global)
    - локальные (local)
2. по типу
    - статические (static) 
    создаем курсор ввиде слепка на эту таблицу (можем делать ограничения - только четные)
    минус: делаем вставку или удаление из test -> в слепке не видно
    - динамический (dynamic)
    - keyset курсор 
    выгружаем и отслеживаем только зафиксированные ключи
    удаление/добавление не отслеживается курсорами keyset
    - fast_forward
    как keyset, только более оптимизированный в случе, когда идем в одном направлении (вниз/вверх)
3. по направлению движения
    - scroll
    вверх/вниз
    - forward_only
    только вниз

4. параллельная работа
    - read_only
    - оптимистичные (optimistic)
    1 выгружает копию, с ней работает, остальные получают доступ. как только 1 закончил - он сливает данные
    всех остальных отбрасываем (только 1 выбрал)
    - пессимистичные (scroll_locks)

Общая схема
declare <имя> cursor 
[по области видимости] local
[по типу] dynamic
[по направлению движения] forward_only
[по параллельной работе] 
for
    <sql-запрос>

Пример
declare myCursor cursor, Sname text, Pname text
for select Sname, Pname
    from S join SP on (S.Sno = SP.Sno)
    join P on (SP.Pno = P.Pno)

open myCursor
fetch next myCursor into Sname, Pname
close myCursor

Для MySQL
while @@Fetch_status > 0
begin 
    fetch next ...
    print ...
end

for <связанная переменная> in myCursor
loop
    print
end loop



Индексы
Индекс - B-дерево
Balanced Tree
Сбалансированное двоичное дерево поиска
Разница между левым и правым поддеревом не больше 1
Индексы представляются в виде сбалансированного дерева поиска
Допустим фильтрация по полю id
Тогда создаем индекс
                        1-100   id
                    /               \
                1-50        <->     50-100
            /          \                  /         \
        1-25<->26-50<->50-75<->76-100
- кластиризованный
- (если ссылки) не кластеризованный

select *
from test_table
where id between 29 and 58

+ быстрый селект
- доп ресурсы
- insert    

create index [clustered, nonclustered] myIndex
on <имя объекта> (<список атрибутов>)

create index myIndex
on test_table (id)
 

Партиционирование
id  ...     date
1   ...     2020-11-07   
2   ...     2020-11-07
3   ...     2020-11-06
    |
    V
partition by date
    |
    V
partition_2020_11_07
id  ...     date
1   ...     2020-11-07
2   ...     2020-11-07
partition_2020_11_06
id  ...     date
3   ...     2020-11-06


create table test_table(id int, "date" date)
partition by year(date)
