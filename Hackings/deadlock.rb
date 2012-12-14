#!/usr/bin/ruby -w

require 'thread'

m = Mutex.new
n = Mutex.new

Thread.new do
    m.lock
    sleep 1
    n.lock
end

n.lock
m.lock
