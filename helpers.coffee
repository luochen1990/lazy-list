extend = (base) -> (defaults...) -> #NOTE: modified inplace, use copy() to protect it.
	for d in defaults when d?
		base[k] ?= v for k, v of d #NOTE: null values will be replaced if a default value exists.
	return base

gulp = require('gulp')
del = require('del')
uglify = require('gulp-uglify')
browserify = do ->
	br = require('browserify')
	transform = require('vinyl-transform')
	(opts) ->
		transform (filename) ->
			defaults =
				entries: filename
				extensions: ['.coffee']
				debug: true
			br(extend({}) opts, defaults).bundle()
sourcemaps = require('gulp-sourcemaps')
rename = require('gulp-rename')

extend(global) {extend, gulp, del, uglify, browserify, sourcemaps, rename}
