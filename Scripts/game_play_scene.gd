extends Node
const RecodeLowLevel = preload("res://Scripts/stack_low_level.gd")
var ArrayLowLevel = preload("res://Scripts/array_low_level.gd").new()

#--- Notes ---
# Hello, greetings to whoever is reading this. This is merely a prototype and there's a lot of things to implement to. 
# UNDO is still built-in, not manually coded to see how the game works. So, as arrays.
# Note written by: Sharksnow-123 (Briar)

#UPDATE -- 12/8/25
# Mika-mics adjust the stack/array code! Praise her mortals!


# --- SETTINGS ---
const MAX_GUESSES := 5
var undo_stack : RecodeLowLevel         
var redo_stack : RecodeLowLevel         
var undoCtr = 0;
var redoCtr = 0;

# --- STATE ---
var chosen_word := ""
var wrong_guesses := 0
var current_day := 1
const MAX_DAYS := 3
var last_round_result : String = "" 
var currentHealth: int = MAX_GUESSES

# --- UI ---
@onready var word_label = $WordLabel
@onready var guessed_label = $GuessedLetters
@onready var letters = $Letters
@onready var undo_button = $UndoButton
@onready var redo_button = $RedoButton
@onready var lose_panel = $LosePanel
@onready var title_label = $LosePanel/Title
@onready var continue_button = $LosePanel/ContinueButton
@onready var return_button = $LosePanel/ReturnMain
@onready var day_frame = $DayFrame
@onready var this_panel = $Dialogue_Panel
@onready var this_label = $Dialogue_Panel/StoryText
@onready var clue_button = $ClueButton

#----------------
#---DIALOGUES----
#----------------
var word_answer = [
	"LIGHT",
	"CANDLE",
	"KEY"
]

var scene_dialogues = [
	#DAY 1
	["Ah… it’s been a while. You’re still my friend, right?", 
	"I'm thankful you were my first", "I know you can’t talk right now… but you understand.",
	"Let’s play a game. Butcherman.", "See the letters? One mistake, and you feel pain. Simple.", 
	"Here’s your riddle: I can fill a room but take up no space. What am I?"
	],
	#DAY 2
	["How are you feeling?", "Still surprised you’ve got all your limbs? That’s thanks to me. I wouldn’t leave my friend hanging",
	"You know how this works by now. You did well yesterday.", "So let’s make things harder.", 
	"Riddle time: I burn to give you light, but the more I shine, the shorter I get. A single breath can end me. What am I?"
	],
	#DAY 3
	[ "Three days and you’re still alive. Lost a bit of blood here and there, but you’re breathing—good job.", 
	"Here’s the deal: answer this one, and I’ll let you go",
	"How many times do I have to say it? The more you fight, the worse it gets.",
	"Anyway, here’s your final riddle.",
	"If I turn once, what’s outside won’t get in. Turn again, what’s inside won’t get out. What am I?"
	]
	
]

var riddles = [
	#Day 1
	["Here’s your riddle: I can fill a room but take up no space. What am I?"],
	
	#Day 2
	["I burn to give you light, but the more I shine, the shorter I get. A single breath can end me. What am I?"],
	
	#Day3
	["If I turn once, what’s outside won’t get in. Turn again, what’s inside won’t get out. What am I?"]
]


func _ready():
	#hidden.resize(MAX_WORD_SIZE)
	#guessed_letters.resize(MAX_GUESSED)
	ArrayLowLevel.hidden.resize(ArrayLowLevel.MAX_WORD_SIZE)
	ArrayLowLevel.guessed_letters.resize(ArrayLowLevel.MAX_GUESSED)
	
	undo_stack = RecodeLowLevel.new(50)
	redo_stack = RecodeLowLevel.new(50)
	randomize()
	connect_buttons()
	start_game()



# ----------------------------------
# START GAME
# ----------------------------------
func start_game():
	currentHealth = MAX_GUESSES
	wrong_guesses = 0
	undoCtr = 0
	redoCtr = 0
	#guessed_letters.clear()
	ArrayLowLevel.clear_guessed()
	ArrayLowLevel.clear_hidden()
	undo_stack.clear()
	redo_stack.clear()
	play_Day_Dialogue()

	# choose a word based on current day
	chosen_word = _get_word_for_day()

	
	for c in chosen_word:
		ArrayLowLevel.hidden_push("_")
		#hidden.append("_")

	update_ui()
	update_health_display()
	_update_day_display()
	lose_panel.visible = false

	print("[Game] Day %d - New word length: %d" % [current_day, chosen_word.length()])
	print("[Game] Guesses allowed:", MAX_GUESSES)


