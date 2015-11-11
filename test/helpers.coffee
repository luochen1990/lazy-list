if not window?
	mate = require 'coffee-mate'
	lazy = require '../src/global'
	helpers = mate.dict([k, mate[k]] for k in ['log', 'assert', 'assertEq', 'assertEqOn', 'json', 'int', 'str'])

	objectId = do ->
		mem = []
		f = (obj) ->
			r = mem.indexOf(obj)
			if r is -1
				r = mem.length
				mem.push obj
			return r
		f.reset = -> mem = []
		return f

	every_one = (arr) ->
		(list map(objectId) arr).join(',')

	plus = (x) -> (y) -> x + y

	assertFail = (process) ->
		failed = false
		result = null
		try
			result = do process
		catch
			failed = true
		if not failed
			throw Error "An Exception Expected, But Got #{result}"

	Object.extend(helpers, {objectId, every_one, plus, assertFail})

Object.extend((if window? then window else global), helpers)

