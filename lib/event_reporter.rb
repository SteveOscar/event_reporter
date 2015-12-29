require 'csv'
require 'pry'
require 'terminal-table'

class EventReporter
  attr_reader :file, :queue

  def initialize
    @queue = []
    @file = []
  end

  def load_file(path)
    if File.exist?("lib/#{path}")
      CSV.open "lib/#{path}", headers: true, :header_converters => :downcase
    else
      CSV.foreach "lib/event_attendees.csv", headers: true, :header_converters => :downcase
    end
  end

  def queue_count
    puts "#{@queue.count} records in the queue"
  end

  def find(attribute, criteria)
    @queue = []
    @file.each do |row|
      @queue << [row.to_h["last_name"], row.to_h["first_name"], row.to_h["email_address"], row.to_h["zipcode"], row.to_h["city"], row.to_h["state"], row.to_h["street"], row.to_h["homephone"]] if row[attribute].downcase == criteria.downcase
    end
    puts "#{@queue.count} matching records found"
  end

  def help
    print "commands: load <filename>, help, help <specific command>, queue count, queue print,"
    print "queue print by <attribute>, queue save to <filename>, find <attribute> <criteria>, queue clear"
  end

  def queue_print
    puts Terminal::Table.new :headings => ['Last Name', 'First Name', 'Email', 'Zipcode', 'City', 'State', 'Address', 'Phone'], :rows => @queue
  end

  def queue_clear
    @queue = []
    puts "queue cleared to 0 records"
  end

  def print_by(attribute)
    @queue.sort_by { |last_name, first_name, email, zipcode, city, state, address, phone| attribute }
  end

  def main
    puts "Issue next Event Reporter command..."
    command = gets.chomp.downcase
    @file = load_file(command.split(" ").last) if command.include?('load')
    find(command.split(" ")[1], command.split(" ").last) if command.include?('find')
    print_by(command.split(" ").last)if command.include?('queue print by')
    case command
    when 'queue count' then queue_count
    when 'help' then help
    when 'queue print' then queue_print
    when 'queue clear' then queue_clear
    end
  end

  # load <filename>
  # help
  # help <command>
  # queue count
  # queue print
  # queue print by <attribute>
  # queue save to <filename>
  # find <attribute> <criteria>

end
rep = EventReporter.new

loop do
  rep.main
end
