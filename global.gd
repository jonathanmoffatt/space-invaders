extends Node

var margin_side = 280
var down_step = 70
var side_step = 40

var messages = {}

func print_debounce(key, message):
    if !messages.has(key) || messages[key] != message:
        print("%s: %s", [key, message])
        messages[key] = message