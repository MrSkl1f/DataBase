--CREATE DATABASE basketball
--\c football

CREATE TABLE IF NOT EXISTS management (
    id INT NOT NULL PRIMARY KEY,
    general_director VARCHAR(40) NOT NULL,
    general_manager VARCHAR(40),
    sports_director varchar(40) 
);
COPY management FROM '/home/mrskl1f/Рабочий стол/BMSTU/DataBase/lab1/ClubManagement.csv' DELIMITER ',' csv;
SELECT * FROM management;

CREATE TABLE IF NOT EXISTS headquarters (
    id INT NOT NULL PRIMARY KEY,
    head_coach VARCHAR(40) NOT NULL,
    senior_coach VARCHAR(40)
);

COPY headquarters FROM '/home/mrskl1f/Рабочий стол/BMSTU/DataBase/lab1/Headquarters.csv' DELIMITER ',' csv;
SELECT * FROM headquarters;

CREATE TABLE IF NOT EXISTS teams (
    id INT NOT NULL PRIMARY KEY,
    management INT REFERENCES management(id),
    headquarter INT REFERENCES headquarters(id),
    team_name VARCHAR(50) NOT NULL,
    country VARCHAR(40),
    stadium VARCHAR(50)
);

COPY teams FROM '/home/mrskl1f/Рабочий стол/BMSTU/DataBase/lab1/Team.csv' DELIMITER ',' csv;
SELECT * FROM teams;

CREATE TABLE IF NOT EXISTS players (
    id INT NOT NULL PRIMARY KEY,
    team INT REFERENCES teams(id),
    player_name VARCHAR(40) NOT NULL,
    player_position INT CHECK (player_position > 0 AND player_position < 6),
    player_height INT CHECK (player_height >= 150 AND player_height <= 220),
    player_weight INT CHECK (player_weight >= 38 AND player_weight <= 90), 
    player_number INT CHECK (player_number >= 1 AND player_number <= 99),
    player_age INT CHECK (player_age >= 16 AND player_age <= 66),
    player_country VARCHAR(40)
);

--alter table players add constraint players_age check (not null);
--insert into club_management(management_id, general_manager, sports_director) values('asf', 'asf', 'afs);

COPY players FROM '/home/mrskl1f/Рабочий стол/BMSTU/DataBase/lab1/Players.csv' DELIMITER ',' csv;
SELECT * FROM players;
-- селектом все ограничения


--SELECT con.conname "constraint",
--       concat(nsp.nspname, '.', rel.relname) "table",
--       (SELECT array_agg(att.attname)
--               FROM pg_attribute att
--                    INNER JOIN unnest(con.conkey) unnest(conkey)
--                               ON unnest.conkey = att.attnum
--               WHERE att.attrelid = con.conrelid) "columns"
--       FROM pg_constraint con
--            INNER JOIN pg_class rel
--                       ON rel.oid = con.conrelid
--            INNER JOIN pg_namespace nsp
--                       ON nsp.oid = rel.relnamespace;