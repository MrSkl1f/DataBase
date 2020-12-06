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


# 4. 

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





cursor.close()
conn.close()