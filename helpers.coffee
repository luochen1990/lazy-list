extend = (base) -> (defaults...) -> #NOTE: modified inplace, use copy() to protect it.
	for d in defaults when d?
		base[k] ?= v for k, v of d #NOTE: null values will be replaced if a default value exists.
	return base

gulp = require('gulp')
del = require('del')
uglify = require('gulp-uglify')
sourcemaps = require('gulp-sourcemaps')
rename = require('gulp-rename')
filter = require('gulp-filter')
gutil = require('gulp-util')

watched_browserify = do ->
	watchify = require('watchify')
	browserify = require('browserify')
	source = require('vinyl-source-stream')

	(opts, piper) ->
		{src, rename: name} = opts

		b = browserify extend({entries: src, debug: true}) opts
		w = watchify browserify extend({entries: src, debug: true}) opts, watchify.args

		warn = (args...) -> gutil.log(args...); gutil.beep()
		build = -> piper(b.bundle().on('error', warn).pipe(source(name)))
		wbuild = -> piper(w.bundle().on('error', warn).pipe(source(name)))

		watch = ->
			w.on('log', gutil.log)
			w.on('update', wbuild)
			w.bundle()

		return {build, watch}

coffee_builder = do ->
	buffer = require('vinyl-buffer')

	(fname, opts) ->
		watched_browserify {
			src: "./src/#{fname}.coffee"
			rename: "#{fname}.js"
			extensions: ['.coffee']
			standalone: opts?.standalone ? fname
		}, (src) ->
			src.pipe(buffer()) #optional
				.pipe(sourcemaps.init({loadMaps: true}))
				.pipe(sourcemaps.write('./'))
				.pipe(gulp.dest('./build'))
				.pipe(filter('*.js'))
				.pipe(sourcemaps.init({loadMaps: true}))
				.pipe(uglify())
				.on('error', gutil.log)
				.pipe(rename(extname: '.min.js'))
				.pipe(sourcemaps.write('./'))
				.pipe(gulp.dest('./build'))

gulp.task 'clean', (done) -> del(['build/*'], done)

extend(global) {
	extend, gulp, del, gutil,
	uglify, sourcemaps, rename, filter,
	watched_browserify, coffee_builder,
}
