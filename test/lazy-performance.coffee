describe 'performance', ->

	it 'takes less than 20ms to process 1e6 items', ->
		log -> all((x) -> x >= 0) range(1e6)
		log -> all((x) -> x >= 0) take(1e6) naturals

	it 'takes not much time while using single recursive definition', ->
		rec_reps = (x) ->
			lazy -> do
				cons(x) rec_reps(x)

		for times in [0..2]
			log -> all((x) -> x >= 0) take(1e3) repeat(1)
			log -> all((x) -> x >= 0) take(1e3) rec_reps(1)

	it 'takes not much time while using multi recursive definition', ->
		rec_fibs = lazy -> do
			cons(0) cons(1) (zipWith(plus) rec_fibs, (drop(1) rec_fibs))

		fibs = map(([a, b]) -> a) generate [0, 1], ([a, b]) -> [b, a + b]

		for times in [0..2]
			log -> last take(15) rec_fibs
			log -> last take(1000) fibs

