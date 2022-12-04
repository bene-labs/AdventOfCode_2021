extends Node2D

export var input_path = "res://Day08/Input.txt"

enum{TOP_LEFT, TOP_MID, TOP_RIGHT, MID_MID, BOTTOM_LEFT, BOTTOM_MID, BOTTOM_RIGHT}

func decode(number_code, decoding):
	var display = []
	
	for character in number_code:
		display.append(decoding[character])

	display.sort()
	
	match display:
		[TOP_LEFT, TOP_MID, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_MID, BOTTOM_RIGHT]:
			return 0
		[TOP_RIGHT, BOTTOM_RIGHT]:
			return 1
		[TOP_MID, TOP_RIGHT, MID_MID, BOTTOM_LEFT, BOTTOM_MID]:
			return 2
		[TOP_MID, TOP_RIGHT, MID_MID, BOTTOM_MID, BOTTOM_RIGHT]:
			return 3
		[TOP_LEFT, TOP_RIGHT, MID_MID, BOTTOM_RIGHT]:
			return 4
		[TOP_LEFT, TOP_MID, MID_MID, BOTTOM_MID, BOTTOM_RIGHT]:
			return 5
		[TOP_LEFT, TOP_MID, MID_MID, BOTTOM_LEFT, BOTTOM_MID, BOTTOM_RIGHT]:
			return 6
		[TOP_MID, TOP_RIGHT, BOTTOM_RIGHT]:
			return 7
		[TOP_LEFT, TOP_MID, TOP_RIGHT, MID_MID, BOTTOM_LEFT, BOTTOM_MID, BOTTOM_RIGHT]:
			return 8
		[TOP_LEFT, TOP_MID, TOP_RIGHT, MID_MID, BOTTOM_MID, BOTTOM_RIGHT]:
			return 9
		_:
			return -1

func apply_decoding_by_brute_force(displays):
	var numbers = []

	for display in displays:
		for i in range(get_factorial(7)):
			var new_order = seeded_permutation(i, 7)
			for j in range(len(new_order)):
				new_order[j] -= 1
			var new_encoding = {}

			var key = ord('a')
			for number in new_order:
				new_encoding[char(key)] = number
				key += 1
			var is_valid = true
			for number in display["Encoding"]:
				if decode(number, new_encoding) < 0:
					is_valid = false
					break
			if is_valid:
				display["Decoding"] = new_encoding
				break
				
func get_numbers(displays):
	var numbers = []
	for display in displays:
		var number = 0
		var decimal_shift = pow(10, (len(display["Output"]) - 1))
		for k in len(display["Output"]):
			var encoded_number = decode(display["Output"][k], display["Decoding"])
			if encoded_number >= 0:
				number += decimal_shift * encoded_number
			decimal_shift /= 10
		numbers.append(number)
	return numbers
	
func run_part_2(displays):
	apply_decoding_by_brute_force(displays)
	var numbers = get_numbers(displays)
	var result = 0
	for number in numbers:
		result += number
	return result

func run_part_1(displays):
	var result = 0
	for display in displays:
		for output in display["Output"]:
			if len(output) == 2 or len(output) == 3 or len(output) == 4 or len(output) == 7:
				result += 1
	return result
	
func get_displays(path):
	var displays = []
	var file = File.new()
	file.open(path, File.READ)
	
	while not file.eof_reached():
		var line = file.get_line()
		if file.eof_reached() and line == "":
			break
		var encoding = line.split(" | ")[0].split(" ")
		var output = line.split(" | ")[1].split(" ")
		displays.append({"Encoding": encoding, "Output": output, "decoding": {}})
	return displays

# credit: Limeox => https://www.reddit.com/r/godot/comments/dqbfx0/comment/f6249ep/?utm_source=share&utm_medium=web2x&context=3
func seeded_permutation(seed_id: int, length: int):
	var list = [1]
	var prev_interval: int = 1
	var interval: int = 2
	for i in range(2, length + 1):
		list.insert(int(seed_id % interval / prev_interval), i)
		prev_interval = interval
		interval *= i + 1
	return list

func get_factorial(nb):
	var result = 1
	for i in range(2, nb + 1, 1):
		result *= nb
	return result

# Called when the node enters the scene tree for the first time.
func _ready():
	var displays = get_displays(input_path)
	print("Part 1 Result: ", run_part_1(displays))
	print("Part 2 Result: ", run_part_2(displays))