func _get_word_for_day() -> String:
	# pick a random word according to current day
	var index = current_day - 1
	if index >= word_answer.size():
		index = word_answer.size()-1
	
	return word_answer[index]


# ----------------------------------
# CONNECT KEY BUTTONS
# ----------------------------------
func connect_buttons():
	# connect letter buttons safely (capture local reference)
	for btn in letters.get_children():
		if btn is Button:
			var b = btn
			b.pressed.connect(func(): handle_letter(b.text))

	# other buttons
	undo_button.pressed.connect(undo)
	redo_button.pressed.connect(redo)
	continue_button.pressed.connect(_on_continue_pressed)
	return_button.pressed.connect(_on_return_main_pressed)
	clue_button.pressed.connect(_on_clue_button_pressed)


# ----------------------------------
# UPDATE DISPLAY
# ----------------------------------
func update_ui():
	#word_label.text = " ".join(hidden)
	word_label.text = ArrayLowLevel.build_hidden()
	#guessed_label.text = "Guessed: " + ", ".join(guessed_letters)
	guessed_label.text = "Guessed: " + ArrayLowLevel.build_guessed()


func _update_day_display():
	# day_frame can be Label or a container with a child label; handle both
	if day_frame is Label:
		day_frame.text = "Day: " + str(current_day) + " / " + str(MAX_DAYS)

func update_health_display():
	# list sa hearts / texturerects
	var hearts = [
		$CanvasGroup/Health1,
		$CanvasGroup/Health2,
		$CanvasGroup/Health3,
		$CanvasGroup/Health4,
		$CanvasGroup/Health5
	]
	
	print("Current hearts: ", hearts)
	
	#hide the hearts muna
	for heart in hearts:
		heart.visible = false;
	
	if currentHealth == MAX_GUESSES:
		hearts[currentHealth - 1].visible = true;
		
	
	if currentHealth > 0:
		print("Heart State: ", hearts[currentHealth - 1])
		hearts[currentHealth - 1].visible = true;
		

# ----------------------------------
# GUESS LETTER
# ----------------------------------
func handle_letter(letter):
	letter = letter.to_upper()

	#if letter in guessed_letters:
		#return
	if ArrayLowLevel.guessed_checker(letter):
		return

	save_state()

	#guessed_letters.append(letter)
	ArrayLowLevel.guessed_push(letter)
	update_ui()

	var correct := false

	for i in range(chosen_word.length()):
		if chosen_word[i] == letter:
			ArrayLowLevel.hidden[i] = letter
			correct = true

	update_ui()
	
	var _still_blank := false
	for i in range(ArrayLowLevel.hidden_size):
		if ArrayLowLevel.hidden[i] == "_":
			_still_blank = true
			break
	
	if correct:
		if not _still_blank:
			show_end("          YOU WIN!\n Don't let it get to your head.")
		return
	# else:
	wrong_guesses += 1
	currentHealth -= 1
	update_health_display()
	print("[GUESS] Wrong guesses:", wrong_guesses, " / ", MAX_GUESSES)
	print("[GUESS] Current Health:", currentHealth, " / ", MAX_GUESSES)
	if wrong_guesses >= MAX_GUESSES:
		show_end("YOU LOSE!")


# ----------------------------------
# UNDO
# ----------------------------------
func save_state():
	# store snapshots so undo can fully restore
	var snapshot = {
		"hidden": ArrayLowLevel.hidden.duplicate(),
		"guessed": ArrayLowLevel.guessed_letters.duplicate(),
		"wrong": wrong_guesses,
		"currentH": currentHealth
	}
	undo_stack.push(snapshot)
	redo_stack.clear()
	print("[SAVE] saved state; undo stack size =", undo_stack.size)
	print("[SAVE] saved state; redo stack size =", redo_stack.size)

