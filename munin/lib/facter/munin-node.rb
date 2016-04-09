# Custom Fact for Munin
# Need Pluginsync on hosts configuration
#

# has_munin_node : 
# return True if exist
# 
Facter.add(:has_munin_node) do
    confine :kernel => [ 'Linux' , 'SunOS' , 'FreeBSD' , 'Darwin' ]
    setcode do
        if File.exist? "/usr/sbin/munin-node"
            output = "true"
        else
            output = "false"
        end
        output
    end
end
