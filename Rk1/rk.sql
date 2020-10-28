НЕ УВЕРЕН, ЧТО ПРАВИЛЬНО!!!

Вариант 9
Склифасовский Денис
Задание 1
Пусть есть связочная таблица DC, которая содержит соответствие DriverID к CarID
DC(DriverID:int, CarID:int) - связочная таблица для Drivers и Cars
Также для Fines необходимо добавить FK DriverID

Найти все пары вида <ФИО водителя, дата регистрации его автомобиля>

sql:
select Drivers.FIO, Cars.RegistrationDate
from Cars join DC on (Cars.CarID = DC.CarID)
join Drivers on (Drivers.DriverID = DC.DriverID)

РА:
(Drivers join DC join Cars)[Drivers.FIO, Cars.RegistrationDate]

ИК:
range of D is Drivers
range of C is Cars
range of DCX is DC
(D.FIO, C.RegistrationDate) where exists DCX (D.DriverID = DCX.DriverID and exists C (DCX.CarID = C.CarID))

Найти телефоны водителей, у которых есть белая машина 2018 года выпуска
sql:
select Drivers.Phone
from Cars join DC on (Cars.CarID = DC.CarID)
join Drivers on (Drivers.DriverID = DC.DriverID) 
where Cars.Year = 2018 and Cars.Color ='белая'

РА:
((Drivers join DC join Cars) where Cars[Year] = 2018 and Cars[Color] = 'белая')[Drivers.Phone]

ИК:
range of D is Drivers
range of C is Cars where Cars.Year = 2018 and Cars.Color = 'белая'
range of DCX is DC
(D.Phone) where exists DCX (D.DriverID = DCX.DriverID and exists C (DCX.CarID = C.CarID))


Найти машины, которыми владеют более 2х водителей
sql:
select Cars.CarID
from Cars join (
    select DC.CarID, count(*) as Cnt
    from DC
    group by DC.CarID
) on (Cars.CarID = DC.CarID)
where Cnt > 2

РА:
(Summarize (Cars join DC) per DC{CarID} add count as Cnt where Cnt > 2)[Cars.CarID]

ИК:
range of СX is Cars
range of DCX is DC
(Cars.CarID) where exists DCX (DCX.CarID = CX.CarID and exists count (FX.DriverID) as cnt (cnt > 2)


Заддание 2
R(A,B,C,D,E,F)
F{A->BC, AC->DE,D->F,E->AB}
Найти минимальное покрытие
Шаг 1: правые стороны атомными
G = {A->B,A->C,AC->D,AC->E,D->F,E->A,E->B}
Шаг 2: удалить избыточные фз:
Для A->B: A+ = ACDEFB - удаляем
G = {A->C,AC->D,AC->E,D->F,E->A,E->B}
Для A->C: A+ =A - оставляем
Для AС->В: AС+ =ACEB - оставляем
Для AC->E: AC+ =ACDF - оставляем
Для D->F: D+ =D - оставляем
Для E->A: E+ =EB - оставляем
Для E->B: E+ =EACDEF - оставляем
Шаг 3: Удалить все избыточные признаки с левой стороны фз
Для AC->D:
Для A вычисляем C+ удаляя AC->D и добавляя C->D, C+=CDF => не избыточный
Для C вычисляем A+ удаляя AC->D и добавляя A->D, A+=ACDEFB => избыточный удаляем
Для AC->E
Для A вычисляем C+ удаляя AC->E и добавляя C->E, C+=CEABD => избыточный удаляем
Для C вычисляем A+ удаляя AC->E и добавляя A->E, A+=ACDEFB => избыточный удаляем

Ответ: Минимальное покрытие = {A->C,A->D,D->F,E->A,E->B}
