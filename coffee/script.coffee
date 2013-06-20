$ = jQuery

class Bot
	constructor: ->
		canvas = document.getElementById 'container'
		@context = canvas.getContext '2d'
		@x = 1
		@y = 1
		@faceAngle = 0

	drawBot: ->
		@context.clearRect 0, 0, 1500, 1500
		@context.lineWidth = 2
		@context.strokeStyle = 'green'
		@context.strokeRect @x, @y, 2, 1

	strafeRight: ->
		@x++

	strafeLeft: ->
		@x--

	turnRight: ->
		@faceAngle+=8
		@faceAngle = 0 if @faceAngle >= 360

	turnLeft: ->
		@faceAngle-=8
		@faceAngle = 359 if @faceAngle < 0

	forward: ->
		@x+= Math.cos(@faceAngle * Math.PI/180)
		@y+= Math.sin(@faceAngle * Math.PI/180)

	backward: ->
		@x-= Math.cos(@faceAngle * Math.PI/180)
		@y-= Math.sin(@faceAngle * Math.PI/180)

class BotController
	constructor: (bot) ->
		map = {}
		forwardTrigger = $.Event 'keydown'
		console.log forwardTrigger
		forwardTrigger.which = 87
		$(document).bind 'key keydown', (e) ->
			map[e.keyCode] = true
			BotController.move(bot, map)
		$(document).bind 'key keyup', (e) ->
			map[e.keyCode] = false
			BotController.move(bot, map)
			$(document).trigger forwardTrigger if map[87]

	@move:(bot, map) ->
		console.log map
		if map[69]
			bot.strafeRight() 
			$.ajax
			  url: "127.0.0.1:8071/motion-control/update"
			  data: strafe: 1
			  dataType: jsonp

		if map[81]
			bot.strafeLeft() 
			$.ajax
			  url: "127.0.0.1:8071/motion-control/update"
			  data: strafe: -1
			  dataType: jsonp

		if map[68]
			bot.turnRight()
			$.ajax
			  url: "127.0.0.1:8071/motion-control/update"
			  data: turn: 1
			  dataType: jsonp
		if map[65]
			bot.turnLeft()
			$.ajax
			  url: "127.0.0.1:8071/motion-control/update"
			  data: turn: -1
			  dataType: jsonp 

		if map[87]
			bot.forward()
			$.ajax
			  url: "127.0.0.1:8071/motion-control/update"
			  data: forward: 1
			  dataType: jsonp 
		if map[83]
			bot.backward()
			$.ajax
			  url: "127.0.0.1:8071/motion-control/update"
			  data: forward: -1
			  dataType: jsonp 
		bot.drawBot()


$(document).ready ->
 bot = new Bot
 bot.drawBot()
 botControl = new BotController(bot)
