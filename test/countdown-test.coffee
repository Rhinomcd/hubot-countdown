Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/countdown.coffee')

describe 'countdown', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'responds to countdown', ->
    @room.user.say('alice', '@hubot countdown 60').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot countdown 60']
        ['hubot', '@alice there are 60 seconds remaining!']
      ]

  it 'responds to COUNTDOWN', ->
    @room.user.say('alice', '@hubot COUNTDOWN 60').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot COUNTDOWN 60']
        ['hubot', '@alice there are 60 seconds remaining!']
      ]

  it 'responds to help', ->
    @room.user.say('alice', '@hubot countdown help').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot countdown help']
        ['hubot', 'countdown <seconds> - Sets a timer for <seconds>']
        ['hubot', 'countdown <name> <seconds> - Sets a timer with <name> for <seconds>']
      ]
