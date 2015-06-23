require_relative 'database_connector.rb'


class Studio
  include DatabaseConnector
  
  attr_accessor :name
  attr_reader :id, :errors

  
  # Initializes Studio object
  #
  # options Hash
  #         - id - Integer of the id
  #         - name - String of the name
  #
  # returns an instance of the object
  def initialize(args={})
    if args["id"].blank?
      @id = ""
    else
      @id = args["id"].to_i
    end
    @name = args[:name] || args["name"]
  end
  
  # String version of object
  #
  # returns String
  def to_s
    "id: #{id}\t\t name: #{name}"
  end
  
  # returns a Boolean if it is ok to delete
  #
  # id - Integer of the Record id
  #
  # returns Boolean
  def self.ok_to_delete?(id)
    if Movie.where_match("studio_id", id, "==").length > 0
        false
    else
        true
    end
  end
  
  # returns a Boolean if it is ok to save to the
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