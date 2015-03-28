require './helpers'

gulp.task 'clean', (done) -> del(['build/'], done)

gulp.task 'build', ['clean'], ->
	for filename in ['global.coffee', 'lazy.coffee']
		gulp.src "src/#{filename}"
			.pipe browserify()
			.pipe rename "#{filename}.js"
			.pipe sourcemaps.init loadMaps: true
			.pipe uglify()
			.pipe sourcemaps.write './'
			.pipe gulp.dest './build/'

gulp.task 'watch', ['build'], ->
	gulp.watch(paths.scripts, ['scripts'])

gulp.task('default', ['build'])

