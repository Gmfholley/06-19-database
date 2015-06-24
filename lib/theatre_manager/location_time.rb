require_relative 'database_connector.rb'
require_relative '/Users/gwendolyn/code/06-19-Database/lib/theatre_manager.rb'
require_relative 'foreign_key.rb'

# CONNECTION=SQLite3::Database.new("/Users/gwendolyn/code/06-19-Database/lib/movies.db")
# CONNECTION.results_as_hash = true
# CONNECTION.execute("PRAGMA foreign_keys = ON;")

class LocationTime
  include DatabaseConnector
  
  attr_accessor :num_tickets_sold
  attr_reader :location_id, :timeslot_id, :movie_id, :errors, :id
  # initializes object
  #
  # args -      Options Hash
  #             id                - Integer of the ID number of record in the database
  #             location_id       - Integer of the location_id in the locations table
  #             timeslot_id       - Integer of the timeslot_id in timeslots table
  #             movie_id          - Integer of the movie_id in movies table
  #             num_tickets_sold  - Integer of the number of tickets sold for this time slot - Defaults to 0
  #
  # TODO - make this look prettier
  def initialize(args={})
    if args["id"].blank?
      @id = ""
    else
      @id = args["id"].to_i
    end
    
    l_id = (args[:location_id] || args["location_id"]).to_i
    @location_id = ForeignKey.new({id: l_id, class_name: Location})
    t_id = (args[:timeslot_id] || args["timeslot_id"]).to_i
    @timeslot_id = ForeignKey.new({id: t_id, class_name: TimeSlot})
    m_id = (args[:movie_id] || args["movie_id"]).to_i
    @movie_id = ForeignKey.new({id: m_id, class_name: Movie})
    
    @num_tickets_sold = (args[:num_tickets_sold] || args["num_tickets_sold"]).to_i
  end
  
  def movie_id=(new_id)
    @movie_id = ForeignKey.new(id: new_id, class_name: Movie)
  end
  
  # returns the String representation of the time slot
  #
  # returns String
  def to_s 
    "location:\t#{location}\t\ttimeslot:\t#{timeslot}\t\tmovie:\t#{movie}"
  end
  
  # returns the movie's name
  #
  # returns String
  def movie
    movie_id.get_object.name
    # m = Movie.create_from_database(movie_id.to_i)
    # m.name
  end
  
  # returns the time slot in time
  #
  # returns Integer
  def timeslot
    timeslot_id.get_object.time_slot
    # t = TimeSlot.create_from_database(timeslot_id.to_i)
    # t.time_slot
  end
  
  # returns the location name for this ti
  #
  # returns String
  def location
    location_object.name
  end
  
  def location_object
    location_id.get_object
  end
  
  # returns whether tickets are sold out for the location
  #
  # returns Boolean
  def sold_out?
    l = location_object
    l.num_seats == num_tickets_sold
  end
  
  # returns how many tickets remain at this location
  #
  # returns Integer
  def tickets_remaining
    l = location_object
    if !l.num_seats.blank?
      l.num_seats - num_tickets_sold
    else
      0
    end
  end
  
  # returns an Array of objects of all movies at this location
  #
  # returns an Array
  def where_this_location
    LocationTime.where_match("location_id", @location_id.id, "==")
  end

  # returns an Array of objects of all movies at this location
  #
  # returns an Array
  def where_this_time
    LocationTime.where_match("timeslot_id", @timeslot_id.id, "==")
  end
  
  # returns an Array of objects of all movies at this location
  #
  # returns an Array
  def where_this_movie
    LocationTime.where_match("movie_id", @movie_id.id, "==")
  end

  # returns Boolean if objects are valid
  #
  # TODO - make this look prettier
  # returns Boolean
  def valid?
    @errors = []
    # check thename exists and is not empty
    # check the description exists and is not empty
    # if timeslot_id.to_s.empty?
    #   @errors << {message: "TimeSlotslot id cannot be empty.", variable: "timeslot_id"}
    # elsif timeslot.blank?
    #   @errors << {message: "TimeSlotslot id must be a member of the times table.", variable: "timeslot_id"}
    # end
    #
    # # check the description exists and is not empty
    # if location_id.to_s.empty?
    #   @errors << {message: "Location id cannot be empty.", variable: "location_id"}
    # elsif location.blank?
    #   @errors << {message: "Location id must be a member of the locations table.", variable: "location_id"}
    # end
    
    # check the description exists and is not empty
    # if movie_id.to_s.empty?
    #   @errors << {message: "Movie id cannot be empty.", variable: "movie_id"}
    # elsif movie.blank?
    #   @errors << {message: "Movie id must be a member of the movies table.", variable: "movie_id"}
    # end
    
    
    if !timeslot_id.valid?
      @errors += timeslot_id.errors
    end
    
    if !location_id.valid?
      @errors += location_id.errors
    end
    
    lt = lookup_this_location_time
    
    if !lt.id.blank? && lt.id != @id
      @errors << {message: "This location and time are already booked in the database in another record.", variable: "location_id, timeslot_id"}
    end
    
    if !movie_id.valid?
      @errors += movie_id.errors
    end
    
    # checks the number of time slots
    if num_tickets_sold.to_s.empty?
      @errors << {message: "Num_tickets_sold cannot be empty.", variable: "num_tickets_sold"}
    elsif num_tickets_sold.is_a? Integer
      if num_tickets_sold < 0
        @errors << {message: "Num_tickets_sold must be greater than 0.", variable: "num_tickets_sold"}
      elsif tickets_remaining < 0
        @errors << {message: "Num_tickets_sold cannot be greater than the number of seats.", variable: 
          "num_tickets_sold"}
      end
    else
      @errors << {message: "Num_tickets_sold must be a number.", variable: "num_tickets_sold"}
    end
    # returns whether @errors is empty
    @errors.empty?
  end
  
  # returns a boolean to indicate if this object's timeslot & location are unique
  #
  # returns Boolean
  # TODO - make this look prettier
  def lookup_this_location_time
    rec = CONNECTION.execute("SELECT * FROM #{table} WHERE location_id = #{location_id.id} AND timeslot_id = #{timeslot_id.id};").first
    if rec.blank?
      return LocationTime.new
    else
      return LocationTime.new(rec)
    end
  end
  
  # returns all Locations with tickets greater than the number of tickets
  #
  # num_tickets    - Integer of the number of tickets sold
  #
  # returns an Array of LocationTime objects
  def self.where_tickets_greater_than(num_tickets)
    LocationTime.where_match("num_tickets_sold", num_tickets, ">")
  end
  
  # returns Array of objects of the sold out or not sold out LocationTimes
  #
  # returns an Array
  def self.where_sold_out(sold_out=true)
    if sold_out
     LocationTime.as_objects(CONNECTION.execute("SELECT * FROM locationtimes locationtime LEFT OUTER JOIN 
     locations location ON location.id = locationtime.location_id WHERE location.num_seats <= 
     locationtime.num_tickets_sold;"))
   else
     LocationTime.as_objects(CONNECTION.execute("SELECT * FROM locationtimes locationtime LEFT OUTER JOIN 
     locations location ON location.id = locationtime.location_id WHERE location.num_seats > 
     locationtime.num_tickets_sold;"))
   end
  end
  
end