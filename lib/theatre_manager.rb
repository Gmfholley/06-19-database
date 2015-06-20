require 'active_support.rb'
require 'active_support/core_ext/object/blank.rb'
require 'sqlite3.rb'
require_relative 'theatre_manager/database_connector.rb'
require_relative 'theatre_manager/location.rb'
require_relative 'theatre_manager/rating.rb'
require_relative 'theatre_manager/studio.rb'
require_relative 'theatre_manager/timeslot.rb'
require_relative 'theatre_manager/movie.rb'
require_relative 'theatre_manager/location_time.rb'
require_relative 'theatre_manager/menu.rb'
require_relative 'theatre_manager/method_to_call.rb'



CONNECTION=SQLite3::Database.new("movies.db")
CONNECTION.results_as_hash = true
CONNECTION.execute("PRAGMA foreign_keys = ON;")


class TheatreManager  
  def initialize
  end
  
  # defines and runs Main Menu
  #
  # calls the main menu
  def home
      main = Menu.new("What would you like to work on?")
      main.add_menu_item({key_user_returns: 1, user_message: "Work with movies.", method_name: "movie"})
      main.add_menu_item({key_user_returns: 2, user_message: "Work with theatres.", method_name:"theatre"})
      main.add_menu_item({key_user_returns: 3, user_message: "Schedule movie time slots by theatre.", method_name: "location_time"})
      main.add_menu_item({key_user_returns: 4, user_message: "Run an analysis on my theatres.", method_name: "analyze"})
      main
  end
  
  # defines and runs the movie menu
  #
  # calls the theatre menu
  def movie
      movie = Menu.new("What would you like to do with movies?")
      movie.add_menu_item({key_user_returns: 1, user_message: "Create a movie.", method_name: "create"})
      movie.add_menu_item({key_user_returns: 2, user_message: "Update a movie.", method_name: "update", parameters: [Movie, "movie"]})
      movie.add_menu_item({key_user_returns: 3, user_message: "Show me movies.", method_name:"show", parameters: [Movie, "movie"]})
      movie.add_menu_item({key_user_returns: 4, user_message: "Delete a movie.", method_name:"delete", parameters: [Movie, "movie"]})
      movie.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", method_name: "home"})
      movie
  end
  
  # defines and runs the theatre menu
  #
  # runs the theatre menu
  def theatre
      theatre = Menu.new("What would you like to do with theatres?")
      theatre.add_menu_item({key_user_returns: 1, user_message: "Create a theatre.", method_name: "create"})
      theatre.add_menu_item({key_user_returns: 2, user_message: "Update a theatre.", method_name: "update", parameters: [Location, "theatre"]})
      theatre.add_menu_item({key_user_returns: 3, user_message: "Show me theatres.", method_name: "show", parameters: [Location, "theatre"]})
      theatre.add_menu_item({key_user_returns: 4, user_message: "Delete a theatre.", method_name:"delete", parameters: [Location, "theatre"]})
      theatre.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", method_name: "home"})
      theatre
  end
    
  # defines and runs the LocationTime menu
  #
  # runs the LocationTime menu
  def location_time
      loc_time = Menu.new("What would you like to do with movie time/theatre slots?")
      loc_time.add_menu_item({key_user_returns: 1, user_message: "Create a new theatre/time slot.", 
        method_name: "create"})
      loc_time.add_menu_item({key_user_returns: 2, user_message: "Update a theatre/time slot.", 
        method_name: "update", parameters: [LocationTime, "location_time"]})
      loc_time.add_menu_item({key_user_returns: 3, user_message: "Show me theatre/time slots.", 
        method_name: "show", parameters: [LocationTime, "location_time"]})
      loc_time.add_menu_item({key_user_returns: 4, user_message: "Delete a theatre/time slot.", 
        method_name: "delete"})
      loc_time.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", method_name: "home"})
      loc_time          
  end
  
  # defines and runs the analyze menu
  #
  # runs the analyze menu
  def analyze
      analyze = Menu.new("What would you like to see?")
      analyze.add_menu_item({key_user_returns: 1, user_message: "Get all time/theatres for a particular 
        movie.", method_name: "get_time_location_for_movie"})
      analyze.add_menu_item({key_user_returns: 2, user_message: "Get all times for a particular theatre.", 
        method_name: "get_time_location_for_location"})
      analyze.add_menu_item({key_user_returns: 3, user_message: "Get all movies played at this time.", 
        method_name: "get_all_movies_for_this_time"})
      analyze.add_menu_item({key_user_returns: 4, user_message: "Get all time/theatres that are sold out or 
        not sold out.", method_name: "get_sold_time_locations"})
      analyze.add_menu_item({key_user_returns: 5, user_message: "Get all movies from a particular studio or 
        rating.", method_name: "get_movies_like_this"})
      analyze.add_menu_item({key_user_returns: 6, user_message: "Get all theatres that are booked or not 
        fully booked.", method_name: "get_available_locations"})
      analyze.add_menu_item({key_user_returns: 7, user_message: "Get number of staff needed for a time 
        slot.", method_name: "get_num_staff_needed"})
      analyze.add_menu_item({key_user_returns: 8, user_message: "Return to main menu.", method_name: "home"})
      analyze
  end
  
end