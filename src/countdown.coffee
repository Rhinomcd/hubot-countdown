# Description
#   A hubot script that provides timers and countdowns
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot countdown <seconds> - Sets a timer for <seconds>'
#   hubot countdown <name> <seconds> - Sets a timer with <name> for <seconds>'
#
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Ryan McDonough <rmcdono@transunion.com>

moment = require('moment')
cron = require('node-schedule')

module.exports = (robot) ->
  robot.respond /countdown (\d+)/i, (res) ->
    countdownDuration =  res.match[1]
    res.reply "there are #{countdownDuration} seconds remaining!"

  robot.respond /countdown help/i, (res) ->
    countdownDuration =  res.match[1]
    helpMessages = [
      'countdown set <name> <Time HHmm> - sets a countdown for an Event'
      'countdown get <eventName> - gets the start time for an Event'
    ]
    for message in helpMessages
      res.send message

  robot.respond /countdown set (\w+) (\d{4})/i, (res) ->
    eventName = res.match[1]
    eventTime = moment(res.match[2],'HHmm')
    rule = new cron.RecurrenceRule()
    rule.minute = 0

    eventCron = cron.scheduleJob(rule, () ->
      timeUntilEvent = eventTime.fromNow()
      res.send("#{eventName} will begin #{timeUntilEvent}!")
    )
    event = new Event(eventName, eventTime, eventCron)

    robot.brain.set(eventName, event)
    res.reply "Got it! #{eventName} will begin at #{eventTime.format('h:mmA')}!"

  robot.respond /countdown get (\w+)/, (res) ->
    eventName = res.match[1]
    event = robot.brain.get(eventName)
    console.log(event)
    if event?
      eventTime = event.time.format('h:mmA')
      res.reply "Looks like #{eventName} starts at #{eventTime}"
    else
      res.reply "I couldn't find an event named #{eventName}"

  robot.respond /countdown change (\w+) (\d{4})/, (res) ->
    eventName = res.match[1]
    eventTime = moment(res.match[2],'HHmm')
    event = robot.brain.get(eventName)
    if event?
      event.time = eventTime
    else
      res.reply "I couldn't find an event named #{eventName}"
    res.reply "Got it! #{eventName} has been updated to start at #{eventTime.format('h:mmA')}"

  robot.respond /countdown remove (\w+)/, (res) ->
    eventName = res.match[1]
    event = robot.brain.get(eventName)
    if event?
      event.cron.cancel()
      robot.brain.remove(eventName)
      res.reply "Removed #{eventName} from the schedule"
    else
      res.reply "I couldn't find an event named #{eventName}"

  cron.scheduleJob('* * * * *', () ->
    console.log(robot.brain)
  )
  console.log('job scheduled')

class Event
  constructor: (@name, @time, @cron) ->
