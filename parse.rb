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
    # Note the date as yyyy.mm.dd
    date = $1
    # Starting a new day, push previous day onto the hash of days
    if (!text_lines.empty?)
      # Push array of log lines into the hash
      date_logs[date] = text_lines
    end

    # Reset the array of lines for this day
    text_lines = []
  else
    # NOT a date line, so push it on the running array of lines for today
    text_lines.push(line.strip)
  end
end

# Print out the results
date_logs.each do |date, lines|
  #puts "   " + date
  #puts lines
end
