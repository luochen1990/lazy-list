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

	describe 'lazylist', ->
		it 'gives funtions [Symbol.iterator]()', ->
			assert -> (lazylist ->)[Symbol.iterator]?
			assert -> typeof (lazylist ->)[Symbol.iterator] is 'function'
		it 'gives funtions .toString()', ->
			assert -> (lazylist ->).toString?
			assert -> typeof (lazylist ->).toString is 'function'

	describe 'iterator', ->
		it 'gives funtions .next()', ->
			assert -> (iterator ->).next?
			assert -> typeof (iterator ->).next is 'function'
		it 'gives funtions .toString()', ->
			assert -> (iterator ->).toString?
			assert -> typeof (iterator ->).toString is 'function'

