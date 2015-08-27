require './helpers'

build_lazy = coffee_builder('lazy', './build/browser', standalone: 'lazy')
build_global = coffee_builder('global', './build/browser', standalone: '__lazy')

gulp.task 'build-nodejs', ->
	gulp.src('src/**/*.coffee')
		.pipe(plumber())
		.pipe(coffee())
		.pipe(gulp.dest('build/nodejs/'))

gulp.task 'build-browser', ->
	build_lazy.build()
	build_global.build()

gulp.task 'build', ['clean'], ->
	gulp.run 'build-nodejs'
	gulp.run 'build-browser'

gulp.task 'watch', ['build'], ->
	build_lazy.watch()
	build_global.watch()
	gulp.watch('src/**/*.coffee', ['build-nodejs'])
#	gulp.watch 'src', ['build']

gulp.task('default', ['build', 'watch'])
