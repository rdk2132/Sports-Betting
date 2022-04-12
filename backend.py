from sqlalchemy import * 
import statistics
class Backend:
    def __init__(self):
        #self.engine = create_engine('postgresql://'+"postgres"+':'+'pass'+'@localhost:5432/test')

        self.engine = create_engine("postgresql://rdk2132:password@35.211.155.104/proj1part2")
        self.conn = self.engine.connect()

    def get_team_names(self):
        query = 'select team_name from team;'
        results = self.conn.execute(query)
        result_list = []
        for r in results:
            result_list.append(r[0])
        
        return result_list

    def get_league_names(self):
        query = 'select league_name from league;'
        results = self.conn.execute(query)
        result_list = []
        for r in results:
            result_list.append(r[0])
        
        return result_list
     
    def get_odds_makers(self):
        query = 'select name, url from betting_website;'
        results = self.conn.execute(query)
        result_list = []
        for r in results:
            result_list.append((r[0],r[1]))
        
        return result_list

    def get_players(self):
        query = 'select first_name, last_name from player;'
        results = self.conn.execute(query)
        result_list = []
        for r in results:
            result_list.append((r[0] + " " + r[1]))
        
        return result_list
    
    def query(self,q):
        results =  self.conn.execute(q)
        result_list = []
        for r in results:
            inner_list = []
            for i in r:
                inner_list.append(i)
            result_list.append(inner_list)
        return result_list 
        
    def get_events(self,date,team,first_name,last_name,league):
        if first_name is None and last_name is None:
            where = "True "
            if date is not None:
                where += " AND event_date = '" + date +"' " 
            if team is not None:
                where += " AND (team_1 = '" + team + "' OR team_2 = '" + team + "') "
            if league is not None:
                where += " AND league_name = '" + league + "' "
            query = "SELECT event_id,event_name, event_date from sporting_event where "+where+";"
            
            results = self.conn.execute(query)
            result_list = []
            for r in results:
                result_list.append([r[0],r[1],r[2]])
            
            return result_list
        else:
            where = "True"
            if last_name is not None:
                where += " AND last_name = '" + last_name + "' "
            if first_name is not None:
                where += " AND first_name = '" + first_name + "' "  
            if date is not None:
                where += " AND event_date = '" + date +"' " 
            if team is not None:
                where += " AND (team_1 = '" + team + "' OR team_2 = '" + team + "') "
            if league is not None:
                where += " AND league_name = '" + league + "' "
            query = "select event_id_a as event_id ,event_name, event_date from (select * from (select *, event_id as event_id_a from player_participation join player on player_participation.player_id = player.player_id) as merged join sporting_event on sporting_event.event_id = merged.event_id) as output_table where " +where+ ";"
            
            results = self.conn.execute(query)
            result_list = []
            for r in results:
                result_list.append([r[0],r[1],r[2]])
            
            return result_list            
    
    def get_team_info(self,team_name):         
        query = "select team_name, location, current_season, current_season_win_record, current_season_loss_record, coach, blurb from team where team_name ='"+team_name+"';"
        results = self.conn.execute(query)
        result_list = []
        for r in results:
            result_list.append([r[0],r[1],r[2],r[3],r[4],r[5],r[6]])
        
        return result_list
    
    def get_player_info(self,first_name,last_name):
        query = "select first_name, last_name, position, age, salary, gender, dob, blurb from player where first_name = '"+first_name+"' and last_name = '"+last_name+"';"
        results = self.conn.execute(query)
        result_list = []
        for r in results:
            result_list.append([r[0],r[1],r[2],r[3],r[4],r[5],r[6], r[7]])
        
        return result_list        

    def get_event_info(self,event_id):
        query = "select * from sporting_event where event_id = '"+str(event_id)+"';"
        results = self.conn.execute(query)
        result_list = []
        for r in results:
            result_list.append([r[0],r[1],r[2],r[3],r[4],r[5],r[6],r[7],r[8]])
        return result_list
       
    def get_event_players(self,event_id):
       
        query = "select first_name,last_name from player_participation join player on player_participation.player_id = player.player_id where event_id = '" + str(event_id) + "';"
        results = self.conn.execute(query)
        result_list = []
        for r in results:
            result_list.append(r[0] + " " + r[1])
        return result_list
            

    def get_league_info(self,league_name):
        query = "select * from league where league_name = '"+league_name+"';"
        results = self.conn.execute(query)
        result_list = []
        for r in results:
            result_list.append([r[0],r[1],r[2],r[3],r[4],r[5]])
        
        return result_list  

    def get_odds_from_url(self, url):
        query = "select bet_id,odds_team_1_wins,event_id from betting_odds where url = '"+url+"';"
        results = self.conn.execute(query)
        result_list = []
        for r in results:
            result_list.append([r[0],r[1],r[2]])
        
        return result_list          
    
    def get_event_odds(self,event_id):
        query = "select bet_id,odds_team_1_wins,event_id, betting_odds.url, name,year_founded,betting_volume_per_month from betting_odds join betting_website on betting_odds.url = betting_website.url where event_id = '"+str(event_id)+"';"
        results = self.conn.execute(query)
        result_list = []
        for r in results:
            result_list.append([r[0],r[1],100-r[1],r[2],r[3],r[4],r[5],r[6]])
        
        return result_list  
    
    def get_historical_accuracy(self,event_ids, url):
        winner_dict = {}
        
        for event_id in event_ids:
            event_info = self.get_event_info(event_id)[0]
            winner = event_info[5]
            team_1 = event_info[6]
            game_result = 0
            if winner== team_1:
                game_result = 1
            winner_dict[event_id] = game_result
        
        results = self.get_odds_from_url(url)
        errors = []
        for line in results:
            event_id = line[2]
            odds_team_1_wins = line[1]
            if event_id in winner_dict:
                error = abs(winner_dict[event_id] - odds_team_1_wins)
                errors.append(error)
        if len(errors) == 0:
            return 0
        return statistics.mean(errors)
        
    def get_historical_accuracy_all_urls(self,event_ids):
        if len(event_ids) == 0:
            return [[]]
        odds_makers = self.get_odds_makers()
        url_list = []
        names = []
        for line in odds_makers:
            url_list.append(line[1])
            names.append(line[0])
    
        results = []
        for i in range(len(url_list)):
            name = names[i]
            acc = self.get_historical_accuracy(event_ids,url_list[i])
            acc = round(acc,3)
            if acc == 0:
                continue
            results.append([name,acc])  
        return results
    
#b = Backend()
#r = b.get_historical_accuracy_all_urls([1000001,1000002,1000003,1000004,1000005,1000006,1000007,1000008,1000009])
#print(r)
#r = b.get_historical_accuracy([1000001,1000002],'https://fivethirtyeight.com/')
#print(r)
#r = b.get_historical_accuracy([1000003,1000004],'https://fivethirtyeight.com/')
#print(r)
#r = b.get_historical_accuracy([1000003,1000005],'https://sportsbook.draftkings.com/sportsbook')
#print(r)
#r=b.get_event_odds(1000001)
#r = b.get_events('2022-02-04',"Mets","Jacob","DeGrom","MLB")
#for i in r:
#    print(i)
    
    