# Description
#   A hubot script that provides timers and countdowns
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Ryan McDonough <rmcdono@transunion.com>

module.exports = (robot) ->
  robot.respond /countdown (\d+)/i, (res) ->
    countdownDuration =  res.match[1]
    res.reply "there are #{countdownDuration} seconds remaining!"

  robot.respond /countdown help/i, (res) ->
    countdownDuration =  res.match[1]
    helpMessages =
      ['countdown <seconds> - Sets a timer for <seconds>',
       'countdown <name> <seconds> - Sets a timer with <name> for <seconds>']
    for message in helpMessages
      res.send message
