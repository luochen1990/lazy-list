describe 'decorators', ->

	describe 'cons', ->
		it '(cons(nil) nil) is empty', ->
			assertEq (-> last cons(nil) nil), (-> nil)
		it '(cons(1) nil) is lazy [1]', ->
			assertEqOn(every_one) (-> cons(1) nil), (-> [1])
		it 'can be used to define lazy list recursively', ->
			another_repeat = (x) ->
				lazy -> do
					cons(x) another_repeat(x)
			assertEqOn(json) (-> list take(3) another_repeat(1)), (-> [1, 1, 1])

	describe 'concat', ->
		it 'concat(nil) nil returns empty', ->
			assertEq (-> last concat(nil) nil), -> nil
		it 'concat([1]) nil) returns lazy [1]', ->
			assertEqOn(every_one) (-> concat([1]) nil), (-> [1])
		it 'concat(nil) [1]) returns lazy [1]', ->
			assertEqOn(every_one) (-> concat(nil) [1]), (-> [1])

	describe 'map', ->
		inc = (x) -> x + 1

		it 'map(f) given nil returns empty lazy list', ->
			assertEq (-> last map(inc) nil), (-> nil)
		it 'map(f) given [] returns empty lazy list', ->
			assertEq (-> last map(inc) []), (-> nil)
		it 'did mapped every elements', ->
			assertEqOn(json) (-> list map(inc) [1, 1, 1]), (-> [2, 2, 2])
			assertEqOn(json) (-> list map(inc) range(1, 10)), (-> list range(2, 11))

	describe 'filter', ->
		positive = (x) -> x > 0

		it 'filter(f) given nil returns empty lazy list', ->
			assertEq (-> last filter(positive) nil), (-> nil)
		it 'filter(f) given [] returns empty lazy list', ->
			assertEq (-> last filter(positive) []), (-> nil)
		it 'filter(f) given xs returns all x which makes f(x) to be true', ->
			assertEq (-> last filter(positive) [-1, -2, -3]), (-> nil)
			assertEqOn(every_one) (-> filter(positive) [1, 2, -3, 4, -5, 6]), (-> [1, 2, 4, 6])
			assertEqOn(every_one) (-> filter(positive) [1, 2, 3]), (-> [1, 2, 3])

	describe 'take', ->
		it '(take(0) xs) returns empty list', ->
			assertEq (-> last take(0) naturals), -> nil
		it '(take(n) xs) returns list with first n x', ->
			assertEqOn(json) (-> list take(1) naturals), -> [0]
			assertEqOn(json) (-> list take(3) naturals), -> [0, 1, 2]
		it '(take(n) xs) returns xs if length xs <= n', ->
			assertEq (-> last take(1) nil), -> nil
			assertEqOn(json) (-> list take(10) range(1)), -> [0]
			assertEqOn(json) (-> list take(10) range(3)), -> [0, 1, 2]

	describe 'takeWhile', ->
		positive = (x) -> x > 0

		it 'may returns empty list', ->
			assertEq (-> last takeWhile(-> false) naturals), -> nil
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
			assertEq (-> last takeWhile(-> false) naturals), -> nil
		it 'returns first n ok elements', ->
			assertEqOn(json) (-> list takeWhile(positive) [-1, 1]), -> []
			assertEqOn(json) (-> list takeWhile(positive) [1, -2, 3]), -> [1]
		it 'returns all if all ok', ->
			assertEqOn(json) (-> list takeWhile(positive) [1, 2, 3]), -> [1, 2, 3]

	describe 'scanl', ->
		it 'scanl(f, x) nil returns x', ->
			assertEq (-> last scanl(plus, 3) nil), -> 3
		it 'scanl(plus, 0) [1..5] returns [0, 1 ... 15]', ->
			assertEqOn(json) (-> list scanl(plus, 0) range(1, 6)), -> [0, 1, 3, 6, 10, 15]

	describe 'streak', ->
		it 'streak(n) nil returns empty list', ->
			assertEq (-> last streak(3) nil), -> nil
		it 'streak(1) [0, 1, 2...] returns [[0], [1], [2]...]', ->
			assertEqOn(json) (-> list take(3) streak(1) naturals), (-> [[0], [1], [2]])
		it 'streak(2) [0, 1, 2...] returns [[0], [0, 1], [1, 2]...]', ->
			assertEqOn(json) (-> list take(3) streak(2) naturals), (-> [[0], [0, 1], [1, 2]])

	describe 'reverse', ->
		it 'given empty list returns empty list', ->
			assertEq (-> last reverse nil), -> nil
			assertEq (-> last reverse (lazy -> do nil)), -> nil
		it 'reverse [0..4] returns [4..0]', ->
			assertEqOn(json) (-> list reverse range(5)), (-> [4, 3, 2, 1, 0])

