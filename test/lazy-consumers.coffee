describe 'consumers', ->

	describe 'list', ->
		it 'list(n) xs  is short cut for  list take(n) xs', ->
			assertEqOn(json) (-> list(0) naturals), (-> [])
			assertEqOn(json) (-> list(1) naturals), (-> [0])
			assertEqOn(json) (-> list(3) naturals), (-> [0, 1, 2])
		it 'given normal list do nothing', ->
			ls0 = []
			assertEqOn(object_id) (-> list ls0), (-> ls0)
		it 'given lazy list returns normal list', ->
			assertEqOn(json) (-> list range(2)), (-> [0, 1])
		it 'given nil returns []', ->
			assertEqOn(json) (-> list nil), (-> [])

	describe 'last', ->
		it 'given [] or nil returns nil', ->
			assertEq (-> last []), (-> nil)
			assertEq (-> last nil), (-> nil)
		it 'given [1..n] or take(n+1) naturals returns n', ->
			assertEq (-> last [1]), (-> 1)
			assertEq (-> last [1, 2]), (-> 2)
			assertEq (-> last take(1) naturals), (-> 0)
			assertEq (-> last take(100) naturals), (-> 99)

	describe 'length', ->
		it 'accepts string', ->
			assert -> (length 'abc') == 3
		it 'accepts normal list', ->
			assert -> (length [1, 2]) == 2
		it 'accepts lazy list', ->
			assert -> (length range(2)) == 2
		it 'given [] or nil or "" returns 0', ->
			assertEq (-> length ''), (-> 0)
			assertEq (-> length []), (-> 0)
			assertEq (-> length nil), (-> 0)
		it 'given [1..n] or take(n) naturals returns n', ->
			assertEq (-> length [1]), (-> 1)
			assertEq (-> length [1, 2]), (-> 2)
			assertEq (-> length take(1) naturals), (-> 1)
			assertEq (-> length take(100) naturals), (-> 100)

	describe 'foldl', ->
		it 'accepts normal list', ->
			assertEq (-> foldl(plus, 0) [1, 2, 3]), -> 6
		it 'accepts lazy list', ->
			assertEq (-> foldl(plus, 0) range(1, 4)), -> 6
		it 'foldl(f, r) given nil returns r', ->
			assertEq (-> foldl(plus, 9) nil), -> 9
		it 'is safe when partly-applied named', ->
			named_folder = foldl ((r, x) -> r + (x)), 0
			assertEq (-> named_folder [1, 2]), -> 3
			assertEq (-> named_folder [1, 3]), -> 4

	describe 'best', ->
		lessThan = (x, y) -> x < y

		it 'accepts normal list', ->
			assertEq (-> best(lessThan) [1, 3, 2]), -> 1
		it 'accepts lazy list', ->
			assertEq (-> best(lessThan) range(1, 4)), -> 1
		it 'best(better) given nil or [] returns null', ->
			assertEq (-> best(lessThan) nil), -> null
			assertEq (-> best(lessThan) []), -> null

	describe 'all', ->
		lessThan = (n) ->
			(x) -> x < n

		it 'returns true if all ones ok', ->
			assertEq (-> all(lessThan(10)) range(10)), -> true
		it 'returns false if any one not ok', ->
			assertEq (-> all(lessThan(10)) range(11)), -> false
		it 'accepts normal list', ->
			assertEq (-> all(lessThan(10)) [1, 2]), -> true
			assertEq (-> all(lessThan(10)) [1, 10, 2]), -> false
		it 'accepts lazy list', ->
			assertEq (-> all(lessThan(10)) range(10)), -> true
			assertEq (-> all(lessThan(10)) range(11)), -> false
		it 'given nil or [] returns true', ->
			assertEq (-> all(lessThan(10)) nil), -> true
			assertEq (-> all(lessThan(10)) []), -> true

	describe 'any', ->
		lessThan = (n) ->
			(x) -> x < n

		it 'returns true if any one ok', ->
			assertEq (-> any(lessThan(10)) [11, 1, 12]), -> true
		it 'returns false if all ones not ok', ->
			assertEq (-> any(lessThan(10)) [11, 13, 12]), -> false
		it 'accepts normal list', ->
			assertEq (-> any(lessThan(10)) [11, 1, 12]), -> true
			assertEq (-> any(lessThan(10)) [11, 13, 12]), -> false
		it 'accepts lazy list', ->
			assertEq (-> any(lessThan(10)) range(9, 20)), -> true
			assertEq (-> any(lessThan(10)) range(10, 20)), -> false
		it 'given nil or [] returns false', ->
			assertEq (-> any(lessThan(10)) nil), -> false
			assertEq (-> any(lessThan(10)) []), -> false

	describe 'foreach', ->
		it 'do nothing with nil', ->
			changed = false
			foreach nil, ->
				changed = true
			assert -> changed is false
		it 'do nothing with []', ->
			changed = false
			foreach [], ->
				changed = true
			assert -> changed is false
		it 'did iterated to the end', ->
			total = 0
			foreach (take(10) repeat(1)), (x) ->
				total += x
			assert -> total == 10
		it '(foreach ls, callback, r) returns r', ->
			given = {total: 0}
			got = foreach (take(10) repeat(1)), (x, r) ->
				r.total += x
			, given
			assert -> got is given
			assert -> got.total is 10

