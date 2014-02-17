#!/usr/bin/env ruby

CMD = lambda do |title, message|
  "osascript -e 'tell app \"System Events\" to display alert \"#{title}\" as critical message \"#{message}\"'"
end

TITLE   = ARGV[0]      || "Alert!"
MESSAGE = ARGV[1]      || ""
SLEEP   = ARGV[2].to_i || 1

sleep(SLEEP)
system(CMD[TITLE,MESSAGE])
