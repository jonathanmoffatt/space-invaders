extends Node

var messages = {}

func print_debounce(key, message):
    if !messages.has(key) || messages[key] != message:
        print("%s: %s", [key, message])
        messages[key] = message