func undo():
	if undoCtr == 2:
		return
	
	if undo_stack.is_empty():
		print("[UNDO] No more undo")
		return
	
	var redo_snapshot = {
		"hidden": ArrayLowLevel.hidden.duplicate(),
		"guessed": ArrayLowLevel.guessed_letters.duplicate(),
		"wrong": wrong_guesses,
		"currentH": currentHealth
	}
	redo_stack.push(redo_snapshot)
	
	var state = undo_stack.pop()
	ArrayLowLevel.hidden = state.hidden
	ArrayLowLevel.guessed_letters = state.guessed
	wrong_guesses = state.wrong
	currentHealth = state.currentH
	
	undoCtr += 1
	#redoCtr = 0;
	update_ui()
	update_health_display()
	print("[UNDO] restored state; undo stack size =", undo_stack.size)

	update_ui()
	print("[UNDO] restored state; undo stack size =", undo_stack.size)
	print("[SAVE] saved state; redo stack size =", redo_stack.size)

# ----------------------------------
# REDO
# ----------------------------------

func redo():
	if redoCtr == 2:
		return
	
	if redo_stack.is_empty():
		print("[REDO] No more redo")
		return
	
	var redo_snapshot = {
		"hidden": ArrayLowLevel.hidden.duplicate(),
		"guessed": ArrayLowLevel.guessed_letters.duplicate(),
		"wrong": wrong_guesses,
		"currentH": currentHealth
	}
	undo_stack.push(redo_snapshot)
	
	var state = redo_stack.pop()
	ArrayLowLevel.hidden = state.hidden
	ArrayLowLevel.guessed_letters = state.guessed
	wrong_guesses = state.wrong
	currentHealth = state.currentH
	
	redoCtr += 1
	#undoCtr = 0
	
	update_ui()
	update_health_display()
	print("[REDO] restored state; redo stack size =", redo_stack.size)

# ----------------------------------
# SHOW LOSE/WIN
# ----------------------------------
func show_end(text):
	$LosePanel/Lose.visible = false;
	$LosePanel/Win.visible = false;
	
	if text == "YOU LOSE!":
		$LosePanel/Lose.visible = true;
		title_label.text = text + "\nThe word was: " + chosen_word
		last_round_result = "lose"
	else:
		$LosePanel/Win.visible = true;
		title_label.text = text
		last_round_result = "win"
	
	
	lose_panel.visible = true
	print("[GAME END] " + title_label.text, " | result =", last_round_result)



# ----------------------------------
# CONTINUE / NEXT DAY
# ----------------------------------
func _on_continue_pressed():
	if last_round_result == "win":
		# Player won the round
		if current_day < MAX_DAYS:
			# Go to next day
			current_day += 1
			print("[DAY] Player won. Going to day:", current_day)
			start_game()

		else:
			# Player completed the final day → WIN THE ENTIRE GAME
			print("[GAME] Completed all days! Changing scene...")
			await get_tree().create_timer(0.8).timeout
			get_tree().change_scene_to_file("res://Scenes/EndScene1.tscn")

	elif last_round_result == "lose":
		# Reset to day 1
		print("[DAY] Player lost. Resetting to Day 1")
		current_day = 1
		get_tree().change_scene_to_file("res://Scenes/DeathScene.tscn")

	else:
		print("[ERROR] Continue pressed but no round result stored!")

	# Clear result so it doesn't apply twice
	last_round_result = ""


# ----------------------------------
# DIALOGUES
# ----------------------------------
func play_Day_Dialogue():
	var index = current_day - 1
	
	if is_instance_valid(clue_button):
		clue_button.visible = false
	
	if index < scene_dialogues.size():
		var lines_for_the_day = scene_dialogues[index]
		
		await DialogueManager.line_player(lines_for_the_day, this_panel, this_label)
	

	if is_instance_valid(clue_button):
		clue_button.visible = true
	

func riddle_for_the_Day():
	var index = current_day - 1
	
	if index < riddles.size():
		var riddle_of_the_day = riddles[index]
		
		DialogueManager.line_player(riddle_of_the_day, this_panel, this_label)


func _on_clue_button_pressed() -> void:
	riddle_for_the_Day()



# ----------------------------------
# RETURN TO MAIN 
# ----------------------------------
func _on_return_main_pressed():
	await get_tree().create_timer(0.5).timeout #added delay for aesthetics ahh
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
