-- Получить все пары вида <ФИО туриста, Страна проживания>
-- sql
select FirstName, LastName, Country
from Tourists join Cities on Tourists.CityID = Cities.CityID;

-- реляционная алгебра
(Tourists join Cities)[FirstName, LastName, Country]

-- исчисления кортежей
range of T is Tourists
range of C is Cities
(T.FirstName, T.LastName, C.Country) T where exists C (T.CityID = C.CityID)


-- Получить все пары вида <Достопримечательность, Город>
-- sql
select Sights.Name, Cities.Name
from Sights join Cities on Sights.CityID = Cities.CityID;

-- реляционная алгебра
(Sights join Cities)[Sights[Name], Cities[Name]]

-- исчисления кортежей
range of S is Sights
range of C is Cities
(S.Name, C.Name) S where exists C (S.CityID = C.CityID)


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
(T.ID, T.FirstName, T.LastName, T.Age, T.CityID) T where exists C (T.CityID = C.CityID)


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
(T.FirstName, T.LastName, C.Country, ST.Date) (S where exists C (S.CityID = C.CityID and exists ST (S.SightID = ST.SightID and exists T (ST.TouristID = T.ID))))


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
(S.Name) (S where exists ST (S.CityID = ST.CityID and exists T (ST.TouristID = T.ID)))


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

select Tourists.FirstName
from (
    (
        select Cities.Country, Sights.Id, ST.SightId as siid, ST.TouristID as tiid
        from (Sights join ST on Sights.ID = ST.SightID
              join Cities on Sights.CityID = Cities.CityID)
        where ST.Date between '05-01-2016' and '07-08-2021'
    ) as weCan join ((
            select *
            from Tourists join Cities on Tourists.CityID = Cities.CityID
        ) as weCant)
    on (Tourists.ID = ST.TouristID)
)
where weCant.Country <> weCan.Country;