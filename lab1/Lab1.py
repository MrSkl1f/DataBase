from mimesis import Person, Address
from mimesis.enums import Gender
from random import randint, randrange, choice
import urllib.request, urllib.parse, urllib.error
import json

def generateClubManagement():
    f = open("ClubManagement.csv", "w")
    person = Person("en")
        
    for curId in range(1000):
        generalDirector = person.full_name()
        generalManager  = person.full_name()
        sportsDirector  = person.full_name()
        line = str(curId + 1) + "," + generalDirector + "," + generalManager + "," + sportsDirector + "\n"
        f.write(line)
    f.close()
    
def generateHeadquarters():
    f = open("Headquarters.csv", "w")
    person = Person("en")
        
    for curId in range(1000):
        headCoach = person.full_name()
        seniorCoach  = person.full_name()
        goalkeepingCoach  = person.full_name()
        line = str(curId + 1) + "," + headCoach + "," + seniorCoach + "," + goalkeepingCoach + "\n"
        f.write(line)
    f.close()    

def fillTeamFK(team):
    MAX_N = 1000
    arrOfIds = list()
    for i in range(MAX_N):
        arrOfIds.append(i + 1)
    for i in range(MAX_N):
        randNum = choice(arrOfIds)
        arrOfIds.remove(randNum)
        team[i].append(randNum)

def checkData(data):
    if  data['strTeam'] != '' and data['strTeam'] != None and\
        data['strCountry'] != '' and data['strCountry'] != None and data['strCountry'] != 'International' and\
        data['strStadium'] != '' and data['strStadium'] != None:
            return True
    return False

def createTeam():
    MAX_N = 1000
    url = 'https://www.thesportsdb.com/api/v1/json/1/all_leagues.php'
    data = urllib.request.urlopen(url).read().decode()
    data = json.loads(data)

    sumAll = sum([1 for item in data['leagues']])
    team = []
    check = 0
    for i in range(sumAll):
        if data['leagues'][i]['strSport'] == 'Soccer':
            url2 = 'https://www.thesportsdb.com/api/v1/json/1/lookup_all_teams.php?id=' + str(data['leagues'][i]['idLeague'])
            data2 = urllib.request.urlopen(url2).read().decode()
            data2 = json.loads(data2)
            if data2['teams'] != None:
                arr = [1 for item in data2['teams']]
                sumAll2 = sum(arr)
                for j in range(sumAll2):
                    if (len(team) < MAX_N):
                        if checkData(data2['teams'][j]):
                            country = data2['teams'][j]['strCountry'].split('\t')
                            team.append([data2['teams'][j]['strTeam'], data2['teams'][j]['strStadium'], country[0]])
                    else:
                        check = 1
                        break
        if check:
            break
    fillTeamFK(team)
    fillTeamFK(team)
    f = open("Team.csv", "w", encoding='utf-8')
    for i in range(MAX_N):
        teamID          = str(i + 1)
        managementID    = str(team[i][3])
        headquarters    = str(team[i][4])
        teamName        = team[i][0]
        country         = team[i][2]
        stadium         = team[i][1]
        print(team[i])
        line = teamID + ',' + managementID + ',' +\
                headquarters + ',' + teamName + ',' +\
                country + ',' + stadium + '\n'
        f.write(line)
    f.close()


def createPlayers():
    person = Person("en")
    adress = Address("en")
    players = []
    MAX_N = 1000
    arrOfIds = [i + 1 for i in range(MAX_N)]
    for i in range(MAX_N):
        positions = ['A', 'A', 'M', 'M', 'M', 'M', 'D', 'D', 'D', 'D', 'G']
        numbers   = [k for k in range(1, 99, 1)]
        curTeamID = choice(arrOfIds)
        arrOfIds.remove(curTeamID)
        for _ in range(len(positions)):
            curID       = str(len(players) + 1)
            teamID      = str(curTeamID)
            name        = person.full_name()
            position    = choice(positions)
            height      = str(randint(150, 220)) 
            weight      = str(person.weight()) 
            number      = str(choice(numbers))
            age         = str(person.age()) 
            country     = adress.country(allow_random=True)
            positions.remove(position)
            numbers.remove(int(number))
            players.append([curID, teamID, name, position, height, weight, number, age, country])
    f = open("Players.csv", "w", encoding='utf-8')
    for player in players:
        line = player[0] + ',' + player[1] + ',' + player[2] + ',' +\
               player[3] + ',' + player[4] + ',' + player[5] + ',' +\
               player[6] + ',' + player[7] + ',' + player[8] + '\n'
        f.write(line)
    f.close()   
                     
             
#generateClubManagement()
#generateHeadquarters()
#createTeam()
createPlayers()