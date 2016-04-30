require 'irb/completion'
require 'irb/ext/save-history'
require 'pp'
require 'awesome_print'
AwesomePrint.irb!

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
