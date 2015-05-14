require './helpers'

build_target = ['global', 'lazy']

gulp.task 'build-pretty', ['clean'], ->
	for filename in build_target
		gulp.src "src/#{filename}.coffee"
			.pipe browserify()
			.pipe rename "#{filename}.js"
			.pipe sourcemaps.init loadMaps: true
			.pipe sourcemaps.write './'
			.pipe gulp.dest './build/'

gulp.task 'build', ['clean', 'build-pretty'], ->
	for filename in build_target
		gulp.src "src/#{filename}.coffee"
			.pipe browserify()
			.pipe rename "#{filename}.min.js"
			.pipe sourcemaps.init loadMaps: true
			.pipe uglify()
			.pipe sourcemaps.write './'
			.pipe gulp.dest './build/'

gulp.task 'clean', (done) -> del(['build/*'], done)

gulp.task 'watch', ['build'], ->
	gulp.watch(paths.scripts, ['scripts'])

gulp.task('default', ['build', 'watch'])
