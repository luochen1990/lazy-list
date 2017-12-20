this_module = ({Symbol}) ->
	CustomErrorType = (errorName) ->
		(msg) ->
			CustomError = (msg)->
				self = new Error msg
				self.name = errorName
				self.__proto__ = CustomError.prototype
				return self
			CustomError.prototype.__proto__= Error.prototype
			return new CustomError(msg)

	ListError = CustomErrorType('ListError')

	# LazyList definition: nil, LazyList, Iterator,

	LazyList = (f) -> # construct a LazyList from a function.
		f[Symbol.iterator] = -> f()
		f.toString = -> "LazyList"
		f.toJSON = -> list f
		return f

	nil = LazyList -> nil # xs is empty <==> xs is nil or xs() is nil or xs()() is nil... <==> last xs is nil
	nil.toString = -> 'nil'

	Iterator = (it) -> # construct an Iterator(which is a function with status) from a function.
		it.next = ->
			r = it()
			{value: r, done: r == nil}
		it.toString = -> "Iterator"
		return it

	# LazyList constants: naturals, range, primes,

	naturals =
		LazyList ->
			i = -1
			Iterator ->
				++i

	range = (args...) ->
		if args.length == 0
			naturals
		else if args.length == 1
			LazyList ->
				[stop] = args
				i = -1
				Iterator ->
					if ++i < stop then i else nil
		else if args.length == 2
			LazyList ->
				[start, stop] = args
				if start < stop
					i = start - 1
					Iterator ->
						if ++i < stop then i else nil
				else
					i = start + 1
					Iterator ->
						if --i > stop then i else nil
		else
			LazyList ->
				[start, stop, step] = args
				throw ListError 'ERR IN range(): YOU ARE CREATING AN UNLIMITTED RANGE' if stop != start and (stop - start) * step < 0
				i = start - step
				if start < stop
					Iterator ->
						if (i += step) < stop then i else nil
				else
					Iterator ->
						if (i += step) > stop then i else nil

	primes = LazyList -> do
		filter((x) -> all((p) -> x % p != 0) takeWhile((p) -> p * p <= x) range(2, Infinity)) range(2, Infinity)

	# LazyList producers: lazy, enumerate, iterate, randoms, permutations, powerset

	lazy = (xs) -> #make a LazyList from Function/LazyList/Array/String/ES6Lazy
		if typeof xs is 'function'
			if xs[Symbol.iterator]? #xs is LazyList
				xs
			else #xs is Function
				LazyList xs
		else if xs.constructor in [Array, String] #xs is Array or String
			LazyList ->
				i = -1
				Iterator ->
					if (++i) < xs.length then xs[i] else nil
		else if xs[Symbol.iterator]? #xs is ES6Lazy
			LazyList ->
				it = xs[Symbol.iterator]()
				Iterator ->
					r = it.next()
					if r.done then nil else r.value
		else
			throw ListError 'lazy(xs): xs is neither Array nor Iterable'

	enumerate = (it) -> # Iterator with index(with key for object)
		if it[Symbol.iterator]? or it instanceof Array
			zip(naturals, it)
		else
			LazyList ->
				keys = Object.keys(it)
				i = -1
				Iterator ->
					if ++i < keys.length then [(k = keys[i]), it[k]] else nil

	repeat = (x) -> # repeat x
		LazyList ->
			Iterator ->
				x

	iterate = (next, init) -> #function next should not change it's argument
		LazyList ->
			st = init
			Iterator ->
				r = st
				st = next st
				return r

	randoms = do -> #NOTE: unstandard!
		salt = Math.PI / 3.0

		hash = (x) ->
			x = Math.sin(x + salt) * 1e4
			x - Math.floor(x)


		normal = (seed) -> iterate hash, hash(seed)

		(opts) ->
			if not opts?
				normal(0)
			else if typeof opts is 'number'
				normal(opts)
			else
				seed = opts.seed ? 0
				rg = opts.range
				if rg?
					if typeof rg is 'number'
						map((x) -> Math.floor(x * rg)) normal(seed)
					else
						[s, k] = [rg[0], rg[1] - rg[0] + 1]
						map((x) -> s + Math.floor(x * k)) normal(seed)
				else
					normal(seed)

	permutations = do ->
		next_permutation = (x) ->
			x = x[...]
			l = x.length - 1
			--l while l >= 1 and x[l] <= x[l - 1]

			if (l != 0)
				m = x.length - 1
				--m while m > l - 1 and x[m] <= x[l - 1]
				[x[m], x[l - 1]] = [x[l - 1], x[m]]

			r = x.length - 1
			while(l < r)
				[x[l], x[r]] = [x[r], x[l]]
				++l
				--r
			return x

		(xs) ->
			arr = list xs
			if arr.length == 0 then nil else
				cons(arr[...]) takeWhile((ls) -> json(ls) != json(arr)) drop(1) iterate(next_permutation, arr)

	powerset = (xs) -> if length(xs) == 0 then [[]] else (ss = powerset(drop(1) xs); concat([ss, map(cons head(xs))(ss)]))

	# LazyList decorators: take, takeWhile, drop, dropWhile, cons, map, filter, scanl, streak, streak2, reverse, sort, sortOn

	take = (n) ->
		(xs) ->
			LazyList ->
				iter = lazy(xs)[Symbol.iterator]()
				c = -1
				Iterator ->
					if ++c < n then iter() else nil

	takeWhile = (ok) ->
		(xs) ->
			LazyList ->
				iter = lazy(xs)[Symbol.iterator]()
				Iterator ->
					if (x = iter()) isnt nil and ok(x) then x else nil

	drop = (n) ->
		(xs) ->
			LazyList ->
				iter = lazy(xs)[Symbol.iterator]()
				finished = false
				(finished or= (iter() is nil); break if finished) for i in [0...n]
				if finished then (-> nil) else iter

	dropWhile = (ok) ->
		(xs) ->
			LazyList ->
				iter = lazy(xs)[Symbol.iterator]()
				null while ok(x = iter()) and x isnt nil
				Iterator ->
					[prevx, x] = [x, iter()]
					return prevx

	cons = (x) ->
		(xs) ->
			LazyList ->
				iter = null
				Iterator ->
					if iter is null
						iter = lazy(xs)[Symbol.iterator]()
						return x
					else
						return iter()

	map = (f) ->
		(xs) ->
			LazyList ->
				iter = lazy(xs)[Symbol.iterator]()
				Iterator ->
					if (x = iter()) isnt nil then f(x) else nil

	filter = (ok) ->
		(xs) ->
			LazyList ->
				iter = lazy(xs)[Symbol.iterator]()
				Iterator ->
					null while (x = iter()) isnt nil and not ok(x)
					return x

	scanl = (op) -> (r) ->
		(xs) ->
			LazyList ->
				iter = lazy(xs)[Symbol.iterator]()
				Iterator ->
					got = r
					r = if (x = iter()) isnt nil then op(r)(x) else nil
					return got

	streak = (n) -> #NOTE: unstandard!
		if n < 1
			nil
		else
			(xs) ->
				drop(n - 1) LazyList ->
					iter = lazy(xs)[Symbol.iterator]()
					buf = []
					Iterator ->
						return nil if (x = iter()) is nil
						buf.push(x)
						buf.shift(1) if buf.length > n
						return buf[...]

	streak2 = (n) -> (xs) -> streak(n) concat [xs, take(n - 1) xs] #NOTE: unstandard!

	reverse = (xs) ->
		if xs.constructor in [Array, String] #xs is Array or String
			LazyList ->
				i = xs.length
				Iterator ->
					if (--i) >= 0 then xs[i] else nil
		else #NOTE: strict!
			list(lazy(xs)).reverse()

	sort = (xs) -> #NOTE: strict!
		arr = list lazy(xs)
		return arr.sort((a, b) -> (a > b) - (a < b))

	sortOn = (f) -> #NOTE: strict! # f :: (Comparable b) => a -> b
		(xs) ->
			arr = list lazy(xs)
			return arr.sort((a, b) -> ((fa = f(a)) > (fb = f(b))) - (fa < fb))

	# LazyList spliters: partition, groupOn,

	groupOn = (f) -> #NOTE: strict! # f :: (Hashable b) => a -> b
		(xs) ->
			memo = {}
			foreach xs, (x) ->
				y = f(x)
				memo[y] ?= []
				memo[y].push(x)
			return (v for k, v of memo)

	partition = (f) -> #NOTE: strict! # f :: a -> Bool
		(xs) ->
			memo = [[], []]
			foreach xs, (x) ->
				y = !f(x) + 0
				memo[y].push(x)
			return memo

	# LazyList combiners: concat, zip, zipWith, cartProd,

	concat = (xss) ->
		xss = filter((x) -> x.constructor not in [Array, String] or x.length > 0) xss #TODO: more precise
		LazyList ->
			xs_iter = lazy(xss)[Symbol.iterator]()
			xs = xs_iter()
			iter = lazy(xs)[Symbol.iterator]()
			Iterator ->
				if (x = iter()) isnt nil
					return x
				else if (xs = xs_iter()) isnt nil
					iter = lazy(xs)[Symbol.iterator]()
					return iter()
				else
					return nil

	{zip, zipWith} = do ->
		finished = (arr) ->
			for x in arr
				return true if x is nil
			return false

		zip = (xss...) ->
			LazyList ->
				iters = (lazy(xs)[Symbol.iterator]() for xs in xss)
				Iterator ->
					next = (iter() for iter in iters)
					if finished(next)
						return nil
					else
						return next

		zipWith = (f) -> (xss...) ->
			LazyList ->
				iters = (lazy(xs)[Symbol.iterator]() for xs in xss)
				Iterator ->
					next = (iter() for iter in iters)
					if finished(next)
						return nil
					else
						return f(next...)

		return {zip, zipWith}

	cartProd = do -> # cartesian product
		inc_vector = (limits) ->
			len_minus_1 = limits.length - 1
			(vec) ->
				i = len_minus_1
				vec[i--] = 0 until ++vec[i] < limits[i] or i <= 0
				return vec

		apply_vector = (space) ->
			len = space.length
			(vec) ->
				(space[i][vec[i]] for i in [0...len])

		(xss...) ->
			LazyList ->
				xss = (list(xs) for xs in xss)
				limits = (xss[i].length for i in [0...xss.length])
				(return nil if len is 0) for len in limits
				inc = inc_vector(limits)
				get_value = apply_vector(xss)
				v = (0 for i in [0...xss.length])
				Iterator ->
					if v[0] < limits[0] then (r = get_value v; inc v; r) else nil

	# LazyList consumers: list, head, last, length, foldl, best, maximum, minimum, maximumOn, minimumOn, all, any, foreach,

	list = (xs) -> #force list elements of the LazyList to get an array
		if xs instanceof Array
			xs
		else if typeof xs is 'function'
			it = xs[Symbol.iterator]()
			(x while (x = it()) isnt nil)
		else if xs[Symbol.iterator]?
			it = lazy(xs)[Symbol.iterator]()
			(x while (x = it()) isnt nil)
		else if typeof xs is 'number'
			n = xs
			(xs) -> list take(n) xs
		else
			throw ListError 'list(xs): xs is neither Array nor Iterable'

	head = (xs) -> #returns error if xs is empty
		if xs.constructor in [Array, String]
			if xs.length > 0
				return xs[0]
			else
				throw ListError "head() used on empty list."
		else
			iter = lazy(xs)[Symbol.iterator]()
			if (r = iter()) isnt nil
				return r
			else
				throw ListError "head() used on empty list."

	tail = drop(1)

	last = (xs) -> #returns error if xs is empty
		if xs.constructor in [Array, String]
			if xs.length > 0
				return xs[xs.length - 1]
			else
				throw ListError "last() used on empty list."
		else
			iter = lazy(xs)[Symbol.iterator]()
			r = nil
			r = x while (x = iter()) isnt nil
			if r isnt nil
				return r
			else
				throw ListError "last() used on empty list."

	length = (xs) ->
		if xs.constructor in [Array, String] then xs.length else
			iter = lazy(xs)[Symbol.iterator]()
			r = 0
			++r while (x = iter()) isnt nil
			return r

	foldl = (op) -> (init) ->
		(xs) ->
			r = init
			iter = lazy(xs)[Symbol.iterator]()
			r = op(r)(x) while (x = iter()) isnt nil
			return r

	best = (better) -> #NOTE: unstandard!
		(xs) ->
			iter = lazy(xs)[Symbol.iterator]()
			return null if (r = iter()) is nil
			while (it = iter()) isnt nil
				r = if better(it, r) then it else r
			return r

	maximumOn = (f) -> best((a, b) -> f(a) > f(b)) #NOTE: unstandard!
	minimumOn = (f) -> best((a, b) -> f(a) < f(b)) #NOTE: unstandard!

	maximum = best((x, y) -> x > y)
	minimum = best((x, y) -> x < y)

	all = (f) ->
		f = ((x) -> x is f) if typeof(f) isnt 'function'
		(xs) ->
			iter = lazy(xs)[Symbol.iterator]()
			while (x = iter()) isnt nil
				return false if not f(x)
			return true

	any = (f) ->
		all_not = all (x) -> not f(x)
		(xs) -> not (all_not xs)

	fromList = (pairs) ->
		r = {}
		foreach pairs, ([k, v]) ->
			r[k] = v if v isnt undefined
		return r

	brk = -> brk
	brk.toString = -> 'foreach.break'

	foreach = (xs, callback, fruit) ->
		iter = lazy(xs)[Symbol.iterator]()
		while (x = iter()) isnt nil
			break if callback(x, fruit) is brk
		fruit

	Object.defineProperties foreach,
		break:
			writable: false
			configurable: false
			enumerable: false
			value: brk

	return {
		# LazyList definition
		nil, LazyList, Iterator, Symbol,

		# LazyList constants
		naturals, range, primes,

		# LazyList producers
		lazy, enumerate, repeat, iterate, randoms, permutations, powerset,

		# LazyList decorators
		cons, map, filter, take, takeWhile, tail, drop, dropWhile, scanl, streak, streak2, reverse, sort, sortOn,

		# LazyList spliters
		groupOn, partition,

		# LazyList combiners
		concat, zip, zipWith, cartProd,

		# LazyList consumers
		list, head, last, length, foldl, best, maximum, minimum, maximumOn, minimumOn, all, any, fromList, foreach,
	}

module.exports = this_module
	Symbol: Symbol ? {iterator: 'iter'}

