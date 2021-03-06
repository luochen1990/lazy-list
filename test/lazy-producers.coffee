describe 'producers', ->

	describe 'lazy', ->
		it 'given function works as alias of lazylist', ->
			assert -> (lazy (-> do nil))[Symbol.iterator]?
			assertEq (-> length lazy (-> do nil)), -> 0
		it 'given array returns an iterator', ->
			assertEq (-> length lazy []), -> 0
			assert -> (lazy [1, 2, 3])[Symbol.iterator]?
			assertEqOn(every_one) (-> lazy [1, 2, 3]), -> [1, 2, 3]
			arr = [{}, {}, {}]
			assertEqOn(every_one) (-> lazy arr), -> arr

	describe 'enumerate', ->
		it 'given nil or [] or {} returns empty', ->
			assertEq (-> length enumerate nil), -> 0
			assertEq (-> length enumerate []), -> 0
			assertEq (-> length enumerate {}), -> 0
		it 'given ["a", "b"] returns [[0, "a"], [1, "b"]]', ->
			assertEqOn(json) (-> list enumerate ["a", "b"]), -> [[0, "a"], [1, "b"]]
		#it 'given "ab" returns [[0, "a"], [1, "b"]]', ->
		#	assertEqOn(json) (-> list enumerate "ab"), -> [[0, "a"], [1, "b"]]
		it 'given range(10, 12) returns [[0, 10], [1, 11]]', ->
			assertEqOn(json) (-> list enumerate range(10, 12)), -> [[0, 10], [1, 11]]

	describe 'repeat', ->
		it 'repeats number', ->
			assertEqOn(every_one) (-> take(3) repeat(9)), (-> [9, 9, 9])
			assertEqOn(every_one) (-> take(2) repeat(0)), (-> [0, 0])
		it 'repeats string', ->
			assertEqOn(every_one) (-> take(3) repeat('a')), (-> ['a', 'a', 'a'])
		it 'repeats object', ->
			obj = {x: 1}
			assertEqOn(every_one) (-> take(2) repeat obj), (-> [obj, obj])
		it 'repeats function', ->
			f = ->
			assertEqOn(every_one) (-> take(2) repeat f), (-> [f, f])

	describe 'iterate', ->
		it 'defines fast fibs', ->
			fibs = map(([a, b]) -> a) iterate (([a, b]) -> [b, a + b]), [0, 1]
			assertEqOn(json) (-> list take(8) fibs), -> [0, 1, 1, 2, 3, 5, 8, 13]

	describe 'randoms', ->
		it 'generate decimal numbers between [0, 1)', ->
			assert -> all((x) -> 0 <= x < 1) take(100) randoms()
		it 'generate the same sequence when given the same seed', ->
			assertEqOn(json) (-> list take(10) randoms(seed: 3)), (-> list take(10) randoms(seed: 3))
			assertEqOn(json) (-> list take(10) randoms(range: 5, seed: 3)), (-> list take(10) randoms(range: 5, seed: 3))
		it 'given {range: n} generate integers between [0, n)', ->
			assert -> all((x) -> 0 <= x < 5) take(100) randoms(range: 5)
		it 'generate different sequences with different seed', ->
			assert -> (json list take(10) randoms(1)) isnt (json list take(10) randoms(2))
			assert -> (json list take(10) randoms(range: 5, seed: 1)) isnt (json list take(10) randoms(range: 5, seed: 2))
		it 'zipped correctly', ->
			assert -> all((x) -> not isNaN x) head zip randoms(range: 14, seed: 1), randoms(4)
			assert -> all((x) -> not isNaN x) head zip randoms(range: 14, seed: 1), randoms(seed: 4)
			assert -> all((x) -> not isNaN x) head zip randoms(range: 14, seed: 1), randoms(range: 14, seed: 1)
		it 'distributed reasonable', ->
			assert -> any((x) -> 0.00 <= x < 0.33) take(100) randoms()
			assert -> any((x) -> 0.33 <= x < 0.66) take(100) randoms()
			assert -> any((x) -> 0.66 <= x < 1.00) take(100) randoms()
			assert -> all((x) -> 0 <= x < 1.00) take(100) randoms()
			assert -> all((x) -> 0 <= x < 1.00) take(100) randoms(seed: 2)
			assert -> any((x) -> x is 0) take(100) randoms(range: 3)
			assert -> any((x) -> x is 1) take(100) randoms(range: 3)
			assert -> any((x) -> x is 2) take(100) randoms(range: 3)
			assert -> any((x) -> x is 1) take(100) randoms(range: [1, 2])
			assert -> any((x) -> x is 2) take(100) randoms(range: [1, 2])

	describe 'permutations', ->
		it 'given [] returns empty', ->
			assertEqOn(json) (-> list permutations []), -> []
		it 'given [1] returns [[1]]', ->
			assertEqOn(json) (-> list permutations [1]), -> [[1]]
		it 'given [1, 2] returns [[1, 2], [2, 1]]', ->
			assertEqOn(json) (-> list permutations [1, 2]), ->  [[1, 2], [2, 1]]
		it 'given [1, 1, 2] returns [[ 1, 1, 2 ], [ 1, 2, 1 ], [ 2, 1, 1 ]]', ->
			#log -> json list permutations [1, 1, 2]
			assertEqOn(json) (-> list permutations [1, 1, 2]), ->  [[1,1,2],[1,2,1],[2,1,1]]
		it 'given [1, 3, 3, 1] returns ...', ->
			#log -> json list permutations [1, 3, 3, 1]
			assertEqOn(json) (-> list permutations [1, 3, 3, 1]), ->  [[1,3,3,1],[3,1,1,3],[3,1,3,1],[3,3,1,1],[1,1,3,3],[1,3,1,3]]
			
