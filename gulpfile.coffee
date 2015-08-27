require './helpers'

build_index = coffee_builder('lazy', './build/browser', standalone: 'lazy')
build_global = coffee_builder('global', './build/browser', standalone: '__lazy')

gulp.task 'build-nodejs', ->
	gulp.src "src/**/*.coffee"
		.pipe plumber()
		.pipe sourcemaps.init loadMaps: true
		.pipe coffee()
		.pipe sourcemaps.write './'
		.pipe gulp.dest 'build/nodejs/'

gulp.task 'build-browser', ->
	build_index.build()
	build_global.build()

gulp.task 'build', ['clean'], ->
	gulp.run 'build-nodejs'
	gulp.run 'build-browser'

gulp.task 'watch', ['build'], ->
	build_index.watch()
	build_global.watch()
	gulp.watch('src/**/*.coffee', ['build-nodejs'])

gulp.task('default', ['build', 'watch'])
