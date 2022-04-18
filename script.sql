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


CREATE TYPE record AS (wins int, losses int);
CREATE TYPE season_duration AS (season_begin date, season_end date);

CREATE TABLE IF NOT EXISTS player(
   player_id  INT PRIMARY KEY,
   first_name  CHAR(50) NOT NULL,
   last_name  CHAR(50) NOT NULL,
   position  CHAR(30),
   age  INT,
   salary INT,
   gender CHAR(1),
   dob date,
   blurb TEXT
);


CREATE TABLE IF NOT EXISTS team(
   team_name  CHAR(50) PRIMARY KEY,
   location  CHAR(50) NOT NULL,
   current_season  CHAR(50),
   season_record record,
   coach CHAR(50),
   blurb TEXT
);

CREATE TABLE IF NOT EXISTS league(
   league_name  CHAR(50) PRIMARY KEY,
   location  CHAR(50) NOT NULL,
   commisioner  CHAR(50),
   duration season_duration,
   blurb TEXT
);

CREATE TABLE IF NOT EXISTS betting_website(
   url  CHAR(500) PRIMARY KEY,
   name  CHAR(100) NOT NULL,
   year_founded  CHAR(4),
   money_wagered_per_month integer[12]
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

INSERT INTO league(league_name, location, commisioner, duration, blurb) 
VALUES ('NFL', 'United States', 'Roger Goodell', ('2022-08-31', '2023-02-15'), 'The National Football League (NFL) is a professional American football league that consists of 32 teams, divided equally between the American Football Conference (AFC) and the National Football Conference (NFC). The NFL is one of the major North American professional sports leagues and the highest professional level of American football in the world.[5] Each NFL season begins with a three-week preseason in August, followed by the eighteen-week regular season which runs from early September to the end of December (or in some cases early January), with each team playing seventeen games and having one bye week. Following the conclusion of the regular season, seven teams from each conference (four division winners and three wild card teams) advance to the playoffs, a single-elimination tournament that culminates in the Super Bowl, which is contested in February and is played between the AFC and NFC conference champions. The league is headquartered in New York City.'),
	('NCAA BASKETBALL', 'United States', 'Mark Emmert', ('2021-11-09', '2022-04-05'), 'In Unites States colleges, top-tier basketball is governed by collegiate athletic bodies including National Collegiate Athletic Association (NCAA), the National Association of Intercollegiate Athletics (NAIA), the United States Collegiate Athletic Association (USCAA), the National Junior College Athletic Association (NJCAA), and the National Christian College Athletic Association (NCCAA). Each of these various organizations are subdivided into one to three divisions, based on the number and level of scholarships that may be provided to the athletes.'),
	('NCAA FOOTBALL', 'United States', 'Mark Emmert', ('2022-08-30', '2023-01-20'), 'College football is gridiron football consisting of American football played by teams of student athletes fielded by American universities, colleges, and military academies, or Canadian football played by teams of student athletes fielded by Canadian universities. It was through college football play that American football rules first gained popularity in the United States.'),
	('MLS', 'United States', 'Don Garber', ('2021-05-12', '2022-02-14'), 'Major League Soccer (MLS) is a men''s professional soccer league sanctioned by the United States Soccer Federation, which represents the sport''s highest level in the United States. The league comprises 28 teams—25 in the U.S. and 3 in Canada—and plans to expand to 30 teams by the 2023 season.'),
	('EPL', 'England', 'Richard Masters', ('2021-05-12', '2022-02-14'), 'The Premier League, also known as the English Premier League or the EPL (legal name: The Football Association Premier League Limited), is the top level of the English football league system. Contested by 20 clubs, it operates on a system of promotion and relegation with the English Football League (EFL). Seasons run from August to May with each team playing 38 matches (playing all 19 other teams both home and away). Most games are played on Saturday and Sunday afternoons.'), 
	('NHL', 'United States and Canada', 'Avery Thomas', ('2022-10-20', '2022-05-18'), 'he National Hockey League (NHL; French: Ligue nationale de hockey—LNH, French pronunciation: [liɡ nasjɔnal də ɔkɛ]) is a professional ice hockey league in North America comprising 32 teams—25 in the United States and 7 in Canada. It is considered to be the premier professional ice hockey league in the world,[4] and is one of the major professional sports leagues in the United States and Canada.'),
	('KHL', 'Russia', 'Avery Thomas', ('2021-01-03', '2022-04-09'), 'The Kontinental Hockey League is an international professional ice hockey league founded in 2008. It comprises member clubs based in Russia (19), Belarus (1), Kazakhstan (1) and China (1) for a total of 22.'), 
	('NBA', 'United States', 'Adam Silver', ('2022-10-20', '2022-06-10'), 'The National Basketball Association (NBA) is a professional basketball league in North America. The league is composed of 30 teams (29 in the United States and 1 in Canada) and is one of the major professional sports leagues in the United States and Canada. It is the premier men''s professional basketball league in the world.'), 
	('MLB', 'United States', 'Rob Manfred', ('2022-03-31', '2022-11-05'), 'Major League Baseball (MLB) is a professional baseball organization and the oldest major professional sports league in the world.[A] As of 2022, a total of 30 teams play in Major League Baseball—15 teams in the National League (NL) and 15 in the American League (AL)—with 29 in the United States and 1 in Canada. The NL and AL were formed in 1876 and 1901, respectively. Beginning in 1903, the two leagues signed the National Agreement and cooperated but remained legally separate entities until 2000, when they merged into a single organization led by the Commissioner of Baseball.'), 
	('XFL', 'United States', 'Jamie Berg', ('2021-04-08', '2022-01-05'), 'The XFL is a professional American football league, consisting of eight teams divided equally between an East and West division. Seasons run from February to April, with each team playing a ten-game regular season, and four progressing to the playoffs to crown a season champion. The company is headquartered in Greenwich, Connecticut.');

INSERT INTO player (player_id, first_name, last_name, position, age, salary, gender, dob,blurb) 
VALUES
    (1, 'Jacob', 'DeGrom', 'Pitcher', 31, 25000000, 'M','1990-06-10','Jacob Anthony deGrom (born June 19, 1988), nicknamed ''The deGrominator'', is an American professional baseball pitcher for the New York Mets of Major League Baseball (MLB). Prior to playing professionally, deGrom attended Stetson University and played college baseball for the Stetson Hatters.'),
    (2, 'Francisco', 'Lindor', 'Shortstop' ,28, 34000000, 'M','1993-09-10', 'Francisco Miguel Lindor (born November 14, 1993), nicknamed ''Paquito'' and ''Mr. Smile'', is a Puerto Rican professional baseball shortstop for the New York Mets of Major League Baseball (MLB). He previously played for the Cleveland Indians. A right-handed thrower and switch hitter, Lindor stands 5 feet 11 inches (1.80 m) and weighs 190 pounds (86 kg).'),
    (3, 'Max', 'Scherzer', 'Pitcher' ,35, 223000, 'M','1996-05-12', 'Maxwell Martin Scherzer (born July 27, 1984) is an American professional baseball pitcher for the New York Mets of Major League Baseball (MLB). He previously played in MLB for the Arizona Diamondbacks, Detroit Tigers, Washington Nationals and Los Angeles Dodgers. A right-handed starting pitcher, Scherzer is an eight-time MLB All-Star, has won three Cy Young Awards, has pitched two no-hitters, and won the World Series with the Nationals in 2019. Known for his intensity and competitiveness during play, he is nicknamed ''Mad Max'' after the fictional character of the same name.'),
    (4, 'Ronald', 'Acuna', 'Outfielder' , 22, 223000, 'M','1997-12-18', 'Ronald José Acuña Blanco Jr. (born December 18, 1997) is a Venezuelan professional baseball outfielder for the Atlanta Braves of Major League Baseball (MLB). He made his MLB debut in 2018, and won the National League Rookie of the Year Award. The next season, Acuña was named an MLB All-Star, was the NL stolen base leader, and won a Silver Slugger Award.'),
    (5, 'Ozzie',  'Albies', 'Second Base' ,24, 223000, 'M','1992-02-23', 'Ozhaino Jurdy Jiandro ''Ozzie'' Albies (born January 7, 1997) is a Curaçaoan professional baseball second baseman for the Atlanta Braves of Major League Baseball (MLB). Albies signed with the Braves organization in 2013, and made his MLB debut with the team in 2017. During his first full season, Albies was named to the 2018 Major League Baseball All-Star Game. He won the National League Silver Slugger Award for second basemen twice, in 2019 and 2021. In 2021 he won the Heart & Hustle Award.'),
    (6, 'Aaron', 'Judge', 'Outfielder' ,25, 20000000, 'M','1999-02-01', 'Aaron James Judge (born April 26, 1992) is an American professional baseball right fielder for the New York Yankees of Major League Baseball (MLB). Judge was unanimously selected as the American League (AL) Rookie of the Year in 2017 and finished second in voting for the AL Most Valuable Player Award.[1]'),
    (7, 'Gerrit', 'Cole', 'Pitcher' ,28, 35000000, 'M','1996-01-12', 'Gerrit Alan Cole (born September 8, 1990) is an American professional baseball pitcher for the New York Yankees of Major League Baseball (MLB). He previously played for the Pittsburgh Pirates and Houston Astros. Cole played for the baseball team at Orange Lutheran High School, and was selected by the Yankees in the first round of the 2008 MLB Draft. Cole opted not to sign, and instead attended the University of California, Los Angeles (UCLA), where he played college baseball for the UCLA Bruins.'),
    (8, 'Pete', 'Alonso', 'First Base' ,26, 5000000, 'M','1988-05-12', 'Peter Morgan Alonso (born December 7, 1994), nicknamed ''Polar Bear'', is an American professional baseball first baseman for the New York Mets of Major League Baseball (MLB). He made his MLB debut during the 2019 season and broke the major league record for the most home runs by a rookie with 53. He was also the first Mets player to hit 50 or more home runs in a season, setting the Mets'' single-season home run record in the process.'),
    (9, 'Gleyber', 'Torres', 'Second Base', 23, 700000, 'M','2004-12-20', 'Gleyber David Torres Castro (born December 13, 1996) is a Venezuelan professional baseball shortstop and second baseman for the New York Yankees of Major League Baseball (MLB). He made his MLB debut on April 22, 2018'),
    (10, 'Brandon', 'Nimmo', 'Outfielder' ,28, 4100000, 'M','1996-07-07', 'Brandon Tate Nimmo (born March 27, 1993) is an American professional baseball outfielder for the New York Mets of Major League Baseball (MLB). He was drafted by the Mets in the first round of the 2011 Major League Baseball draft.');

INSERT INTO team (team_name, location, current_season, season_record, coach,blurb) VALUES
	('Yankees', 'New York City', '2022', '(5, 5)', 'Aaron Boone', 'The New York Yankees are an American professional baseball team based in the New York City borough of the Bronx. The Yankees compete in Major League Baseball (MLB) as a member club of the American League (AL) East division. They are one of two major league clubs based in New York City, the other being the National League''s (NL) New York Mets. The Yankees began play in the 1901 season as the Baltimore Orioles (no relation to the modern Baltimore Orioles). In 1903, Frank Farrell and Bill Devery purchased the franchise after it ceased operations and moved it to New York City, renaming the club the New York Highlanders.[5] The Highlanders were officially renamed the New York Yankees in 1913.'),
	('Mets', 'New York City', '2022', '(7, 3)', 'Buck Showalter', 'The New York Mets are an American professional baseball team based in the New York City borough of Queens. The Mets compete in Major League Baseball (MLB) as a member of the National League (NL) East division. They are one of two major league clubs based in New York City, the other being the American League''s (AL) New York Yankees. One of baseball''s first expansion teams, the Mets were founded in 1962 to replace New York''s departed NL teams, the Brooklyn Dodgers and the New York Giants. The team''s colors evoke the blue of the Dodgers and the orange of the Giants.'),
	('Angels', 'Los Angelos', '2022', '(6, 4)', 'Joe Madden', 'The Los Angeles Angels are an American professional baseball team based in the Los Angeles metropolitan area. The Angels compete in Major League Baseball (MLB) as a member club of the American League (AL) West division. The Angels are the first MLB team to originate from the state of California; the Athletics were originally from Philadelphia (and moved to the state from Kansas City), and the Dodgers and Giants are originally from two New York City boroughs—Brooklyn and Manhattan, respectively. Since 1966, the team has played its home games at Angel Stadium in Anaheim.'),
	('Braves', 'Atlanta', '2022', '(5, 6)', 'Brian Snitker', 'The Atlanta Braves are an American professional baseball team based in the Atlanta metropolitan area. The Braves compete in Major League Baseball (MLB) as a member club of the National League (NL) East division. The team played its home games at Atlanta–Fulton County Stadium from 1966 to 1996, and at Turner Field from 1997 to 2016. Since 2017, their home stadium has been Truist Park (formerly SunTrust Park), located 10 miles (16 km) northwest of downtown Atlanta in Cumberland, Georgia. The Braves play spring training games at CoolToday Park in North Port, Florida.'),
	('Cubs', 'Chicago', '2022', '(5, 4)', 'David Ross', 'The Chicago Cubs are an American professional baseball team based in Chicago. The Cubs compete in Major League Baseball (MLB) as part of the National League (NL) Central division. They play home games at Wrigley Field, located on the city''s North Side. The Cubs are one of two major league teams based in Chicago; the other, the Chicago White Sox, is a member of the American League (AL) Central division. The Cubs, first known as the White Stockings, were a founding member of the NL in 1876, becoming the Chicago Cubs in 1903.'),
	('Phillies', 'Philadelphia', '2022', '(4, 6)', 'Joe Girardi', 'The Philadelphia Phillies are an American professional baseball team based in Philadelphia. They compete in Major League Baseball (MLB) as a member of the National League (NL) East division. Since 2004, the team''s home stadium has been Citizens Bank Park, located in South Philadelphia. The Phillies are the oldest continuous same-name, same-city franchise in American professional sports'),
	('Marlins', 'Miami', '2022', '(7, 3)', 'Don Mattingly', 'The Miami Marlins are an American professional baseball team based in Miami. The Marlins compete in Major League Baseball (MLB) as a member club of the National League (NL) East division. Their home park is LoanDepot Park.'),
	('Nationals', 'Washington', '2022', '(4, 7)', 'Dave Martinez', 'The Washington Nationals are an American professional baseball team based in Washington, D.C. The Nationals compete in Major League Baseball (MLB) as a member club of the National League (NL) East division. From 2005 to 2007, the team played in RFK Stadium while a new stadium was being built. In 2008, they moved in to Nationals Park, located on South Capitol Street in the Southeast quadrant of D.C., near the Anacostia River.'),
	('Dodgers', 'Los Angeles', '2022', '(7, 2)', 'Dave Roberts', 'The Los Angeles Dodgers are an American professional baseball team based in Los Angeles. The Dodgers compete in Major League Baseball (MLB) as a member club of the National League (NL) West division. Established in 1883 in the city of Brooklyn, which later became a borough of New York City, the team joined the NL in 1890 as the Brooklyn Bridegrooms and assumed several different monikers thereafter before finally settling on the name Dodgers in 1932.['),	
    ('Knicks', 'New York City', '2022', '(37, 45)', 'Alex Berg','The New York Knickerbockers,[3][7] shortened and more commonly referred to as the New York Knicks, are an American professional basketball team based in the New York City borough of Manhattan. The Knicks compete in the National Basketball Association (NBA) as a member of the Atlantic Division of the Eastern Conference. '),
    ('Nets', 'New York City', '2022', '(44, 38)', 'Steve Nash','The Brooklyn Nets are an American professional basketball team based in the New York City borough of Brooklyn. The Nets compete in the National Basketball Association (NBA) as a member of the Atlantic Division of the Eastern Conference. The team plays its home games at Barclays Center. They are one of two NBA teams located in New York City; the other is the New York Knicks.'),
    ('Warriors', 'San Francisco', '2022', '(53, 29)', 'Steve Kerr','The Golden State Warriors are an American professional basketball team based in San Francisco. The Warriors compete in the National Basketball Association (NBA), as a member of the league''s Western Conference Pacific Division. Founded in 1946 in Philadelphia, the Warriors moved to the San Francisco Bay Area in 1962 and took the city''s name, before changing its geographic moniker to Golden State in 1971.'),
    ('Hawks', 'Atlanta', '2022', '(43, 39)', 'Nate McMillan','The Atlanta Hawks are an American professional basketball team based in Atlanta. The Hawks compete in the National Basketball Association (NBA) as a member of the league''s Eastern Conference Southeast Division. The team plays its home games at State Farm Arena.'),
    ('Mavericks', 'Dallas', '2022', '(53, 20)', 'Jason Kidd','The Dallas Mavericks (often referred to as the Mavs) are an American professional basketball team based in Dallas. The Mavericks compete in the National Basketball Association (NBA) as a member of the Western Conference Southwest Division. The team plays its home games at the American Airlines Center, which it shares with the National Hockey League''s Dallas Stars.'),
    ('Red Sox', 'Boston', '2022', '(5, 5)', 'Alex Cora', 'The Boston Red Sox are an American professional baseball team based in Boston. The Red Sox compete in Major League Baseball (MLB) as a member club of the American League (AL) East division. Founded in 1901 as one of the American League''s eight charter franchises, the Red Sox'' home ballpark has been Fenway Park since 1912. ');

INSERT INTO betting_website (url, name, year_founded, money_wagered_per_month) VALUES
	('https://fivethirtyeight.com/','FiveThirtyEight','2006', '{800000, 600000, 170000, 340000, 450000, 230000, 160000, 230000, 340000, 400047, 389201, 600000}'),
	('https://www.caesars.com/sportsbook-and-casino','Caesars Sportsbook','2021', '{800000, 600000, 170000, 340000, 450000, 230000, 160000, 230000, 340000, 400047, 389201, 600000}'),
	('https://sportsbook.fanduel.com/','Fanduel Sportsbook','2009', '{800000, 600000, 170000, 340000, 450000, 230000, 160000, 230000, 340000, 400047, 389201, 600000}'),
	('https://sports.ny.betmgm.com/en/sports','BETMGM','2018', '{800000, 600000, 170000, 340000, 450000, 230000, 160000, 230000, 340000, 400047, 389201, 600000}'),
	('https://sportsbook.draftkings.com/sportsbook','Draftkings Sportsbook','2012', '{800000, 600000, 170000, 340000, 450000, 230000, 160000, 230000, 340000, 400047, 389201, 600000}'),
	('https://www.barstoolsportsbook.com/', 'Barstool Sportsbook', '2020', '{800000, 600000, 170000, 340000, 450000, 230000, 160000, 230000, 340000, 400047, 389201, 600000}'),
	('https://www.oddsshark.com/', 'OddsShark', '2004', '{800000, 600000, 170000, 340000, 450000, 230000, 160000, 230000, 340000, 400047, 389201, 600000}');


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
	(1000014, 'Cubs Vs. Red Sox', '2022-09-04', 'baseball', 'Boston, MA', 'Red Sox', 'MLB','Cubs','Red Sox'),
	(1000015, 'Warriors Vs. Hawks', '2022-09-06', 'basketball', 'San Francisco, CA', 'Hawks', 'NBA','Warriors','Hawks'),
	(1000016, 'Knicks Vs. Hawks', '2022-09-14', 'basketball', 'NYC, NY', 'Hawks', 'NBA','Knicks','Hawks'),
	(1000017, 'Knicks Vs. Nets', '2022-09-07', 'basketball', 'NYC, NY', 'Knicks', 'NBA','Knicks','Nets'),
	(1000018, 'Warriors Vs. Nets', '2022-09-24', 'basketball', 'San Francisco, CA', 'Warriors', 'NBA','Warriors','Nets');

	
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
	(1000014, 'Red Sox'),   
	(1000015, 'Warriors'),
	(1000015, 'Hawks'),
	(1000016, 'Knicks'),
	(1000016, 'Hawks'),
	(1000017, 'Knicks'),
	(1000017, 'Nets'),
	(1000018, 'Warriors'),
	(1000018, 'Nets');
   

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
	('NBA', 'Knicks'),
	('NBA', 'Nets'),
	('NBA', 'Warriors'),
	('NBA', 'Hawks'),
	('NBA', 'Mavericks'),
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
	(010,2,1000005, 'https://sportsbook.draftkings.com/sportsbook'),

	(011,18,1000006,'https://fivethirtyeight.com/'),
	(012,13,1000007,'https://fivethirtyeight.com/'),
	(013,88,1000008,'https://fivethirtyeight.com/'),
	(014,60,1000009,'https://fivethirtyeight.com/'),
	(015,66,1000010,'https://fivethirtyeight.com/'),
	(016,33,1000011,'https://fivethirtyeight.com/'),
	(017,2,1000012,'https://fivethirtyeight.com/'),
	(018,99,1000013,'https://fivethirtyeight.com/'),
	(019,85,1000014,'https://fivethirtyeight.com/'),
	(020,45,1000015,'https://fivethirtyeight.com/'),
	(021,22,1000016,'https://fivethirtyeight.com/'),
	(022,90,1000017,'https://fivethirtyeight.com/'),
	(023,50,1000018,'https://fivethirtyeight.com/'),
    
	(024,34,1000006,'https://sportsbook.draftkings.com/sportsbook'),
	(025,66,1000007,'https://sportsbook.draftkings.com/sportsbook'),
	(026,6,1000008,'https://sportsbook.draftkings.com/sportsbook'),
	(027,22,1000009,'https://sportsbook.draftkings.com/sportsbook'),
	(028,44,1000010,'https://sportsbook.draftkings.com/sportsbook'),
	(029,88,1000011,'https://sportsbook.draftkings.com/sportsbook'),
	(030,90,1000012,'https://sportsbook.draftkings.com/sportsbook'),
	(031,39,1000013,'https://sportsbook.draftkings.com/sportsbook'),
	(032,25,1000014,'https://sportsbook.draftkings.com/sportsbook'),
	(033,75,1000015,'https://sportsbook.draftkings.com/sportsbook'),
	(034,55,1000016,'https://sportsbook.draftkings.com/sportsbook'),
	(035,77,1000017,'https://sportsbook.draftkings.com/sportsbook'),
	(036,23,1000018,'https://sportsbook.draftkings.com/sportsbook'),

    
	(037,90,1000006,'https://sportsbook.fanduel.com/'),
	(038,23,1000007,'https://sportsbook.fanduel.com/'),
	(039,26,1000008,'https://sportsbook.fanduel.com/'),
	(040,42,1000009,'https://sportsbook.fanduel.com/'),
	(041,48,1000010,'https://sportsbook.fanduel.com/'),
	(042,89,1000011,'https://sportsbook.fanduel.com/'),
	(043,30,1000012,'https://sportsbook.fanduel.com/'),
	(044,3,1000013,'https://sportsbook.fanduel.com/'),
	(045,55,1000014,'https://sportsbook.fanduel.com/'),
	(046,73,1000015,'https://sportsbook.fanduel.com/'),
	(047,53,1000016,'https://sportsbook.fanduel.com/'),
	(048,50,1000017,'https://sportsbook.fanduel.com/'),
	(049,21,1000018,'https://sportsbook.fanduel.com/'),

   
	(050,7,1000006,'https://www.barstoolsportsbook.com/'),
	(051,36,1000007,'https://www.barstoolsportsbook.com/'),
	(052,66,1000008,'https://www.barstoolsportsbook.com/'),
	(053,2,1000009,'https://www.barstoolsportsbook.com/'),
	(054,14,1000010,'https://www.barstoolsportsbook.com/'),
	(055,63,1000011,'https://www.barstoolsportsbook.com/'),
	(056,50,1000012,'https://www.barstoolsportsbook.com/'),
	(057,51,1000013,'https://www.barstoolsportsbook.com/'),
	(058,44,1000014,'https://www.barstoolsportsbook.com/'),
	(059,45,1000015,'https://www.barstoolsportsbook.com/'),
	(060,49,1000016,'https://www.barstoolsportsbook.com/'),
	(061,41,1000017,'https://www.barstoolsportsbook.com/'),
	(062,69,1000018,'https://www.barstoolsportsbook.com/');




