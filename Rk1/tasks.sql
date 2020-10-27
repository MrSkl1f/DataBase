-- Получить все пары вида <ФИО туриста, Страна проживания>
-- sql
select FirstName, LastName, Country
from Tourists join Cities on Tourists.CityID = Cities.CityID;

-- реляционная алгебра
(Tourists join Cities)[FirstName, LastName, Country]

-- исчисления кортежей
range of T is Tourists
range of C is Cities
(T.FirstName, T.LastName, C.Country) where exists C (T.CityID = C.CityID)


-- Получить все пары вида <Достопримечательность, Город>
-- sql
select Sights.Name, Cities.Name
from Sights join Cities on Sights.CityID = Cities.CityID;

-- реляционная алгебра
(Sights join Cities)[Sights[Name], Cities[Name]]

-- исчисления кортежей
range of S is Sights
range of C is Cities
(S.Name, C.Name) where exists C (S.CityID = C.CityID)


-- Получить список всех туристов из Италии
-- sql
select ID, FirstName, LastName, Age, Tourists.CityID
from Tourists join Cities on Tourists.CityID = Cities.CityID
where Cities.Country = 'Италия';

-- реляционная алгебра
((Tourists join Cities) where Cities[Country] = "Италия")[ID, FirstName, LastName, Age, Tourists.CityID]

-- исчисления кортежей
range of T is Tourists
range of C is (Cities) where (Cities.Country = "Италия")
(T.ID, T.FirstName, T.LastName, T.Age, T.CityID) where exists C (T.CityID = C.CityID)


-- Получить все тройки вида <ФИО туриста, Страна, Дата посещения>
-- sql
select Tourists.FirstName, Tourists.LastName, Cities.Country, ST.Date
from Sights join Cities on Sights.CityID = Cities.CityID
join ST on Sights.ID = ST.SightID
join Tourists on ST.TouristID = Tourists.ID;

-- реляционная алгебра
(Sights join Cities join St join Tourists)[Tourists.FirstName, Tourists.LastName, Cities.Country, ST.Date]

-- исчисления кортежей
range of T is Tourists
range of C is Cities
range of S is Sights
range of ST is ST
(T.FirstName, T.LastName, C.Country, ST.Date) where exists C (S.CityID = C.CityID and exists ST (S.SightID = ST.SightID and exists T (ST.TouristID = T.ID)))


-- Получить список всех достопримечательностей, которые посетил Иван Платонов
-- sql
select Sights.Name
from Sights join ST on (Sights.ID = ST.SightID)
join Tourists on (ST.TouristID = Tourists.ID)
where Tourists.FirstName = 'Иван' and Tourists.LastName = 'Платонов';

-- реляционная алгебра
((Sights join ST join Tourists) where Tourists[FirstName] = 'Иван' and Tourists[LastName] = 'Платонов')[Sights.Name]

-- исчисления кортежей
range of T is (Tourists) where Tourists.FirstName = 'Иван' and Tourists.LastName = 'Платонов'
range of S is Sights
range of ST is ST
(S.Name) where exists ST (S.CityID = ST.CityID and exists T (ST.TouristID = T.ID))


-- Получить список всех туристов, посетивших какую-либо страну в период с 05-01-2016 по 07-08-2017
-- sql
select Tourists.FirstName, Tourists.LastName
from Sights join ST on (Sights.ID = ST.SightID)
join Tourists on (ST.TouristID = Tourists.ID)
where ST.Date between '05-01-2016' and '07-08-2021';

-- реляционная алгебра
((Sights join ST join Tourists) where ST.Date > '05-01-2016' and ST.Date < '07-08-2021')[Tourists.FirstName, Tourists.LastName]

-- исчисления кортежей
range of S is Sights
range of T is Tourists
range of ST is (ST) where ST.Date > '05-01-2016' and ST.Date < '07-08-2021'
(Tourists.FirstName, Tourists.LastName)


