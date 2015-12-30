require 'pry'
require 'minitest'
require 'minitest/autorun'
require './lib/event_reporter.rb'

class EventReporterTest < Minitest::Test
  def setup
    @rep = EventReporter.new
    @rep.file = @rep.load_file("event_attendees.csv")
  end

  def test_file_is_read
    assert_equal CSV, @rep.file.class
  end

  def test_find_works
    @rep.find('first_name', 'mary')
    assert_equal 16, @rep.queue.count
  end

  def test_queue_count
    @rep.find('first_name', 'mary')
    result = @rep.queue_count
    message = "16 records in the queue"
    assert_equal result, message
  end

  def test_row_parsing
    row = {" "=>"1",
           "regdate"=>"11/12/08 10:47",
           "first_name"=>"Allison",
           "last_name"=>"Nguyen",
           "email_address"=>"arannon@jumpstartlab.com",
           "homephone"=>"6154385000",
           "street"=>"3155 19th St NW",
           "city"=>"Washington",
           "state"=>"DC",
           "zipcode"=>"20010"}
    parsed = ["Nguyen", "Allison", "arannon@jumpstartlab.com", "20010",
              "Washington", "DC", "3155 19th St NW", "6154385000"]
    result = @rep.data(row)
    assert_equal result, parsed
  end

  def test_queue_clear
    @rep.find('first_name', 'mary')

    assert_equal 16, @rep.queue.count

    @rep.queue_clear

    assert_equal 0, @rep.queue.count
  end








end
