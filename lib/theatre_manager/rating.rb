require_relative 'database_connector.rb'


class Rating
  include DatabaseConnector
  
  # rating - String of the movie rating (G, PG, PG-13, R, etc)
  attr_reader :id, :errors
  attr_accessor :name
  
  
  # initializes a Rating id
  #
  # optional Hash argument
  #         rating  - String of the rating
  #         id      - Integer of the id
  #
  # returns an instance of the object
  def initialize(args={})
    if args["id"].blank?
      @id =  ""
    else
      @id = args["id"].to_i
    end
    @name = args[:name] || args["name"]
    @errors = []
  end
  
  def to_s
    "id: #{id}\t\tname: #{name}"
  end
  
  
  # returns Boolean if ok to delete
  #
  # id - Integer of the id to delete
  #
  # returns Boolean
  def self.ok_to_delete?(id)
    if Movie.where_match("rating_id", id, "==").length > 0
        false
    else
        true
    end
  end
  
  # returns Boolean if data is valid
  #
  # returns Boolean
  def valid?
    @errors = []
    # check thename exists and is not empty
    if name.to_s.empty?
      @errors << {message: "Name cannot be empty.", variable: "name"}
    end
    
    @errors.empty?
  end
  
end