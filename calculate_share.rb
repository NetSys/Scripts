#!/usr/bin/env ruby

if ARGV.length != 2
  puts "Usage: #{$0} <static> <dynamic>"
  exit 1
end

static = ARGV.shift.to_f
dynamic = ARGV.shift.to_f

my_contribution = 0.3
total_dollars = static + dynamic

# Weighted average of a full share:
my_share = (my_contribution * (dynamic / total_dollars)) + (static / total_dollars)

puts "My share #{my_share}"
