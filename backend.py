from sqlalchemy import * 

class Backend:
    def __init__(self):
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
        query = 'select player_id, first_name, last_name from player;'
        results = self.conn.execute(query)
        result_list = []
        for r in results:
            result_list.append((r[0],r[1],r[2]))
        
        return result_list
    
    #def get_events(self,date,team,player,league,oddsmakers):
    #    where = ""
    #    if date is not None:
    #        where += " event_date = " + date + " and "
    #    if team is not None:
    #        where += " event_date = " + date + " and "
              
        
