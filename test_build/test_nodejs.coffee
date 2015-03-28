{log} = require 'coffee-mate'
require '../build/global.coffee.js'

plus = (a, b) -> a + b
fibs =
	cons(0) cons(1) (zipWith(plus) (lazy -> do fibs), (drop(1) (lazy -> do fibs)))

circle = (ls) ->
	lazy -> do
		concat ls, circle ls

reps = (x) ->
	lazy -> do
		cons(x) reps(x)

#log -> list take(1000) circle [1]
log -> last take(1000) reps(1)
log -> last take(20) fibs

#fibs = lazy -> do
#	concat [0, 1], (zipWith(plus) fibs, (drop(1) fibs))
#

