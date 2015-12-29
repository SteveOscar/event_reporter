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
      CSV.open "lib/#{path}", headers: true
    else
      CSV.foreach "lib/event_attendees.csv", headers: true, :header_converters => :downcase
    end
  end

  def queue_count
    # (@queue.nil?) ? (puts "#{@file.count} records") : (puts "#{@queue.count} records")
    puts "#{@queue.count} records in the queue"
  end

  def find(attribute, criteria)
    @queue = []
    @queue << @file.first.to_h.keys
    binding.pry
    @file.each do |row|
      @queue << row.to_h.values if row[attribute].downcase == criteria.downcase
    end
    puts "#{@queue.count} matching records found"
  end

  def help
    print "commands: load <filename>, help, help <specific command>, queue count, queue print,"
    print "queue print by <attribute>, queue save to <filename>, find <attribute> <criteria>, queue clear"
  end

  def queue_print
    puts Terminal::Table.new :rows => @queue
  end

  # def print_row(row)
  #   puts "#{row['last_name']}    " + "#{row['first_name']}    " + "#{row['email_address']}    " + "#{row['zipcode']}    "
  # end

  def queue_clear
    @queue = []
    puts "queue cleared to 0 records"
  end

  def print_by(attribute)
    @queue.sort_by!{ |hash| hash[attribute] }
    binding.pry
    @queue.each { |row| puts row.values.join('  ') }
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
