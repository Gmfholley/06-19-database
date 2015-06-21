require "minitest/autorun"
require 'active_support.rb'
require 'active_support/core_ext/object/blank.rb'
require "/Users/gwendolyn/code/06-19-Database/lib/theatre_manager.rb"
# require "/Users/gwendolyn/code/06-19-Database/lib/theatre_manager/foreign_key.rb"
# require "/Users/gwendolyn/code/06-19-Database/lib/theatre_manager/rating.rb"

# require_relative "movie.rb"
# require_relative "rating.rb"
# require_relative "location_time.rb"
# require_relative "timeslot.rb"
# require_relative "studio.rb"
# require_relative "location.rb"


# CONNECTION=SQLite3::Database.new("/Users/gwendolyn/code/06-19-Database/lib/movies.db")
# CONNECTION.results_as_hash = true
# CONNECTION.execute("PRAGMA foreign_keys = ON;")

class ForeignKeyTest < Minitest::Test


  def test_initialize
    f = ForeignKey.new(id: 1, class_name: Rating)
    assert_equal(1, f.id)
    assert_equal(Rating, f.class_name)
    
    f = ForeignKey.new
    assert_equal(0, f.id)
    assert_equal(nil, f.class_name)
    
    f = ForeignKey.new("id" => 1, "class_name" => Rating)
    assert_equal(1, f.id)
    assert_equal(Rating, f.class_name)
    
  end
  
  def test_object
    f = ForeignKey.new(id: 1, class_name: Rating)
    assert_equal(Rating, f.get_object.class)
    assert_equal(Array, f.all_from_class.class)
    assert_equal(Rating, f.all_from_class.first.class)
    assert_equal(Array, f.possible_values.class)
    assert_equal(Fixnum, f.possible_values.first.class)
    
  end
  
  
  def test_valid
    f = ForeignKey.new
    f.valid?
    assert_equal(3, f.errors.length)
    
    f = ForeignKey.new(id: nil, class_name: nil)
    f.valid?
    assert_equal(3, f.errors.length)
  
    f = ForeignKey.new(id: "", class_name: "")
    f.valid?
    assert_equal(3, f.errors.length)
    
    # need a real class/table and need a good id for it
    f = ForeignKey.new(id: "s", class_name: "s")
    f.valid?
    assert_equal(2, f.errors.length)
    
    # Test it works
    f = ForeignKey.new(id: 1, class_name: Rating)
    f.valid?
    assert_equal(0, f.errors.length)
    biggest_num = f.all_from_class.length
    
    # Test id is bigger than the number of records
    f = ForeignKey.new(id: biggest_num + 10, class_name: Rating)
    f.valid?
    assert_equal(1, f.errors.length)
    
    # Test id is less than 0
    f = ForeignKey.new(id: -1, class_name: Rating)
    f.valid?
    assert_equal(1, f.errors.length)
    
  end
   #
  # def test_to_s
  #   movie = Movie.new("id" => 1, "name" => "Wendy", "description" => "In a world!", "rating_id" => 1,
  #   "studio_id" => 1, "length" => 1)
  #   movie_s = "id:\t1\t\tname:\tWendy\t\trating:\tG\t\tstudio:\tParamount\t\tlength:\t1"
  #   # "id:\t#{@id}]\t\tname:\t#{name}\t\trating:\t#{rating}\t\tstudio:\t#{studio}\t\tlength:\t#{length}"
  #
  #   assert_equal(movie_s, movie.to_s)
  # end
  #
  #
  # def test_crud
  #   m = Movie.new("id" => 1, "name" => "Wendy", "description" => "In a world!", "rating_id" => 1,
  #   "studio_id" => 1, "length" => 1)
  #   assert_equal(Fixnum, m.save_record.class)
  #   m.name = "Pur"
  #   assert_equal(Array, m.update_record.class)
  #   assert_equal(true, Movie.ok_to_delete?(m.id))
  #
  #   assert_equal(Array, Movie.delete_record(m.id).class)
  #   assert_equal(Movie, Movie.all.first.class)
  # end
  #
  # # the first movie should be booked
  # # but maybe it won't after a while
  # def test_ok_to_delete
  #   m = Movie.new("name" => "Wendy", "description" => "In a world!", "rating_id" => 1,
  #   "studio_id" => 1, "length" => 1)
  #   m.save_record
  #   l = LocationTime.new(location_id: 3, timeslot_id: 5, movie_id: m.id)
  #   l.save_record
  #   assert_equal(false, Movie.ok_to_delete?(m.id))
  #   LocationTime.delete_record(l.location_id, l.timeslot_id)
  #   assert_equal(true, Movie.ok_to_delete?(m.id))
  #   Movie.delete_record(m.id)
  # end
  #
  # def test_location_times
  #   m = Movie.new("id" => 1, "name" => "Wendy", "description" => "In a world!", "rating_id" => 1,
  #   "studio_id" => 1, "length" => 1)
  #   assert_equal(Array, m.location_times.class)
  #
  #   m = Movie.create_from_database(1)
  #   assert_equal(LocationTime, m.location_times.first.class)
  # end
  #
  #
  # def test_valid
  #   # Can't be nil
  #   m = Movie.new(name: nil, description: nil, studio_id: nil, rating_id: nil, length: nil)
  #   m.valid?
  #   assert_equal(5, m.errors.length)
  #
  #   # can't be empty strings
  #   m = Movie.new(name: "", description: "", studio_id: "", rating_id: "", length: "")
  #   m.valid?
  #   assert_equal(5, m.errors.length)
  #
  #   # can't be whatever is created when no args are passed
  #   m = Movie.new()
  #   m.valid?
  #   assert_equal(5, m.errors.length)
  #
  #
  #   # rating & studio id must belong to the table; length must be a number
  #   m = Movie.new(name: "s", description: "s", studio_id: "s", rating_id: "s", length: "s")
  #   m.valid?
  #   assert_equal(3, m.errors.length)
  #
  #   # length must be 0 or greater, and studio & rating must belong to the table
  #   m = Movie.new(name: 0, description: 0, studio_id: 0, rating_id: 0, length: 0)
  #   m.valid?
  #   assert_equal(2, m.errors.length)
  #
  #
  #   # num_time_slots can't be more than the maximum number of time slots allowed
  #   m = Movie.new(name: 1, description: 1, studio_id: Studio.all.last.id + 1, rating_id: Rating.all.last.id + 1, length: 0)
  #   m.valid?
  #   assert_equal(2, m.errors.length)
  #   m.studio_id = Studio.all.last.id
  #   m.rating_id = Rating.all.last.id
  #   m.valid?
  #   assert_equal(0, m.errors.length)
  #
  # end

  
end