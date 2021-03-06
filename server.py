#!/usr/bin/env python

"""
Columbia's COMS W4111.003 Introduction to Databases
Example Webserver

To run locally:

    python server.py

Go to http://localhost:8111 in your browser.

A debugger such as "pdb" may be helpful for debugging.
Read about it online.
"""

from crypt import methods
import pandas as pd
import os
from sqlalchemy import *
from sqlalchemy.pool import NullPool
from flask import Flask, request, render_template, g, redirect, Response
from backend import Backend

static_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'static')
tmpl_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'templates')
app = Flask(__name__, template_folder=tmpl_dir, static_folder=static_dir)
backend = Backend()


#
# The following is a dummy URI that does not connect to a valid database. You will need to modify it to connect to your Part 2 database in order to use the data.
#
# XXX: The URI should be in the format of: 
#
#     postgresql://USER:PASSWORD@104.196.152.219/proj1part2
#
# For example, if you had username biliris and password foobar, then the following line would be:
#
#     DATABASEURI = "postgresql://biliris:foobar@104.196.152.219/proj1part2"
#


"""
@app.before_request
def before_request():
  
  This function is run at the beginning of every web request 
  (every time you enter an address in the web browser).
  We use it to setup a database connection that can be used throughout the request.

  The variable g is globally accessible.
  
  try:
    pass
  except:
    print("uh oh, problem connecting to database")
    import traceback; traceback.print_exc()
    g.conn = None

@app.teardown_request
def teardown_request(exception):
  
  At the end of the web request, this makes sure to close the database connection.
  If you don't, the database could run out of memory!
  
  try:
    #g.conn.close()
    pass
  except Exception as e:
    pass
"""

#
# @app.route is a decorator around index() that means:
#   run index() whenever the user tries to access the "/" path using a GET request
#
# If you wanted the user to go to, for example, localhost:8111/foobar/ with POST or GET then you could use:
#
#       @app.route("/foobar/", methods=["POST", "GET"])
#
# PROTIP: (the trailing / in the path is important)
# 
# see for routing: http://flask.pocoo.org/docs/0.10/quickstart/#routing
# see for decorators: http://simeonfranklin.com/blog/2012/jul/1/python-decorators-in-12-steps/
#
@app.route('/')
def index():
  return render_template("index.html")

#
# This is an example of a different path.  You can see it at:
# 
#     localhost:8111/another
#
# Notice that the function name is another() rather than index()
# The functions for each app.route need to have different names
#
@app.route("/eventodds/", methods=["POST", "GET"])
def get_event_odds_render():
  if request.method == "POST":
    date = request.form['date']
    if len(date) == 0:
      date = None
    team = request.form['team']
    if team == "None":
      team = None
    player = request.form['player']
    if player == "None":
      player = None
    if player == None:
      first = None
      last = None
    else:
      player.strip()
      player = player.split()
      first = player[0]
      last = player[1]
    league = request.form['league']
    if league == "None":
      league = None
    
    events_list = backend.get_events(date, team, first, last, league)
    ids = []
    for i in events_list:
      ids.append(i[0])
    return render_template("eventodds.html", teams=backend.get_team_names(),
      leagues=backend.get_league_names(), players=backend.get_players(), 
      events=events_list, ids=ids)
  
  events_list = backend.get_events(None, None, None, None, None)
  ids = []
  for i in events_list:
    ids.append(i[0])
  return render_template("eventodds.html", teams=backend.get_team_names(),
    leagues=backend.get_league_names(), players=backend.get_players(), 
    events=events_list, ids=ids)

@app.route('/historicalaccuracy/', methods=['GET', 'POST'])
def historical_accuracy_view():
  events = request.args.get("data")
  if events != "[]":
    new = events[1:len(events)-1].split(",")
    for i in range(len(new)):
      new[i] = int(new[i])
  else: 
    new = []
  return render_template("historicalaccuracy.html", events=backend.get_historical_accuracy_all_urls(new))

@app.route('/debugging/', methods=["POST", "GET"])
def debug():
  if request.method == "POST":
    #execute query
    result = backend.query(request.form['query'])
    return render_template("debugging.html", data=result)
  return render_template("debugging.html")


@app.route('/bettingwebsitesinfo/', methods=["POST", "GET"])
def websites_info():
    return render_template("bettingwebsitesinfo.html")

@app.route('/event/', methods=['GET'])
def event():
  data = request.args.get('data')
  data = int(data)
  return render_template("event.html", info=backend.get_event_info(data),
   odds=backend.get_event_odds(data), players=backend.get_event_players(data))


@app.route('/team/', methods=['GET'])
def team():
  data = request.args.get('data')
  data.strip()
  team_info = backend.get_team_info(data)
  return render_template("team.html", info=team_info)

@app.route('/player/', methods=['GET'])
def player():
  data = request.args.get('data')
  first = data[0:50].strip()
  last = data[50:].strip()
  return render_template("player.html", info=backend.get_player_info(first, last))

@app.route('/league/', methods=['GET'])
def league():
  data = request.args.get('data')
  data.strip()
  return render_template("league.html", info=backend.get_league_info(data))

@app.route('/about/', methods=['GET'])
def about():
  return render_template("about.html")

if __name__ == "__main__":
  import click

  @click.command()
  @click.option('--debug', is_flag=True)
  @click.option('--threaded', is_flag=True)
  @click.argument('HOST', default='0.0.0.0')
  @click.argument('PORT', default=8111, type=int)
  def run(debug, threaded, host, port):
    """
    This function handles command line parameters.
    Run the server using:

        python server.py

    Show the help text using:

        python server.py --help

    """

    HOST, PORT = host, port
    print("running on %s:%d" % (HOST, PORT))
    app.run(host=HOST, port=PORT, debug=debug, threaded=threaded)


  run()
