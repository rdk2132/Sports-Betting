DROP TABLE IF EXISTS player_participation;
DROP TABLE IF EXISTS team_participation;
DROP TABLE IF EXISTS league_membership;
DROP TABLE IF EXISTS plays_on;
DROP TABLE IF EXISTS betting_odds;
DROP TABLE IF EXISTS sporting_event;
DROP TABLE IF EXISTS betting_website;
DROP TABLE IF EXISTS league;
DROP TABLE IF EXISTS team;
DROP TABLE IF EXISTS player;




CREATE TABLE IF NOT EXISTS player(
   player_id  INT PRIMARY KEY,
   first_name  CHAR(50) NOT NULL,
   last_name  CHAR(50) NOT NULL,
   position  CHAR(30),
   age  INT,
   salary INT,
   gender CHAR(1),
   dob date
);


CREATE TABLE IF NOT EXISTS team(
   team_name  CHAR(50) PRIMARY KEY,
   location  CHAR(50) NOT NULL,
   current_season  CHAR(50),
   current_season_win_record  INT,
   current_season_loss_record INT,
   coach CHAR(50)
);

CREATE TABLE IF NOT EXISTS league(
   league_name  CHAR(50) PRIMARY KEY,
   location  CHAR(50) NOT NULL,
   commisioner  CHAR(50),
   current_season_start  date,
   current_season_end date
);

CREATE TABLE IF NOT EXISTS betting_website(
   url  CHAR(500) PRIMARY KEY,
   name  CHAR(100) NOT NULL,
   year_founded  CHAR(4),
   betting_volume_per_month  int
);

CREATE TABLE IF NOT EXISTS sporting_event(
	event_id INT PRIMARY KEY,
	event_name CHAR(50),
	event_date date,
	event_type CHAR(50),
	location CHAR(50),
	winner CHAR(50),
    team_1 CHAR(50),
    team_2 CHAR(50),
	league_name CHAR(50),
	FOREIGN KEY (league_name) references league(league_name),
	FOREIGN KEY (winner) references team(team_name),
	FOREIGN KEY (team_1) references team(team_name),
	FOREIGN KEY (team_2) references team(team_name)

);

CREATE TABLE IF NOT EXISTS betting_odds(
	bet_id INT PRIMARY KEY,
	odds_team_1_wins int NOT NULL,
	event_id INT,
	url CHAR(500) NOT NULL,
	FOREIGN KEY (event_id) references sporting_event(event_id),
	FOREIGN KEY (url) references betting_website(url)	
);


CREATE TABLE IF NOT EXISTS plays_on(
	player_id INT NOT NULL,
	team_name CHAR(50) NOT NULL,
	FOREIGN KEY (player_id) references player(player_id),
	FOREIGN KEY (team_name) references team(team_name),
	PRIMARY KEY(player_id, team_name)
);

CREATE TABLE IF NOT EXISTS league_membership(
	league_name CHAR(50) NOT NULL,
	team_name CHAR(50) NOT NULL,
	FOREIGN KEY (league_name) references league(league_name),
	FOREIGN KEY (team_name) references team(team_name),
	PRIMARY KEY(league_name, team_name)
);


CREATE TABLE IF NOT EXISTS team_participation(
	event_id INT NOT NULL,
	team_name CHAR(50) NOT NULL,
	FOREIGN KEY (event_id) references sporting_event(event_id),
	FOREIGN KEY (team_name) references team(team_name),
	PRIMARY KEY(event_id, team_name)
);

CREATE TABLE  IF NOT EXISTS player_participation(
	event_id INT NOT NULL,
	player_id INT NOT NULL,
	FOREIGN KEY (event_id) references sporting_event(event_id),
	FOREIGN KEY (player_id) references player(player_id),
	PRIMARY KEY(event_id, player_id)
);

INSERT INTO league(league_name, location, commisioner, current_season_start, current_season_end) 
VALUES ('NFL', 'United States', 'Roger Goodell', '2022-08-31', '2023-02-15'),
	('NCAA BASKETBALL', 'United States', 'Mark Emmert', '2021-11-09', '2022-04-05'),
	('NCAA FOOTBALL', 'United States', 'Mark Emmert', '2022-08-30', '2023-01-20'),
	('MLS', 'United States', 'Don Garber', '2021-05-12', '2022-02-14'),
	('EPL', 'England', 'Richard Masters', '2021-05-12', '2022-02-14'), 
	('NHL', 'United States and Canada', 'Avery Thomas', '2022-10-20', '2022-05-18'),
	('KHL', 'Russia', 'Avery Thomas', '2021-01-03', '2022-04-09'), 
	('NBA', 'United States', 'Adam Silver', '2022-10-20', '2022-06-10'), 
	('MLB', 'United States', 'Rob Manfred', '2022-03-31', '2022-11-05'), 
	('XFL', 'United States', 'Jamie Berg', '2021-04-08', '2022-01-05');

