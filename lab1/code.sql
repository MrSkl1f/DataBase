--CREATE DATABASE football
--\c football

CREATE TABLE IF NOT EXISTS club_management (
    management_id INT NOT NULL PRIMARY KEY,
    general_director VARCHAR(40) NOT NULL,
    general_manager VARCHAR(40) NOT NULL,
    sports_director varchar(40) NOT NULL
);

COPY club_management FROM 'C:\Users\MrSklif\Desktop\BMSTU\5sem\DB\lab1\ClubManagement.csv' DELIMITER ',' csv;
SELECT * FROM club_management;

CREATE TABLE IF NOT EXISTS headquarters (
    headquarters_id INT NOT NULL PRIMARY KEY,
    head_coach VARCHAR(40) NOT NULL,
    senior_coach VARCHAR(40) NOT NULL,
    goalkeeping_coach VARCHAR(40) NOT NULL
);

COPY headquarters FROM 'C:\Users\MrSklif\Desktop\BMSTU\5sem\DB\lab1\Headquarters.csv' DELIMITER ',' csv;
SELECT * FROM headquarters;

CREATE TABLE IF NOT EXISTS teams (
    team_id INT NOT NULL PRIMARY KEY,
    management INT REFERENCES club_management(management_id),
    headquarter INT REFERENCES headquarters(headquarters_id),
    team_name VARCHAR(50) NOT NULL,
    country VARCHAR(40) NOT NULL,
    stadium VARCHAR(50) NOT NULL
);

COPY teams FROM 'C:\Users\MrSklif\Desktop\BMSTU\5sem\DB\lab1\Team.csv' DELIMITER ',' csv;
SELECT * FROM teams;

CREATE TABLE IF NOT EXISTS players (
    player_id INT NOT NULL PRIMARY KEY,
    team INT REFERENCES teams(team_id),
    player_name VARCHAR(40) NOT NULL,
    player_position VARCHAR(1) NOT NULL,
    player_height int check (player_height >= 150 AND player_height <= 220) NOT NULL,
    player_weight INT CHECK (player_weight >= 38 AND player_weight <= 90) NOT NULL, 
    player_number INT CHECK (player_number >= 1 AND player_number <= 99) NOT NULL,
    player_age INT CHECK (player_age >= 16 AND player_age <= 66) NOT NULL,
    player_country VARCHAR(40) NOT NULL
);

--alter table players add constraint players_age check (not null);
--insert into club_management(management_id, general_manager, sports_director) values('asf', 'asf', 'afs);

COPY players FROM 'C:\Users\MrSklif\Desktop\BMSTU\5sem\DB\lab1\Players.csv' DELIMITER ',' csv;
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