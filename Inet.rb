module Inet
    $PRIVATE_PREFIXES=[["192.168.0.0",16], ["10.0.0.0",8], ["127.0.0.0",8], ["172.16.0.0",12], ["169.254.0.0",16], ["224.0.0.0",4]]
    

		# converts the integer representation of an IP address into the
		# dotted string notation
    def Inet::ntoa( intaddr )
        ((intaddr >> 24) & 255).to_s + '.' + ((intaddr >> 16) & 255).to_s + '.'  + ((intaddr >> 8) & 255).to_s + '.' + (intaddr & 255).to_s
    end
        
		# converts IP address in dotted string format to its binary representation,
		# and returns the integer that those bits represent 
    def Inet::aton(dotted)
        ints=dotted.chomp("\n").split(".").collect{|x| x.to_i}
        val=0
        ints.each{|n| val=(val*256)+n}
        return val
    end
    
		# This function takes two parameters: an IP address (in either integer
		# form or dotted decimal notation form,  and a length of the prefix.
		# It returns the prefix of that IP address in integer form.
    def Inet::prefix(ip,length)
        ip=Inet::aton(ip) if  ip.is_a?(String) and ip.include?(".")
        return ((ip>>(32-length))<<(32-length))
    end
    
		# This function returns whether or not the IP address (in either format) is private.    
    def Inet::in_private_prefix?(ip)
        ip=Inet::aton(ip) if  ip.is_a?(String) and ip.include?(".")
        $PRIVATE_PREFIXES.each do |prefix|
						# convert prefix to integer (why did he use Arrays?)
            pref=Inet::aton(prefix.at(0))
						# isn't the previous line unnecessary, since he never uses "pref" again?
						# and he's converting again to integer in the line below?
            return true if Inet::aton(prefix.at(0))==Inet::prefix(ip,prefix.at(1))
        end
        return false
    end
end 
