#!/usr/bin/ruby1.9 -w
#
#
require 'time'

t = Time.new
test = "128.3.3.3 12 129.2.2.2 129.2.2.2 129.2.2.2 129.2.2.2 129.2.2.2 129.2.2.2 129.2.2.2 129.2.2.2 129.2.2.2"

1000000.times { |i| test.split[0]  }

r = Time.new

puts t - r


t = Time.new

1000000.times { |i| test.slice(0,test.index(' ')) }

r = Time.new

puts t - r
