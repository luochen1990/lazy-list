describe 'recursive', ->
	plus = (a, b) -> a + b

	it 'fibs-via-cons', ->
		fibs = lazy -> do
			cons(0) cons(1) (zipWith(plus) fibs, (drop(1) fibs))

		assertEqOn(json) (-> list take(8) fibs), (-> [0, 1, 1, 2, 3, 5, 8, 13])

	it 'fibs-via-concat', ->
		fibs = lazy -> do
			concat [[0, 1], (zipWith(plus) fibs, (drop(1) fibs))]

		assertEqOn(json) (-> list take(8) fibs), (-> [0, 1, 1, 2, 3, 5, 8, 13])

	it 'fibs-via-streak', ->
		fibs = lazy -> do
			cons(0) cons(1) map(([a, b]) -> a + b) streak(2) fibs

		assertEqOn(json) (-> list take(8) fibs), (-> [0, 1, 1, 2, 3, 5, 8, 13])
		#log -> last take(100) fibs

	it 'circle-via-concat', ->
		circle = (ls) ->
			lazy -> do
				concat [ls, circle(ls)]

		assertEqOn(json) (-> list take(8) circle [1, 2, 3]), (-> [1, 2, 3, 1, 2, 3, 1, 2])

