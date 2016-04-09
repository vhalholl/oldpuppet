# Custom Fact for Postfix
# Need Pluginsync on hosts configuration
#

# has_aliases : 
# return True if /etc/aliases exist
# 
Facter.add(:has_aliases) do
    confine :kernel => [ 'Linux' , 'SunOS' , 'FreeBSD' , 'Darwin' ]
    setcode do
        #if Facter::Util::Resolution.exec('/usr/bin/test -f /etc/aliases')
        if File.exist? "/etc/aliases"
            output = "true"
        else
            output = "false"
        end
        output
    end
end

# has_aliases_root :
# return True if has_aliases return true and root alias is already set
#
Facter.add(:has_aliases_root) do
    confine :has_aliases => "true"
    setcode do
        if Facter::Util::Resolution.exec("grep 'root:' /etc/aliases")
            output = "true"
        else
            output = "false"
        end
        output
    end
end
