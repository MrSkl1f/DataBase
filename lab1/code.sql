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

COPY players FROM 'C:\Users\MrSklif\Desktop\BMSTU\5sem\DB\lab1\Players.csv' DELIMITER ',' csv;
SELECT * FROM players;