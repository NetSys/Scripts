#!/usr/bin/ruby1.9 -w
#

require '~/colin/Scripts/classes+modules/usage_check.rb'

Check::arguments(1,  "[File to be counted]")

counts = 0
File.foreach(ARGV[0]) do |line|
	counts += 1
end

puts counts
