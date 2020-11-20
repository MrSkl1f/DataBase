Оптимизация запросов. План запроса
Postgres - клиент-серверная модель
Клиент создает процсс postmaster: 
- служебные процессы
- серверный процесс: есть память -  
временный буферы sort hashes
fork()

Ресурс - таблица (в наших задачах)
Постгрес работает на семафорах
Отличие: семафор не знает кто владелец и освобождает любая, а mutex освобождает тот, кто знает.

Дерево разбора:
- атом
- синтаксические категории

План запроса 
Пример 1
explain 
select * from dbspj.spj s
Результат Seq Scan on spj s (cost=0.00..28.50 rows=1850 width=16)
используем последовательное сканирование таблицы, цену, сколько строк будет просчитано и сколько столбцов будет просчитано (предположение)
0.00 - значит, что возможно уже прочитали

Пример 2
explain 
select * from dbspj.spj s
where jno = 2
Результат 
1) Seq Scan on spj s (cost=0.00..33.12 rows=9 width=16)
2) Filter:(jno = 2)

Пример 3
explain 
select * from dbspj.s
where Sno in (select Sno
                        from dbspj.spj s
                        where Qty > 500)

Пример 4
explain 
select * from dbspj.s inner join dbspj.spj spj on s.Sno = spj.Sno and Qty > 500;

Пример 5
explain 
select * from dbspj.s inner join dbspj.spj spj on s.Sno = spj.Sno and Qty > 500;