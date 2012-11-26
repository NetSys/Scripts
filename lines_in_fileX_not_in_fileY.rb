#!/usr/bin/ruby1.9 -w

require 'set'

all = Set.new
File.foreach(ARGV[0]) do |line|
    all.add line.chomp
end

forw = Set.new
File.foreach(ARGV[1]) do |line|
    forw.add line.chomp
end

all.each do |link|
    puts link unless(forw.include?(link))
end
