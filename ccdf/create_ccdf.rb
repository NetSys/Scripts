#!/usr/bin/ruby1.9 -w

# This is to create the x axis of a ccdf graph, where the x axis
# corresponds to the percentage of probes that recieved responses.
# This was done for the rate-limiting to naming-convention correlation
# study.

if ARGV.size < 2
  print "Usage: ", $0, " [data file] [number of probes] \n"
  exit
end

input = File.open(ARGV[0])
outname = ARGV[0] + ".ccdf"
output = File.open(outname, "w+")

while line = input.gets
	array = line.split(' ')
	#The format is [IP] [Responses]
	#So I want the percentage of responses
	#which is Responses * 1.0 / The number of probes sent
	value = (Integer(array[1]) * 1.0 / Integer(ARGV[1])) 

	#cap value at 100 and round down to zero
	if value > 1.0
		value = 1.0
	elsif value < 0.001
		value = 0
	end

	output.puts(value)
end
