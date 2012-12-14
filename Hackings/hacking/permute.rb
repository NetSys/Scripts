#!/usr/bin/ruby

def permute(str)
    helper(str.to_a, [])
end

def helper(rest, chosen)
    if rest.empty?
        puts chosen.join ' '
    else
        rest.each_with_index do |e, i|
            rest_prime = rest[0...i] + rest[(i+1)..-1]
            val = rest[i]
            helper(rest_prime, chosen + [val])
        end
    end
end

permute([1,2,3])
