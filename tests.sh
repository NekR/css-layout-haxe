# haxe -cp ./src -main Tests -neko ./_tests_output/tests.n && neko ./_tests_output/tests.n
haxe -cp ./src -main Tests -js ./_tests_output/tests.js && node ./_tests_output/tests.js