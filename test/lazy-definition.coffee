describe 'definition', ->

	describe 'nil', ->
		it 'nil isnt null', ->
			assert -> nil isnt null
		it 'nil isnt undefined', ->
			assert -> nil isnt undefined
		it 'nil[Symbol.iterator]() is nil', ->
			log -> Symbol.iterator
			log -> json Symbol.iterator
			assert -> nil[Symbol.iterator]() is nil
		it 'nil() is nil', ->
			assert -> nil() is nil

	describe 'LazyList', ->
		it 'gives funtions [Symbol.iterator]()', ->
			assert -> (LazyList ->)[Symbol.iterator]?
			assert -> typeof (LazyList ->)[Symbol.iterator] is 'function'
		it 'gives funtions .toString()', ->
			assert -> (LazyList ->).toString?
			assert -> typeof (LazyList ->).toString is 'function'

	describe 'Iterator', ->
		it 'gives funtions .next()', ->
			assert -> (Iterator ->).next?
			assert -> typeof (Iterator ->).next is 'function'
		it 'gives funtions .toString()', ->
			assert -> (Iterator ->).toString?
			assert -> typeof (Iterator ->).toString is 'function'

