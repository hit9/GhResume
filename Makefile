# vim:set noet:
all:
	coffee -c  -o js coffee/ghresume.coffee
	lessc less/style.less css/style.css --compress
