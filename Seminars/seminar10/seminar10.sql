Продолжение 9 семинара 
Пример 6
explain 
select * from dbspj.s join dbspj.spj spj on s.Sno = spj.Sno 
where Qty > 500;
фильтрация на одном уровне со сканированием

Пример 7
explain 
select sp.pno, sp.jno, m.qty
from dbspj.jno join (
    select spj.jno, max(qty) as qty
    from dbspj.spj spj
    group by spj.jno
) m on sp.jno = m. jno and sp.qty = m.qty;

нужно собирать статистику по таблицам, чтобы все работало норм

Пример 8
explain
select pno, jno, qty
from (select pno, jno, qty, 
            row_number() over(partition by jno order by qty desc) as rn
        from dbspj.spj spj) m
where m.rn = 1;

Пример 9
select * from dbspj.s join dbspj.spj spj on s.Sno > spj.Sno 
where Qty > 500;
Стоимость запроса становится 5500, а до этого измеряли сотнями
nested loop плохой вариант


BIG DATA
Массивно параллельные системы обработки
MPP системы и колоночное хранение
Масштабирование в ширину
Наши данные разделяются по разным процессорам и дискам. Мб несколько десятков и сотен парал. работающих компов.
Обеспечивает большее количество запросов. Можно делать выборку на большем объеме.
2 аппаратные архитектуры
1. Vertica
Хранит данные в проекциях
Проекция:
супер (наша таблица) - содержит все столбцы
запрос-ориентированная (чтобы ускорить запрос) - хранит набор атрибутов, которые нужны
агрегированные (для ускорения запросов)
Для больших данных создаются сегментированные процекции (раскладываем равномерно по нодам)
Разделять на несколько узлов:
появилась возможность в случае падения базы использовать другую ноду
отсутствие единой точки отказа

Отказоустойчивость
Больше пользователей
Тех обслуживание - достаем кластер, все работает

по файлам - партицирование
по нодам - сегментирование

Отказоустойчивость - key safety
принимает либо 
0 - не делаем копии
1 - на каждую проекцию создается копия и раскладывается по 1 узлу
2 - на 1 сегм проекцию создается 2 копии и раскладывается по 2 узлам
  
Колоночное хранение
в случае построчного хранения - мы читаем всю строку и если лежит файл большой, то придется прочитать, даже если не нужен   

GreenPlum
Взаимодействие узлов(сегментов)
Отношения:
1. мастер-сервер - точка входа
распределяет задания между сегментами
и собирать данные
координация работы системы
2. есть secondary master - при отказе основного мастера
3. сервер-сегмент - хранит данные