INSERT INTO player (player_id, first_name, last_name, position, age, salary, gender, dob) 
VALUES
    (1, 'Jacob', 'DeGrom', 'Pitcher', 31, 25000000, 'M','1990-06-10'),
    (2, 'Francisco', 'Lindor', 'Shortstop' ,28, 34000000, 'M','1993-09-10'),
    (3, 'Max', 'Scherzer', 'Pitcher' ,35, 223000, 'M','1996-05-12'),
    (4, 'Ronald', 'Acuna', 'Outfielder' , 22, 223000, 'M','1997-12-18'),
    (5, 'Ozzie',  'Albies', 'Second Base' ,24, 223000, 'M','1992-02-23'),
    (6, 'Aaron', 'Judge', 'Outfielder' ,25, 20000000, 'M','1999-02-01'),
    (7, 'Gerrit', 'Cole', 'Pitcher' ,28, 35000000, 'M','1996-01-12'),
    (8, 'Pete', 'Alonso', 'First Base' ,26, 5000000, 'M','1988-05-12'),
    (9, 'Gleyber', 'Torres', 'Second Base', 23, 700000, 'M','2004-12-20'),
    (10, 'Brandon', 'Nimmo', 'Outfielder' ,28, 4100000, 'M','1996-07-07');

INSERT INTO team (team_name, location, current_season, current_season_win_record, current_season_loss_record, coach) VALUES
	('Yankees', 'New York City', '2022', 0, 0, 'Aaron Boone'),
	('Mets', 'New York City', '2022', 0, 0, 'Buck Showalter'),
	('Angels', 'Los Angelos', '2022', 0, 0, 'Joe Madden'),
	('Braves', 'Atlanta', '2022', 0, 0, 'Brian Snitker'),
	('Cubs', 'Chicago', '2022', 0, 0, 'David Ross'),
	('Phillies', 'Philadelphia', '2022', 0, 0, 'Joe Girardi'),
	('Marlins', 'Miami', '2022', 0, 0, 'Don Mattingly'),
	('Nationals', 'Washington', '2022', 0, 0, 'Dave Martinez'),
	('Dodgers', 'Los Angeles', '2022', 0, 0, 'Dave Roberts'),
	('Red Sox', 'Boston', '2022', 0, 0, 'Alex Cora');

INSERT INTO betting_website (url,name,year_founded,betting_volume_per_month) VALUES
	('https://fivethirtyeight.com/','FiveThirtyEight','2006', 500000),
	('https://www.caesars.com/sportsbook-and-casino','Caesars Sportsbook','2021', 10000000),
	('https://sportsbook.fanduel.com/','Fanduel Sportsbook','2009', 100000000),
	('https://sports.ny.betmgm.com/en/sports','BETMGM','2018', 100000000),
	('https://sportsbook.draftkings.com/sportsbook','Draftkings Sportsbook','2012', 100000000),
	('https://www.barstoolsportsbook.com/', 'Barstool Sportsbook', '2020', 5000000),
	('https://www.oddsshark.com/', 'OddsShark', '2004', 120000);


