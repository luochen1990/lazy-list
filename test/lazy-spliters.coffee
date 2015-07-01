describe 'spliters', ->

	describe 'group', ->
		it 'given [] or nil returns nil', ->
			assertEq (-> last group nil), (-> nil)
		it 'given [1, 2, 3, 3, 1] returns [[1], [2], [3, 3], [1]]', ->
			assertEqOn(json) (-> list map(list) group [1, 2, 3, 3, 1]), (-> [[1], [2], [3, 3], [1]])
		it 'given [1, 2, 3, 1, 1] returns [[1], [2], [3], [1, 1]]', ->
			assertEqOn(json) (-> list map(list) group [1, 2, 3, 1, 1]), (-> [[1], [2], [3], [1, 1]])
		xit 'given [1, 2, 3, 1, 1] on map(head) returns [1, 2, 3, 1]', ->
			assertEqOn(json) (-> list map(head) group [1, 2, 3, 1, 1]), (-> [1, 2, 3, 1])

	describe 'groupBy', ->
		sameParity = (a, b) -> a % 2 == b % 2

		it 'with sameParity, given [] or nil returns nil', ->
			assertEq (-> last groupBy(sameParity) nil), (-> nil)
		it 'with sameParity, given [1, 2, 3, 3, 1, 2] returns [[1], [2], [3, 3, 1], [2]]', ->
			assertEqOn(json) (-> list map(list) groupBy(sameParity) [1, 2, 3, 3, 1, 2]), (-> [[1], [2], [3, 3, 1], [2]])

	describe 'groupOn', ->
		mod2 = (x) -> x % 2

		it 'with mod2, given [] or nil returns nil', ->
			assertEq (-> last groupOn(mod2) nil), (-> nil)
		it 'with mod2, given [1, 2, 3, 3, 1, 2] returns [[1], [2], [3, 3, 1], [2]]', ->
			log -> list map(list) groupOn(mod2) [1, 2, 3, 3, 1, 2]
			assertEqOn(json) (-> list map(list) groupOn(mod2) [1, 2, 3, 3, 1, 2]), (-> [[2, 2], [1, 3, 3, 1]])

	describe 'partition', ->
		isEven = (x) -> x % 2 == 0

		it 'with isEven, given [] or nil returns [[], []]', ->
			assertEqOn(json) (-> list partition(isEven) nil), (-> [[], []])
		it 'with isEven, given [1, 2, 3, 3, 1, 2] returns [[1], [2], [3, 3, 1], [2]]', ->
			assertEqOn(json) (-> list map(list) partition(isEven) [1, 2, 3, 3, 1, 2]), (-> [[2, 2], [1, 3, 3, 1]])

