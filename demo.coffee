{log} = require 'coffee-mate'
require './src/global'

plus = (a, b) -> a + b
fibs =
	cons(0) cons(1) (zipWith(plus) (lazy -> do fibs), (drop(1) (lazy -> do fibs)))

circle = (ls) ->
	lazy -> do
		concat ls, circle ls

reps = (x) ->
	lazy -> do
		cons(x) reps(x)

log -> list take(10) circle [1, 2, 3]
log -> list take(10) reps(1)
log -> list take(10) fibs

