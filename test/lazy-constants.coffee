describe 'constants', ->

	describe 'naturals', ->
		it 'taken 0 returns nil', ->
			assertEq (-> length take(0) naturals), (-> 0)
		it 'starts with 0', ->
			assertEq (-> last take(1) naturals), (-> 0)
		it 'taken n returns [0..n-1]', ->
			assertEqOn(every_one) (-> take(2) naturals), (-> [0, 1])
			assertEqOn(every_one) (-> take(3) naturals), (-> [0, 1, 2])

	describe 'range', ->
		it 'range() is naturals', ->
			assertEq (-> range()), (-> naturals)
		it 'range(n) equals (take(n) naturals)', ->
			assertEqOn(every_one) (-> range(0)), (-> take(0) naturals)
			assertEqOn(every_one) (-> range(2)), (-> take(2) naturals)
		it 'range(s, e) equals [s..e)', ->
			assertEqOn(every_one) (-> range(1, 3)), (-> [1, 2])
			assertEqOn(every_one) (-> range(2, 5)), (-> [2, 3, 4])
		it 'range(s, e, step) equals [s, s+step ..e)', ->
			assertEqOn(every_one) (-> range(0, 10, 5)), (-> [0, 5])
			assertEqOn(every_one) (-> range(0, -10, -5)), (-> [0, -5])

	describe 'primes', ->
		it 'taken 0 returns empty list', ->
			assertEq (-> length take(0) primes), -> 0
		it 'taken n gives n primes', ->
			assertEqOn(every_one) (-> take(5) primes), -> [2, 3, 5, 7, 11]

