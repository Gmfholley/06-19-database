require_relative 'database_connector.rb'

class ForeignKey
  
  attr_reader :id, :class_name, :field_in_table, :errors
  
  def initialize(args={})
    @id = args["id"] || args[:id]
    @class_name = args["class"] || args[:class_name]
    @field_in_table = args["fields_in_table"] || args[:fields_in_table]
    @errors = []
  end
  
  
  # fetches all objects from the foreign class as an Array
  #
  # returns an Array
  def all_from_class
    begin
      class_name.all
    rescue
      @errors << {message: "Unable to find this class in the database.", variable: "class_name"}
      []
    end  
  end
  
  
  # returns an Array of possible values of this id from the fields_in_table
  #
  # returns an Array
  def possible_values
    all_objects = all_from_class
    values = []
    all_objects.each do |obj|
      values << obj.send(field_in_table)
    end
    values
  end
  
  def valid?
    @errors = []
    if id.blank?
      @errors << {message: "Id cannot be blank.", variable: "id"}
    elsif !possible_values.include?(id)
      @errors << {message: "Id must be included in the table.", variable: "id"}
    end
    
    if class.blank?
      @errors << {message: "Class cannot be blank.", variable: "class"}
    end
    
    if fields_in_table.blank?
      @errors << {message: "Field in other table cannot be blank.", variable: "field_in_table"}
    elsif all_from_class.length > possible_values.length
      @errors << {message: "Field name was not found in the table.", variable: "field_in_table"}
    end
  end
end