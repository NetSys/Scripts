#!/usr/bin/ruby1.9 -w

require 'set'

ips = Set.new

ARGV.each do |file|
    File.foreach(file) do |line|
        #puts line.chomp if ips.include?(line.chomp)
        ips.add line.chomp
    end
end

ips.each do |ip|
    puts ip
end
