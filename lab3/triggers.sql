--  2 DML триггера
-- 1) after
-- 2) instead of 

-- after
-- //DONE под свои данные
drop table if exists drafts;
create table if not exists drafts
(
	id serial not null,
	player_id int,
	last_team_id int,
	new_team_id int
);

create or replace function team_change()
returns trigger
language plpgsql
as $$
begin 
	if old.team <> new.team then
		insert into drafts(player_id, last_team_id, new_team_id)
		values (new.id, old.team, new.team);
	end if;
	return new;
end;
$$;

create trigger draft
after update on players
for each row
execute function team_change();

update players 
set team = 22
where id = 500;
select * from drafts;

-- instead of 
create view teams_view as
select *
from teams;

create or replace function update_player()
returns trigger 
language plpgsql
as 	$$
begin
	update teams
	set country = 'Canada'
	where id = old.id ;
	return old;
end;
$$;

create trigger delete_player
	instead of delete on teams_view
	for each row 
	execute procedure update_player();
	
delete
from teams_view
where id = 1;

select *
from teams_view
where id = 1;