-- Получить список всех туристов из Москвы, не посетивших ни одной достопримечательности в Санкт-Петербурге
--sql
select Tourists.ID
from Tourists join Cities on (Tourists.CityID = Cities.CityID) 
where Tourists.ID not in (
    select Tourists.ID
    from Tourists join ST on (Tourists.ID = ST.TouristID)
    join Sights on (ST.SightID = Sights.ID)
    join Cities on (Sights.CityID = Cities.CityID)
    where Cities.Name = 'Москва'
) and Cities.name = 'Берлин';

-- реляционная алгебра
((Tourists join Cities) where TouristID minus ((Tourists join ST join Sights join Cities) where Cities[Name] = 'Москва')[TouristID] and Cities[Name] = 'Берлин')[TouristID]

-- исчисления кортежей
range of TX is Tourists
range of CX is Cities where Cities.Name = 'Берлин'
range of STX is ST
range of SX is Sights
range of TY is Tourists
range of CY is Cities where Cities.Name = 'Москва'
(TY.ID) where exists CX (CX.CityID = TY.CityID) minus ((TX.ID) where exists STX (STX.TouristID = TY.ID and exists SX (STX.ID = SX.SightID and exists CY (CY.CityID = SX.CityID))))


-- Получить список всех туристов, никогда не бывших в Турции
-- sql 
select Tourists.ID
from Tourists 
where Tourists.ID not in (
    select Tourists.ID
    from Tourists join ST on (Tourists.ID = ST.TouristID)
    join Sights on (ST.SightID = Sights.ID)
    join Cities on (Sights.CityID = Cities.CityID)
    where Cities.Country = 'Турция'
);

