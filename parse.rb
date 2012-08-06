require 'date'

# Get the file (first argument to the script)
path = ARGV[0]
if (!path || path.empty?)
  puts "Usage: ruby parse.rb <path to file>"
  exit
# Make sure the file exists
elsif (!File.exists?(path))
  puts "File does not exist."
  exit
end


# Initialize variables
date = ''
date_logs = {}
text_lines = []

# Loop over the lines in the Daily text file
File.open(path).each do |line|
  # Check if the line is a date line
  if (line =~ /([0-9]{4}\.[0-9]{2}\.[0-9]{2})(.*)/)
    # Starting a new day: push previous day notes onto the hash of days
    if (!text_lines.empty?)
      # Push array of log lines into the hash
      date_logs[date] = text_lines
    end

    # Save the date for the next set of lines. The format is yyyy.mm.dd
    date = $1

    # Reset the array of lines for this day
    text_lines = []
  else
    # NOT a date line
    # Escape any quotes so that newlines can be printed in an echo "" later
    clean_line = line.gsub(/"/, '\"')
    # Trim whitespace and push it on the running array of lines for today
    text_lines.push(clean_line.strip)
  end
end

# Run the results through the dayone command
date_logs.each do |date, lines|
  # Format the date for Day One. Assume it was written at 10pm
  d = DateTime.parse(date + ' 10:00 pm');
  print_date = d.strftime("%m/%d/%Y %l:%M%p") # dayone formatted

  # Join the lines for the day
  input = lines.join("\n").strip;

  # Execute the command
  %x{echo "#{input}"|/usr/local/bin/dayone -d="#{date}" new}
end
