#!/usr/bin/ruby1.9 -w

linecount = 0
input = File.foreach("#{ARGV[0]}") do
	linecount += 1
end

output = File.open("#{ARGV[0]}.name", "w+")

linecount.times do
	output.print("#{ARGV[0]}\n")
end

