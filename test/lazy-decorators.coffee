describe 'decorators', ->

	describe 'cons', ->
		it '(cons(nil) nil) is empty', ->
			assertEq (-> length cons(nil) nil), (-> 0)
		it '(cons(1) nil) is lazy [1]', ->
			assertEqOn(every_one) (-> cons(1) nil), (-> [1])
		it 'can be used to define lazy list recursively', ->
			another_repeat = (x) ->
				lazy -> do
					cons(x) another_repeat(x)
			assertEqOn(json) (-> list take(3) another_repeat(1)), (-> [1, 1, 1])

	describe 'map', ->
		inc = (x) -> x + 1

		it 'map(f) given nil returns empty lazy list', ->
			assertEq (-> length map(inc) nil), (-> 0)
		it 'map(f) given [] returns empty lazy list', ->
			assertEq (-> length map(inc) []), (-> 0)
		it 'did mapped every elements', ->
			assertEqOn(json) (-> list map(inc) [1, 1, 1]), (-> [2, 2, 2])
			assertEqOn(json) (-> list map(inc) range(1, 10)), (-> list range(2, 11))

	describe 'filter', ->
		positive = (x) -> x > 0

		it 'filter(f) given nil returns empty lazy list', ->
			assertEq (-> length filter(positive) nil), (-> 0)
		it 'filter(f) given [] returns empty lazy list', ->
			assertEq (-> length filter(positive) []), (-> 0)
		it 'filter(f) given xs returns all x which makes f(x) to be true', ->
			assertEq (-> length filter(positive) [-1, -2, -3]), (-> 0)
			assertEqOn(every_one) (-> filter(positive) [1, 2, -3, 4, -5, 6]), (-> [1, 2, 4, 6])
			assertEqOn(every_one) (-> filter(positive) [1, 2, 3]), (-> [1, 2, 3])
		it 'do nothing with nil', ->
			r = []
			ls = list filter((x) -> (r.push x); true) range(2)
			assert -> r.length == 2
			assertEqOn(every_one) (-> r), (-> [0, 1])

	describe 'take', ->
		it '(take(0) xs) returns empty list', ->
			assertEq (-> length take(0) naturals), -> 0
		it '(take(n) xs) returns list with first n x', ->
			assertEqOn(json) (-> list take(1) naturals), -> [0]
			assertEqOn(json) (-> list take(3) naturals), -> [0, 1, 2]
		it '(take(n) xs) returns xs if length xs <= n', ->
			assertEq (-> length take(1) nil), -> 0
			assertEqOn(json) (-> list take(10) range(1)), -> [0]
			assertEqOn(json) (-> list take(10) range(3)), -> [0, 1, 2]

	describe 'takeWhile', ->
		positive = (x) -> x > 0

		it 'may returns empty list', ->
			assertEq (-> length takeWhile(-> false) naturals), -> 0
		it 'returns first n ok elements', ->
			assertEqOn(json) (-> list takeWhile(positive) [-1, 1]), -> []
			assertEqOn(json) (-> list takeWhile(positive) [1, -2, 3]), -> [1]
		it 'returns all if all ok', ->
			assertEqOn(json) (-> list takeWhile(positive) [1, 2, 3]), -> [1, 2, 3]

	describe 'drop', ->
		it 'drop(0) do nothing with xs', ->
			assertEqOn(json) (-> list take(2) drop(0) naturals), -> [0, 1]
		it 'drop(n) ignores n elements', ->
			assertEqOn(json) (-> list take(2) drop(1) naturals), -> [1, 2]
			assertEqOn(json) (-> list take(2) drop(2) naturals), -> [2, 3]
			assertEqOn(json) (-> list take(2) drop(100) naturals), -> [100, 101]

	describe 'dropWhile', ->
		positive = (x) -> x > 0

		it 'may returns empty list', ->
			assertEq (-> length takeWhile(-> false) naturals), -> 0
		it 'returns first n ok elements', ->
			assertEqOn(json) (-> list takeWhile(positive) [-1, 1]), -> []
			assertEqOn(json) (-> list takeWhile(positive) [1, -2, 3]), -> [1]
		it 'returns all if all ok', ->
			assertEqOn(json) (-> list takeWhile(positive) [1, 2, 3]), -> [1, 2, 3]

	describe 'scanl', ->
		it 'scanl(f, x) nil returns x', ->
			assertEq (-> last scanl(plus)(3) nil), -> 3
		it 'scanl(plus, 0) [1..5] returns [0, 1 ... 15]', ->
			assertEqOn(json) (-> list scanl(plus)(0) range(1, 6)), -> [0, 1, 3, 6, 10, 15]

	describe 'streak', ->
		it 'streak(n) nil returns empty list', ->
			assertEq (-> length streak(3) nil), -> 0
		it 'streak(0) [0, 1, 2] returns []', ->
			assertEqOn(json) (-> list streak(0) range(3)), (-> [])
		it 'streak(1) [0, 1, 2] returns [[0], [1], [2]]', ->
			assertEqOn(json) (-> list streak(1) range(3)), (-> [[0], [1], [2]])
		it 'streak(2) [0, 1, 2] returns [[0, 1], [1, 2]]', ->
			assertEqOn(json) (-> list streak(2) range(3)), (-> [[0, 1], [1, 2]])
		it 'streak(3) [0, 1, 2] returns [[0, 1, 2]]', ->
			assertEqOn(json) (-> list streak(3) range(3)), (-> [[0, 1, 2]])

	describe 'reverse', ->
		it 'given empty list returns empty list', ->
			assertEq (-> length reverse nil), -> 0
			assertEq (-> length reverse (lazy -> do nil)), -> 0
		it 'reverse [0..4] returns [4..0]', ->
			assertEqOn(json) (-> list reverse range(5)), (-> [4, 3, 2, 1, 0])

	describe 'sort', ->
		it 'given [] returns []', ->
			assertEq (-> length sort nil), -> 0
		it 'sort numbers correctly', ->
			assertEqOn(every_one) (-> sort [1, 3, 4, 2, 2]), (-> [1, 2, 2, 3, 4])
			assertEqOn(every_one) (-> sort [10, 3, 4, 2, 2]), (-> [2, 2, 3, 4, 10])

	describe 'sortOn', ->
		identity = (x) -> x
		negative = (x) -> -x

		it 'given [] returns []', ->
			assertEq (-> length sortOn(identity) nil), -> 0
		it 'sort numbers correctly', ->
			assertEqOn(every_one) (-> sortOn(negative) [1, 3, 4, 2, 2]), (-> [4, 3, 2, 2, 1])

