local mp = require 'mp'

mp.msg.info("loaded")
mp.command("script-message osc-visible")

mp.add_periodic_timer(1, function()
    mp.command("script-message osc-visible")
end)

mp.add_periodic_timer(2, function()
   --mp.msg.info("Still running...")
end)
