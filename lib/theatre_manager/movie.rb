# require 'active_support.rb'
# require 'active_support/core_ext/object/blank.rb'
# require_relative 'database_connector.rb'
# require_relative 'foreign_key.rb'
# require_relative 'rating.rb'
# require_relative 'studio.rb'
# require_relative 'location_time.rb'
# require_relative 'location.rb'
# require_relative 'timeslot.rb'
#
# CONNECTION=SQLite3::Database.new("/Users/gwendolyn/code/06-19-Database/lib/movies.db")
# CONNECTION.results_as_hash = true
# CONNECTION.execute("PRAGMA foreign_keys = ON;")

class Movie
  include DatabaseConnector
  
  attr_accessor :name, :description, :length, :studio_id
  attr_reader :id, :errors, :rating_id
  
  # initializes object
  #
  # args -      Options Hash
  #             id            - Integer of the ID number of record in the database
  #             description   - String of the name
  #             rating_id     - Integer of the rating_id in ratings table
  #             studio_id     - Integer of the studio_id in studios table
  #             length        - Integer of the length of the movie
  #
  def initialize(args={})
    @id = args["id"] || ""
    @name = args[:name] || args["name"]
    @description = args[:description] || args["description"]

    @length = args[:length] || args["length"]
    r_id = args[:rating_id] || args["rating_id"]
    @rating_id = ForeignKey.new({id: r_id, class_name: Rating})
    s_id = args[:studio_id] || args["studio_id"]
    @studio_id = ForeignKey.new({id: s_id, class_name: Studio})
    
  end
  
  def rating_id=(new_id)
    @rating_id = ForeignKey.new({id: new_id, class_name: Rating})
  end
  
  def studio_id=(new_id)
    @studio_id = ForeignKey.new({id: new_id, class_name: Studio})
  end
  
  # returns a Boolean if it is ok to delete
  #
  # id - Integer of the id to delete
  #
  # returns Boolean
  def self.ok_to_delete?(id)
    if LocationTime.where_match("movie_id", id, "==").length > 0
      false
    else
      true
    end
  end
  
  # returns String representing this object's parameters
  #
  # returns String
  def to_s
    "id:\t#{@id}\t\tname:\t#{name}\t\trating:\t#{rating}\t\tstudio:\t#{studio}\t\tlength:\t#{length}"
  end
  
  # returns the rating
  #
  # returns String
  def rating
    rating_id.get_object.name
  end
  
  # returns the studio name
  #
  # returns String
  def studio
    studio_id.get_object.name
  end
  
  # returns Array of all the location-times for this movie
  #
  # returns Array
  def location_times
    LocationTime.where_match("movie_id", id, "==")
  end
  
  # put your business rules here, and it returns Boolean to indicate if it is valid
  #
  # returns Boolean
  def valid?
    @errors = []
    # check thename exists and is not empty
    if name.to_s.empty?
      @errors << {message: "Name cannot be empty.", variable: "name"}
    end
  
    # check the description exists and is not empty
    if description.to_s.empty?
      @errors << {message: "Description cannot be empty.", variable: "description"}
    end
    
    # check the description exists and is not empty
    # if studio_id.to_s.empty?
    #   @errors << {message: "Studio id cannot be empty.", variable: "studio_id"}
    # elsif studio.blank?
    #   @errors << {message: "Studio id must be a member of the studios table.", variable: "studio_id"}
    # end   
    
    if !studio_id.valid?
      @errors += studio_id.errors
    end
    
    # check the description exists and is not empty
    # if rating_id.to_s.empty?
    #   @errors << {message: "Rating id cannot be empty.", variable: "rating_id"}
    # elsif rating.blank?
    #   @errors << {message: "Rating id must be a member of the ratings table.", variable: "rating_id"}
    # end
    
    if !rating_id.valid?
      @errors += rating_id.errors
    end
    # checks the number of time slots
    if length.to_s.empty?
      @errors << {message: "Length cannot be empty.", variable: "length"}
    elsif length.is_a? Integer
      if length < 0
        @errors << {message: "Length must be greater than 0.", variable: "length"}
      end
    else
      @errors << {message: "Length must be a number.", variable: "length"}
    end
  
    # returns whether @errors is empty
    @errors.empty?
  end
end