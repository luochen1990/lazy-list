describe 'combiners', ->

	describe 'concat', ->
		it 'concat(nil) returns empty', ->
			assertEq (-> length concat nil), -> 0
		it 'concat([nil, nil]) returns empty', ->
			assertEq (-> length concat [nil, nil]), -> 0
		it 'concat([nil, xs]) returns xs', ->
			assertEqOn(json) (-> list concat [nil, [1, 2, 3]]), -> [1, 2, 3]
			assertEqOn(json) (-> list concat [nil, range(2)]), -> [0, 1]
		it 'concat([xs, ys]) returns [x ... y ...]', ->
			assertEqOn(json) (-> list concat [[1, 2, 3], [1, 2]]), -> [1, 2, 3, 1, 2]
		it 'concat([xs, ys, zs]) returns [x ... y ... z ...]', ->
			assertEqOn(json) (-> list concat [[1, 2, 3], [1, 2], [3, 4]]), -> [1, 2, 3, 1, 2, 3, 4]

	describe 'zip', ->
		it 'zip(nil) returns empty', ->
			assertEq (-> length zip(nil)), -> 0
		it 'zip(nil, xs) returns empty', ->
			assertEq (-> length zip(nil, naturals)), -> 0
		it 'zip(xs, nil) returns empty', ->
			assertEq (-> length zip(naturals, nil)), -> 0
		it 'zip(xs, ys) returns [[x1, y1], [x2, y2] ...]', ->
			assertEqOn(json) (-> list zip(naturals, ['a', 'b'])), -> [[0, 'a'], [1, 'b']]
			assertEqOn(json) (-> list zip(['a', 'b'], naturals)), -> [['a', 0], ['b', 1]]
		it 'zip(xs, ys, zs) returns [[x1, y1, z1], [x2, y2, z2] ...]', ->
			assertEqOn(json) (-> list zip(naturals, primes, ['a', 'b'])), -> [[0, 2, 'a'], [1, 3, 'b']]
			assertEqOn(json) (-> list zip(naturals, ['a', 'b'], primes)), -> [[0, 'a', 2], [1, 'b', 3]]
			assertEqOn(json) (-> list zip(['a', 'b'], naturals, primes)), -> [['a', 0, 2], ['b', 1, 3]]

	describe 'zipWith', ->
		strcat = (args...) -> args.join(',')

		it 'zipWith(strcat)(nil) returns empty', ->
			assertEq (-> length zipWith(strcat)(nil)), -> 0
		it 'zipWith(strcat)(nil, xs) returns empty', ->
			assertEq (-> length zipWith(strcat)(nil, naturals)), -> 0
		it 'zipWith(strcat)(xs, nil) returns empty', ->
			assertEq (-> length zipWith(strcat)(naturals, nil)), -> 0
		it 'zipWith(strcat)(xs, ys) returns [strcat(x1, y1), strcat(x2, y2) ...]', ->
			assertEqOn(json) (-> list zipWith(strcat)(naturals, ['a', 'b'])), -> ['0,a', '1,b']
			assertEqOn(json) (-> list zipWith(strcat)(['a', 'b'], naturals)), -> ['a,0', 'b,1']
		it 'zipWith(strcat)(xs, ys, zs) returns [strcat(x1, y1, z1), strcat(x2, y2, z2) ...]', ->
			assertEqOn(json) (-> list zipWith(strcat)(naturals, primes, ['a', 'b'])), -> ['0,2,a', '1,3,b']
			assertEqOn(json) (-> list zipWith(strcat)(naturals, ['a', 'b'], primes)), -> ['0,a,2', '1,b,3']
			assertEqOn(json) (-> list zipWith(strcat)(['a', 'b'], naturals, primes)), -> ['a,0,2', 'b,1,3']

	describe 'cartProd', ->
		it 'cartProd(nil) returns nil', ->
			assertEq (-> length cartProd(nil)), -> 0
		it 'cartProd(nil, ys) returns nil', ->
			assertEq (-> length cartProd(nil, [1, 2])), -> 0
		it 'cartProd(xs, nil) returns nil', ->
			log -> list cartProd [1, 2], nil
			assertEq (-> length cartProd([1, 2], nil)), -> 0
		it 'cartProd(xs, ys) returns [[x1, y1], [x1, y2] ... [x2, y1], [x2, y2] ...]', ->
			assertEqOn(json) (-> list cartProd([1, 2], ['a', 'b'])), -> [[1, 'a'], [1, 'b'], [2, 'a'], [2, 'b']]
		it 'cartProd(xs, ys, zs) returns [[x1, y1, z1], [x1, y1, z2] ...', ->
			assertEqOn(json) (-> list cartProd([1, 2], ['a', 'b'], ['x', 'y'])), -> [[1, 'a', 'x'], [1, 'a', 'y'], [1, 'b', 'x'], [1, 'b', 'y'], [2, 'a', 'x'], [2, 'a', 'y'], [2, 'b', 'x'], [2, 'b', 'y']]