INSERT INTO sporting_event (event_id, event_name, event_date, event_type, location, winner, league_name, team_1,team_2) VALUES
	(1000001, 'Yankees Vs. Mets', '2022-02-04', 'baseball', 'Flushing, NY', 'Yankees', 'MLB','Yankees','Mets'),
	(1000002, 'Angels Vs. Mets', '2022-03-02', 'baseball', 'Flushing, NY', 'Mets', 'MLB','Angels','Mets'),
	(1000003, 'Yankees Vs. Angels', '2022-03-21', 'baseball', 'Anaheim, CA', 'Yankees', 'MLB','Yankees','Angels'),
	(1000004, 'Nationals Vs. Mets', '2022-03-22', 'baseball', 'Flushing, NY', 'Mets', 'MLB','Nationals','Mets'),
	(1000005, 'Yankees Vs. Nationals', '2022-04-11', 'baseball', 'Washington D.C.', 'Nationals', 'MLB','Yankees','Nationals'),
	(1000006, 'Dodgers Vs. Phillies', '2022-05-29', 'baseball', 'New York City', 'Phillies', 'MLB','Dodgers','Phillies'),
	(1000007, 'Red Sox Vs. Dodgers', '2022-05-28', 'baseball', 'Los Angeles, CA', 'Dodgers', 'MLB','Red Sox','Dodgers'),
	(1000008, 'Phillies Vs. Red Sox', '2022-06-21', 'baseball', 'Boston, MA', 'Red Sox', 'MLB','Phillies','Red Sox'),
	(1000009, 'Yankees Vs. Red Sox', '2022-07-12', 'baseball', 'Boston MA', 'Yankees', 'MLB','Yankees','Red Sox'),
	(1000010, 'Braves Vs. Red Sox', '2022-07-14', 'baseball', 'Boston, MA', 'Red Sox', 'MLB','Braves','Red Sox'),
	(1000011, 'Yankees Vs. Braves', '2022-08-12', 'baseball', 'Atlanta, GA', 'Yankees', 'MLB','Yankees','Braves'),
	(1000012, 'Yankees Vs. Red Sox', '2022-08-12', 'baseball', 'Boston, MA', 'Yankees', 'MLB','Yankees','Red Sox'),
	(1000013, 'Braves Vs. Cubs', '2022-09-18', 'baseball', 'Chicago, IL', 'Yankees', 'MLB','Braves','Cubs'),
	(1000014, 'Cubs Vs. Red Sox', '2022-09-04', 'baseball', 'Boston, MA', 'Red Sox', 'MLB','Cubs','Red Sox');

	
INSERT INTO team_participation (event_id, team_name) VALUES
	(1000001, 'Yankees'),
	(1000001, 'Mets'),
	(1000002, 'Angels'),
	(1000002, 'Mets'),
	(1000003, 'Yankees'),
	(1000003, 'Angels'),
	(1000004, 'Nationals'),
	(1000004, 'Mets'),
	(1000005, 'Yankees'),
	(1000005, 'Nationals'),
	(1000006, 'Dodgers'),
	(1000006, 'Phillies'),
	(1000007, 'Red Sox'),
	(1000007, 'Dodgers'),
	(1000008, 'Phillies'),
	(1000008, 'Red Sox'),
	(1000009, 'Yankees'),
	(1000009, 'Red Sox'),
	(1000010, 'Braves'),
	(1000010, 'Red Sox'),
	(1000011, 'Yankees'),
	(1000011, 'Braves'),
	(1000012, 'Yankees'),
	(1000012, 'Red Sox'),
	(1000013, 'Braves'),
	(1000013, 'Cubs'),
	(1000014, 'Cubs'),
	(1000014, 'Red Sox');

INSERT INTO player_participation (player_id,event_id) VALUES		
	(1, 1000001),
	(2, 1000001),
	(3, 1000001),
	(4, 1000011),
	(5, 1000011),
	(6, 1000012),
	(7, 1000012),
	(8, 1000001),
	(9, 1000012),
	(10, 1000001),
	(1, 1000004),
	(1, 1000002),
	(2, 1000004),
	(4, 1000013);


INSERT INTO league_membership (league_name, team_name) VALUES
	('MLB', 'Mets'),
	('MLB', 'Yankees'),
	('MLB', 'Red Sox'),
	('MLB', 'Angels'),
	('MLB', 'Marlins'),
	('MLB', 'Nationals'),
	('MLB', 'Dodgers'),
	('MLB', 'Phillies'),
	('MLB', 'Cubs'),
	('MLB', 'Braves');



INSERT INTO plays_on (player_id, team_name) VALUES
	(1, 'Mets'),
	(2, 'Mets'),
	(3, 'Mets'),
	(4, 'Braves'),
	(5, 'Braves'),
	(6, 'Yankees'),
	(7, 'Yankees'),
	(8, 'Mets'),
	(9, 'Yankees'),
	(10, 'Mets');




INSERT INTO betting_odds (bet_id,odds_team_1_wins,event_id, url) VALUES
	(001,70,1000001,'https://fivethirtyeight.com/'),
	(002,60,1000001, 'https://sports.ny.betmgm.com/en/sports'),
	(003,20,1000002, 'https://fivethirtyeight.com/'),
	(004,34,1000002, 'https://sports.ny.betmgm.com/en/sports'),
	(005,77,1000003, 'https://www.caesars.com/sportsbook-and-casino'),
	(006,89,1000003, 'https://sportsbook.draftkings.com/sportsbook'), 
	(007,23,1000004, 'https://www.barstoolsportsbook.com/'),
	(008,10,1000004, 'https://sportsbook.fanduel.com/'),
	(009,5,1000005, 'https://sportsbook.fanduel.com/'),
	(010,2,1000005, 'https://sportsbook.draftkings.com/sportsbook');