-- реляционная алгебра
((Tourists where TouristID minus ((Tourists join ST join Sights join Cities) where Cities[Country] = 'Турция')[TouristID])[TouristID]

-- исчисления кортежей
range of TX is Tourists
range of STX is ST
range of SX is Sights
range of TY is Tourists
range of CY is Cities where Cities.Country = 'Турция'
(TY.ID) minus ((TX.ID) where exists STX (STX.TouristID = TY.ID and exists SX (STX.ID = SX.SightID and exists CY (CY.CityID = SX.CityID))))


-- Получить список туристов, побывавших в Амстердаме
-- sql
select Tourists.ID
from Tourists join ST on (Tourists.ID = ST.TouristID)
join Sights on (ST.SightID = Sights.ID)
join Cities on (Sights.CityID = Cities.CityID)
where Cities.Name = 'Амстердам';

-- реляционная алгебра
((Tourists join ST join Sights join Cities) where Cities[Name] = 'Амстердам')[TouristID]

-- исчисления кортежей
range of TX is Tourists
range of STX is ST
range of SX is Sights
range of TY is Tourists
range of CY is Cities where Cities.Name = 'Амстердам'
(TX.ID) where exists STX (STX.TouristID = TY.ID and exists SX (STX.ID = SX.SightID and exists CY (CY.CityID = SX.CityID)))


-- Получить список всех туристов из Москвы, посещавших достопримечательности только в своей стране
-- sql
select Tourists.ID
from Tourists join Cities on (Tourists.CityID = Cities.CityID) 
where Tourists.ID not in 
(
    select Tourists.ID
    from Tourists join ST on (Tourists.ID = ST.TouristID)
    join Sights on (ST.SightID = Sights.ID)
    join Cities on (Sights.CityID = Cities.CityID)
    where Cities.Country <> 'Россия' 
) and Cities.name = 'Москва';

-- реляционная алгебра
((Tourists join Cities) where Tourists[ID] minus (Tourists join ST join Sights join Cities where Cities[Country] <> 'Россия')[Tourists[ID]] and Cities[Name] = 'Москва') 

-- исчисления кортежей
range of TX is Tourists
range of CX is Cities where Cities.Name = 'Москва'
range of TY is Tourists
range of STX is ST
range of SX is Sights
range of CY is Cities where Cities.Country <> 'Россия'
(TX.ID) where exists CX (CX.CityID = TX.CityID) minus ((TY.ID) where exists STX (STX.TouristID = TY.ID and exists SX (SX.ID = STX.SightID and exists CY (CY.CityID = SX.CityID))))


-- Получить имена всех туристов, не посетивших ни одну достопримечательность
-- sql
select FirstName
from Tourists
where Tourists.ID not in 
(
    select TouristID
    from ST
);

-- реляционная алгебра
(Tourists where TouristID minus (ST[Tourists]))[FirstName]

-- исчисления кортежей
range of TX is Tourists
range of TY is Tourists
range of STX is ST
(TX.ID) minus ((STX.TouristID) where exists STX (TY.ID = STX.TouristID))


-- Получить все пары вида <Название достопримечательности, количество посетивших ее туристов>
-- sql
select Sights.Name, count(ST.TouristID) 
from Sights join ST on (Sights.ID = ST.SightID)
group by Sights.Name;

-- реляционная алгебра
summarize (ST join Sights) per Sights{Name} add count as cntM

-- исчисления кортежей
range of SX is Sights
range of STX is ST
(SX.Name, COUNT(STX.TouristID where exists STX (STX.SightID = SX.ID)))


-- Получить ФИО самого молодого туриста
-- sql
select FirstName, LastName
from Tourists
where age = 
(
    select min(Tourists.age)
    from Tourists
);

-- реляционная алгебра
(summarize Tourists per Tourists{age} add min(age) as mM)[FirstName, mM] 

-- исчисления кортежей
range of TX is Tourists
(TX.FirstName, MIN(TX.age))


-- Получить максимальный возраст туриста из Испании
-- sql
select max(Tourists.age)
from Tourists join Cities on Tourists.CityID = Cities.CityID
where Cities.Country = 'Испания';

-- реляционная алгебра
(SUMMARIZE ((Tourists JOIN Cities) WHERE Cities[Country] = 'Испания') PER Tourists{age}
ADD max(age) AS cntM)[cntM]

-- исчисления кортежей
range of TX is Tourists
range of CX is Cities where Cities.Country = 'Испания'
(max(TX.age where exists CX(CX.CityID = TX.CityID)))


-- Получить количество туристов в возрасте до 30 лет
-- sql
select count(*)
from Tourists
where Tourists.age < 30;

-- реляционная алгебра
(SUMMARIZE (Tourists WHERE Tourists[age] < 30) PER Tourists{ID}
ADD count AS cntM)[cntM]

-- исчисления кортежей
range of TX is Tourists where Tourists.age < 30
(count(TX))


-- Получить средний возраст туристов, посетивших Бранденбургские ворота
-- sql
select avg(Tourists.age)
from Tourists join ST on (Tourists.ID = ST.TouristID)
join Sights on (Sights.ID = ST.SightID)
where Sights.Name = 'Площадь';

-- реляционная алгебра
(summarize (Tourists join ST join Sights where Sights[Name] = 'Площадь') per Tourists{ID} add avg(Tourists.age))
(summarize (Tourists join ST join Sights where Sights[Name] = 'Площадь') per Tourists{ID} add (sum(Tourists.age) / count(Tourists.ID)) as avgT)[avgT]

-- исчисления кортежей
range of TX is Tourists
range of STX is ST
range of SX is Sights where Sights.Name = 'Площадь'
(avg(TX.age)) where exists STX(STX.TouristID = TX.ID and exists SX (SX.SightID = STX.SightID))


-- Получить максимальный возраст туриста из Москвы
-- sql
select max(Tourists.age)
from Tourists join Cities on Tourists.CityID = Cities.CityID
where Cities.Name = 'Москва';

-- реляционная алгебра
(SUMMARIZE ((Tourists JOIN Cities) WHERE Cities[Name] = 'Москва') PER Tourists{age}
ADD max(age) AS cntM)[cntM]

-- исчисления кортежей
range of TX is Tourists
range of CX is Cities where Cities.Name = 'Москва'
(max(TX.age where exists CX(CX.CityID = TX.CityID)))
