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
require_relative 'theatre_manager/foreign_key.rb'



CONNECTION=SQLite3::Database.new("/Users/gwendolyn/code/06-19-Database/lib/movies.db")
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
      movie.add_menu_item({key_user_returns: 1, user_message: "Create a movie.", method_name: "create/movie/x?"})
      movie.add_menu_item({key_user_returns: 2, user_message: "Update a movie.", method_name: "update/movie", parameters: [Movie, "movie"]})
      movie.add_menu_item({key_user_returns: 3, user_message: "Show me movies.", method_name:"show/movie", parameters: [Movie, "movie"]})
      movie.add_menu_item({key_user_returns: 4, user_message: "Delete a movie.", method_name:"delete/movie", parameters: [Movie, "movie"]})
      movie.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", method_name: "home"})
      movie
  end
  
  # defines and runs the theatre menu
  #
  # runs the theatre menu
  def theatre
      theatre = Menu.new("What would you like to do with theatres?")
      theatre.add_menu_item({key_user_returns: 1, user_message: "Create a theatre.", method_name: "create/theatre/x?"})
      theatre.add_menu_item({key_user_returns: 2, user_message: "Update a theatre.", method_name: "update/theatre", parameters: [Location, "theatre"]})
      theatre.add_menu_item({key_user_returns: 3, user_message: "Show me theatres.", method_name: "show/theatre", parameters: [Location, "theatre"]})
      theatre.add_menu_item({key_user_returns: 4, user_message: "Delete a theatre.", method_name:"delete/theatre", parameters: [Location, "theatre"]})
      theatre.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", method_name: "home"})
      theatre
  end
    
  # defines and runs the LocationTime menu
  #
  # runs the LocationTime menu
  def location_time
      loc_time = Menu.new("What would you like to do with movie time/theatre slots?")
      loc_time.add_menu_item({key_user_returns: 1, user_message: "Create a new theatre/time slot.", 
        method_name: "create/location_time/x?"})
      loc_time.add_menu_item({key_user_returns: 2, user_message: "Update a theatre/time slot.", 
        method_name: "update/location_time", parameters: [LocationTime, "location_time"]})
      loc_time.add_menu_item({key_user_returns: 3, user_message: "Show me theatre/time slots.", 
        method_name: "show/location_time", parameters: [LocationTime, "location_time"]})
      loc_time.add_menu_item({key_user_returns: 4, user_message: "Delete a theatre/time slot.", 
        method_name: "delete/location_time"})
      loc_time.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", method_name: "home"})
      loc_time          
  end
  
  # defines and runs the analyze menu
  #
  # runs the analyze menu
  def analyze
      analyze = Menu.new("What would you like to see?")
      analyze.add_menu_item({key_user_returns: 1, user_message: "Get all time/theatres for a particular 
        movie.", method_name: "get_time_location/movie"})
      analyze.add_menu_item({key_user_returns: 2, user_message: "Get all times for a particular theatre.", 
        method_name: "get_time_location/theatre"})
      analyze.add_menu_item({key_user_returns: 3, user_message: "Get all movies played at this time.", 
        method_name: "get_time_location/time"})
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
  
  def available
    create_menu  = Menu.new("Do you want to get all available or not available?")
    create_menu.add_menu_item({key_user_returns: 1, user_message: "Available", method_name: "available"})
    create_menu.add_menu_item({key_user_returns: 2, user_message: "Not available", method_name: "not_available"})
    create_menu
  end
  
  
  def sold_out
    create_menu  = Menu.new("Do you want to get all those that are sold out or not sold out?")
    create_menu.add_menu_item({key_user_returns: 1, user_message: "Sold out", method_name: "sold_out"})
    create_menu.add_menu_item({key_user_returns: 2, user_message: "Not sold out", method_name: "not_sold_out"})
    create_menu
  end
  
  def movie_type_lookup_menu
    create_menu = Menu.new("What do you want to look up?")
    create_menu.add_menu_item({key_user_returns: 1, user_message: "Studios", method_name: "studio"})
    create_menu.add_menu_item({key_user_returns: 2, user_message: "Ratings", method_name: "rating"})
    create_menu
  end
  
  # accepts a Class, creates a menu of all instances of that object from the database, and returns an instance of the object from the database that the user selects
  # requires the DatabaseConnector module to be used
  #
  # class_object - Class object (like Movie or Student)
  #
  # returns Menu
  def user_choice_of_object_in_class(class_object)
    create_menu = Menu.new("Which #{class_object.name} do you want to look up?")
    all = class_object.all
    all.each_with_index do |object, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: object.to_s, method_name: "#{object.id}"})
    end
    create_menu
  end
  # Creates a menu and returns the field name that the user wants to change
  # requires the DatabaseConnector module to be used on the object
  #
  # returns Menu
  def user_choice_of_field(object)
    fields = object.database_field_names
    create_menu = Menu.new("Which field do you want to update?")
    fields.each_with_index do |field, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: field, method_name: "#{object.class}/#{object.id}/#{field}"})
    end
    create_menu
  end
 
 
  def class_to_slash_names
    {Location => "theatre", LocationTime => "location_time", Movie => "movie", Rating => "rating", Studio => "studio"}
  end
  
end