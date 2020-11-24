-- переделать, чтобы логировал изменения команды
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
set team = 24
where id = 2421;
select * from drafts;
