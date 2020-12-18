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
def f1():
    request = 'select player_name, team, player_country from players where players.id = 100'
    cursor.execute(request)
    result = cursor.fetchall()[0]
    print('Name: ' + result[0] + ', team id: ' + str(result[1]) + ', country: ' + result[2])


# 2.Выполнить запрос с несколькими соединениями (JOIN)
# select players.player_name, teams.team_name, management.general_director from players join teams on players.team = teams.id join management on teams.management = management.id where players.id = 100;
def f2():
    request = 'select players.player_name, teams.team_name, management.general_director\
        from players join teams on players.team = teams.id\
        join management on teams.management = management.id\
        where players.id = 100'
    cursor.execute(request)
    result = cursor.fetchall()[0]
    print('Name: ' + result[0] + ', team: ' + result[1] + ', general director: ' + result[2])

# 3. Выполнить запрос с ОТВ(CTE) и оконными функциями
def f3():
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
def f4():
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
def f5():
    request = 'select * from skalar_func()'
    cursor.execute(request)
    result = cursor.fetchall()[0][0]
    print('Result: ', result)

# 6. Вызвать многооператорную или табличную функцию
# select * from get_players(219);
def f6():
    request = 'select * from get_players(219)'
    cursor.execute(request)
    for row in cursor:
        print('Id: ' + str(row[0]) + ', team: ' + str(row[1]) + ', name: ', row[2] + ', position: ' + str(row[3])\
            + ', height: ' + str(row[4]) + ', weight: ' + str(row[5]) + ', number: ' + str(row[6]) + ', age: '\
            + str(row[7]) + ', country: ' + row[8])

# 7. Вызвать хранимую процедуру
#Вызвать хранимую процедуру (написанную в третьей лабораторной работе)
def f7():
    request = "call get_trigger_and_func(cast('draft' as name));"
    cursor.execute(request)
    print(conn.notices[-1])

# 8. Вызвать системную функцию или процедуру
def f8():
    request = 'select version()'
    cursor.execute(request)
    print(cursor.fetchall()[0][0])

# 9. Создатьтаблицувбазеданных, соответствующую тематике БД
def f9():
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


def f10(id=101, last_id=2, new_id=3):
    request = f'''
    insert into drafts(player_id, last_team_id, new_team_id)
    values({id}, {last_id}, {new_id})
    '''
    cursor.execute(request)
    conn.commit()

menu = '''0 - Выход
1. Скалярный запрос
2. Запрос с несколькими соединениями
3. Запрос с ОТВ(CTE) и оконными функциями
4. Запрос к метаданным
5. Скалярная функция
6. Многооператорная функция
7. Хранимая процедура
8. Системная функция
9. Создать таблицу
10. Вставить в таблицу
'''
print(menu)
choice = 1

while choice != 0:
    choice = int(input('Выбор:'))
    if choice == 1:
        f1()
    elif choice == 2:
        f2()
    elif choice == 3:
        f3()
    elif choice == 4:
        f4()
    elif choice == 5:
        f5()
    elif choice == 6:
        f6()
    elif choice == 7:
        f7()
    elif choice == 8:
        f8()
    elif choice == 9:
        f9()
    elif choice == 10:
        f10()


cursor.close()
conn.close()