this_module = ({Symbol}) ->

	# LazyList definition: nil, lazylist, iterator,

	lazylist = (f) -> # construct a lazylist from a function.
		f[Symbol.iterator] = -> f()
		f.toString = -> "LazyList"
		return f

	nil = lazylist -> nil # xs is empty <==> xs is nil or xs() is nil or xs()() is nil... <==> last xs is nil
	nil.toString = -> 'nil'

	iterator = (it) -> # construct an iterator(which is a function with status) from a function.
		it.next = ->
			r = it()
			{value: r, done: r == nil}
		it.toString = -> "Iterator"
		return it

	# lazylist constants: naturals, range, primes,

	naturals =
		lazylist ->
			i = -1
			iterator ->
				++i

	range = (args...) ->
		if args.length == 0
			naturals
		else if args.length == 1
			lazylist ->
				[stop] = args
				i = -1
				iterator ->
					if ++i < stop then i else nil
		else if args.length == 2
			lazylist ->
				[start, stop] = args
				if start < stop
					i = start - 1
					iterator ->
						if ++i < stop then i else nil
				else
					i = start + 1
					iterator ->
						if --i > stop then i else nil
		else
			lazylist ->
				[start, stop, step] = args
				throw 'ERR IN range(): YOU ARE CREATING AN UNLIMITTED RANGE' if stop != start and (stop - start) * step < 0
				i = start - step
				if start < stop
					iterator ->
						if (i += step) < stop then i else nil
				else
					iterator ->
						if (i += step) > stop then i else nil

	primes = lazylist -> do
		filter((x) -> all((p) -> x % p != 0) takeWhile((p) -> p * p <= x) range(2, Infinity)) range(2, Infinity)

	# lazylist producers: lazy, enumerate, generate, random_gen, ranged_random_gen, permutation_gen,

	lazy = (arr) -> #make a lazylist from array or function
		if typeof arr is 'function'
			lazylist arr
		else if arr[Symbol.iterator]?
			lazylist ->
				it = arr[Symbol.iterator]()
				iterator ->
					r = it.next()
					if r.done then nil else r.value
		else #maybe Array or String
			lazylist ->
				i = -1
				iterator ->
					i += 1
					if i < arr.length
						arr[i]
					else
						nil

	enumerate = (it) -> # iterator with index(with key for object)
		if it[Symbol.iterator]? or it instanceof Array
			zip(naturals, it)
		else
			lazylist ->
				keys = Object.keys(it)
				i = -1
				iterator ->
					if ++i < keys.length then [(k = keys[i]), it[k]] else nil

	repeat = (x) -> # repeat x
		lazylist ->
			iterator ->
				x

	generate = (init, next) -> #function next should not change it's argument
		lazylist ->
			status = init
			iterator ->
				last = status
				status = next status
				return last

	random_gen = do ->
		hash = (x) ->
			x = Math.sin(x) * 1e4
			x - Math.floor(x)
		(opts) ->
			seed = opts?.seed ? Math.random()
			generate seed, hash

	ranged_random_gen = (range, opts) ->
		seed = opts?.seed ? Math.random()
		map((x) -> Math.floor(x * range)) random_gen(seed: seed)

	permutation_gen = do ->
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

		(arr) ->
			if arr.length == 0 then nil else
				concat [arr[...]], takeWhile((ls) -> json(ls) != json(arr)) drop(1) generate arr, next_permutation

	# lazylist decorators: take, takeWhile, drop, dropWhile, cons, map, filter, scanl, streak, reverse,

	take = (n) ->
		(xs) ->
			lazylist ->
				iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
				c = -1
				iterator ->
					if ++c < n then iter() else nil

	takeWhile = (ok) ->
		(xs) ->
			lazylist ->
				iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
				iterator ->
					if (x = iter()) isnt nil and ok(x) then x else nil

	drop = (n) ->
		(xs) ->
			lazylist ->
				iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
				finished = false
				(finished or= (iter() is nil); break if finished) for i in [0...n]
				if finished then (-> nil) else iter

	dropWhile = (ok) ->
		(xs) ->
			lazylist ->
				iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
				null while ok(x = iter()) and x isnt nil
				iterator ->
					[prevx, x] = [x, iter()]
					return prevx

	cons = (x) ->
		(xs) ->
			lazylist ->
				iter = null
				iterator ->
					if iter is null
						iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
						return x
					else
						return iter()

	map = (f) ->
		(xs) ->
			lazylist ->
				iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
				iterator ->
					if (x = iter()) isnt nil then f(x) else nil

	filter = (ok) ->
		(xs) ->
			lazylist ->
				iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
				iterator ->
					null while not ok(x = iter()) and x isnt nil
					return x

	scanl = (f, r) ->
		(xs) ->
			lazylist ->
				iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
				iterator ->
					got = r
					r = if (x = iter()) isnt nil then f(r, x) else nil
					return got

	streak = (n) ->
		(xs) ->
			lazylist ->
				iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
				buf = []
				iterator ->
					return nil if (x = iter()) is nil
					buf.push(x)
					buf.shift(1) if buf.length > n
					return buf[...]

	reverse = (xs) ->
		arr = if xs[Symbol.iterator]? then list xs else copy xs
		return lazy arr.reverse()

	# lazylist combiners: concat, zip, zipWith, cartProd,

	concat = (xss...) ->
		lazylist ->
			iter = (if xss[0][Symbol.iterator]? then xss[0] else lazy(xss[0]))[Symbol.iterator]()
			current_index = 0
			iterator ->
				if (x = iter()) isnt nil
					return x
				else if (++current_index < xss.length)
					iter = (if xss[current_index][Symbol.iterator]? then xss[current_index] else lazy(xss[current_index]))[Symbol.iterator]()
					return iter()
				else
					return nil

	{zip, zipWith} = do ->
		finished = (arr) ->
			for x in arr
				return true if x is nil
			return false

		zip = (xss...) ->
			lazylist ->
				iters = ((if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]() for xs in xss)
				iterator ->
					next = (iter() for iter in iters)
					if finished(next)
						return nil
					else
						return next

		zipWith = (f) -> (xss...) ->
			lazylist ->
				iters = ((if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]() for xs in xss)
				iterator ->
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
			lazylist ->
				xss = (list(xs) for xs in xss)
				limits = (xss[i].length for i in [0...xss.length])
				(return nil if len is 0) for len in limits
				inc = inc_vector(limits)
				get_value = apply_vector(xss)
				v = (0 for i in [0...xss.length])
				iterator ->
					if v[0] < limits[0] then (r = get_value v; inc v; r) else nil

	# lazylist consumers: list, last, length, foldl, best, all, any, foreach,

	list = (xs) -> #force list elements of the lazylist to get an array
		if xs[Symbol.iterator]?
			it = xs[Symbol.iterator]()
			(x while (x = it()) isnt nil)
		else if xs instanceof Array
			xs
		else
			throw Error 'list(xs): xs is neither LazyList nor Array'

	last = (xs) -> #returns nil if xs is empty
		if not xs[Symbol.iterator]? then xs[xs.length - 1] ? nil else
			iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
			r = nil
			r = x while (x = iter()) isnt nil
			return r

	length = (xs) ->
		if not xs[Symbol.iterator]? then xs.length else
			iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
			r = 0
			++r while (x = iter()) isnt nil
			return r

	foldl = (f, r) ->
		(xs) ->
			iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
			r = f(r, x) while (x = iter()) isnt nil
			return r

	best = (better) ->
		(xs) ->
			iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
			return null if (r = iter()) is nil
			while (it = iter()) isnt nil
				r = if better(it, r) then it else r
			return r

	all = (f) ->
		f = ((x) -> x is f) if typeof(f) isnt 'function'
		(xs) ->
			iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
			while (x = iter()) isnt nil
				return false if not f(x)
			return true

	any = (f) ->
		all_not = all (x) -> not f(x)
		(xs) -> not (all_not xs)

	brk = -> brk
	brk.toString = -> 'foreach.break'

	foreach = (xs, callback, fruit) ->
		iter = (if xs[Symbol.iterator]? then xs else lazy(xs))[Symbol.iterator]()
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
		# lazylist definition
		nil, lazylist, iterator, Symbol,

		# lazylist constants
		naturals, range, primes,

		# lazylist producers
		lazy, enumerate, repeat, generate, random_gen, ranged_random_gen, permutation_gen,

		# lazylist decorators
		cons, map, filter, take, takeWhile, drop, dropWhile, scanl, streak, reverse,

		# lazylist combiners
		concat, zip, zipWith, cartProd,

		# lazylist consumers
		list, last, length, foldl, best, all, any, foreach,
	}

module.exports = this_module
	Symbol: Symbol ? {iterator: 'iter'}
