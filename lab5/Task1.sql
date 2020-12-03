-- Из таблиц базы данных, созданной в первой лабораторной работе, 
-- извлечьданныев XML (MSSQL) или JSON(Oracle, Postgres). Для выгрузки 
-- в XML проверить все режимы конструкции FOR XML

select to_json(teams) from teams; 
select to_json(players) from players;
select to_json(management) from management;
select to_json(headquarters) from headquarters; 

