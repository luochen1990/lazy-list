if not window?
	mate = require 'coffee-mate'
	lazy = require '../src/global'
	helpers = mate.dict([k, mate[k]] for k in ['log', 'assert', 'assertEq', 'assertEqOn', 'json', 'int', 'str'])

	object_id = do ->
		counter = 0
		(obj) ->
			return 0 if not obj?
			obj.__obj_id = ++counter if not obj.__obj_id?
			return obj.__obj_id

	every_one = (arr) ->
		(list map(object_id) arr).join(',')

	plus = (x, y) -> x + y

	Object.extend(helpers, {object_id, every_one, plus})

Object.extend((if window? then window else global), helpers)

