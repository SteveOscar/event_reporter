require 'minitest'
require 'minitest/autorun'
require 'event_reporter.rb'

class EventReporterTest < Minitest::Test

  def test_file_is_read
    rep = EventReporter.new
    file = rep.load_file("event_attendees.csv")

    assert_equal CSV, file.class
  end


end
