import psycopg2
conn = psycopg2.connect(
    dbname='basketball',
    user='postgres',
    password='1337',
    host='localhost'
)
cursor = conn.cursor()

# 1. Выполнить скалярный запрос
# select player_name, team, player_country from players where players.id = 100;
def ScalarRequest():
    request = 'select player_name, team, player_country from players where players.id = 100'
    cursor.execute(request)
    result = cursor.fetchall()[0]
    print('Name: ' + result[0] + ', team id: ' + str(result[1]) + ', country: ' + result[2])


# 2.Выполнить запрос с несколькими соединениями (JOIN)
# select players.player_name, teams.team_name, management.general_director from players join teams on players.team = teams.id join management on teams.management = management.id where players.id = 100;
def RequestWithJoin():
    request = 'select players.player_name, teams.team_name, management.general_director\
        from players join teams on players.team = teams.id\
        join management on teams.management = management.id\
        where players.id = 100'
    cursor.execute(request)
    result = cursor.fetchall()[0]
    print('Name: ' + result[0] + ', team: ' + result[1] + ', general director: ' + result[2])

# 3. Выполнить запрос с ОТВ(CTE) и оконными функциями
def Request3():
    request = '''
        select cur.player_country as "country", avg(cur.player_height) over (partition by player_country) as "height"
        from (
            select player_country, player_height  
            from players
            where player_country = 'Canada'
        ) as cur
        union
        select cur.player_country as "country", avg(cur.player_height) over (partition by player_country) as "height"
        from (
            select player_country, player_height  
            from players
            where player_country = 'United States'
        ) as cur;
    '''
    cursor.execute(request)
    for row in cursor:
        print('Country: ' + row[0] + ', average height: ' + str(row[1]))

# 4. Выполнить запрос к метаданным;
def RequestToMetaData():
    request = '''
    select pp.proname 
    from pg_catalog.pg_proc pp
    where pp."oid" = (
        select pt.tgfoid
        from pg_catalog.pg_trigger pt 
        where pt.tgname = 'draft'
    );
    '''
    cursor.execute(request)
    print(cursor.fetchall()[0][0])
    
# 5. Вызвать скалярную функцию
# select * from skalar_func();
def ScalarFunc():
    request = 'select * from skalar_func()'
    cursor.execute(request)
    result = cursor.fetchall()[0][0]
    print('Result: ', result)

# 6. Вызвать многооператорную или табличную функцию
# select * from get_players(219);
def TableFunc():
    request = 'select * from get_players(219)'
    cursor.execute(request)
    for row in cursor:
        print('Id: ' + str(row[0]) + ', team: ' + str(row[1]) + ', name: ', row[2] + ', position: ' + str(row[3])\
            + ', height: ' + str(row[4]) + ', weight: ' + str(row[5]) + ', number: ' + str(row[6]) + ', age: '\
            + str(row[7]) + ', country: ' + row[8])

# 7. Вызвать хранимую процедуру
#Вызвать хранимую процедуру (написанную в третьей лабораторной работе)
def CallStoredProcedure():
    request = "call get_trigger_and_func(cast('draft' as name));"
    cursor.execute(request)
    print(conn.notices[-1])

# 8. Вызвать системную функцию или процедуру
def CallSystemFunc():
    request = 'select version()'
    cursor.execute(request)
    print(cursor.fetchall()[0][0])

# 9. Создатьтаблицувбазеданных, соответствующую тематике БД
def CreateTable():
    request = '''
    drop table if exists drafts;
    create table if not exists drafts (
        id serial not null,
        player_id int,
        last_team_id int,
        new_team_id int
    );
    '''
    cursor.execute(request)
    conn.commit()


def Insert(id, last_id, new_id):
    request = f'''
    insert into drafts(player_id, last_team_id, new_team_id)
    values({id}, {last_id}, {new_id})
    '''
    cursor.execute(request)
    conn.commit()

cursor.close()
conn.close()