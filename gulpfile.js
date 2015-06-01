var gulp = require('gulp');
var sass = require('gulp-sass');
var babel = require('gulp-babel');
var concat = require('gulp-concat');
var plumber = require('gulp-plumber');

var cssSrc = 'web/static/css/*.scss';
var cssDest = 'priv/static/css';

var jsSrc = 'web/static/js/**/*.js*';
var jsDest = 'priv/static/js'


function reportChange(event){
  console.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
}

gulp.task('build-sass', function() {
  gulp.src(cssSrc)
      .pipe(sass())
      .pipe(concat('app.css'))
      .pipe(gulp.dest(cssDest));
});

gulp.task('build-js', function() {
  return gulp.src(jsSrc)
      .pipe(plumber())
      .pipe(babel({sourceMap: false}))
      .pipe(gulp.dest(jsDest));
});

gulp.task('build', ['build-js', 'build-sass']);


gulp.task('watch', ['build'], function() {
  gulp.watch([jsSrc, cssSrc], ['build']).on('change', reportChange);
});


gulp.task('default', ['build']);