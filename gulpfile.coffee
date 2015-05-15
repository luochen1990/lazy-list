require './helpers'

build_lazy = coffee_builder('lazy')
build_global = coffee_builder('global', standalone: '__lazy')

gulp.task 'build', ['clean'], ->
	build_lazy.build()
	build_global.build()

gulp.task 'watch', ['build'], ->
	build_lazy.watch()
	build_global.watch()
#	gulp.watch 'src', ['build']

gulp.task('default', ['build', 'watch'])
