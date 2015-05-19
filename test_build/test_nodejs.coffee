{log} = require 'coffee-mate'

Lz = require '../build/lazy.js'
log -> Object.keys(Lz).join()

require '../global.js'

plus = (a, b) -> a + b
fibs =
	cons(0) cons(1) (zipWith(plus) (lazy -> do fibs), (drop(1) (lazy -> do fibs)))

circle = (ls) ->
	lazy -> do
		concat [ls, circle ls]

reps = (x) ->
	lazy -> do
		cons(x) reps(x)

log -> last take(1000) circle [1, 2, 3, 4]
log -> last take(1000) reps(1)
log -> last take(20) fibs
log -> last []
log -> head []

