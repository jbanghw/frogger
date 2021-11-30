#####################################################################
#
# CSC258H5S Fall 2021 Assembly Final Project
# University of Toronto, St. George
#
# Student: James Bang, 1002655343
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 512
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone [5] (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# Easy Features
# 1. Display the number of lives remaining.
# 2. After final player death, display game over/retry screen. Restart the game if the “retry” option is chosen.
# 3. Have objects in different rows move at different speeds.
# 4. Add a third row in each of the water and road sections.
# Hard Features
# 5. Add sound effects for movement, collisions, game end and reaching the goal area.
# 6. Display the player’s score at the top of the screen.
#
# Any additional information that the TA needs to know:
# - pressing 'p' pauses the game but the dialogue shows up in the Run I/O section
#
#####################################################################

.data
	displayAddress: .word 0x10008000
	
	grassColor: .word 0x00ff00
	pinkColor: .word 0xffc0cb
	roadColor: .word 0x808080
	waterColor: .word 0x0000ff
	safeColor: .word 0xf5f5dc
	frogColor: .word 0x6a0dad
	carColor: .word 0xff0000
	logColor: .word 0x964b00
	livesColor: .word 0xffff00
	failColor: .word 0x008080
	orangeColor: .word 0xffa500
	
	frog_x_initial: .word 0x80
	frog_y_initial: .word 0x3c
	frog_x: .word 0x80
	frog_y: .word 0x3c
	
	vehicles_row1: .space 512
	vehicles_row2: .space 512
	vehicles_row3: .space 512
	vehicles_row4: .space 512
	logs_row1: .space 512
	logs_row2: .space 512
	logs_row3: .space 512
	logs_row4: .space 512
	water_row1: .space 512
	water_row2: .space 512
	water_row3: .space 512
	water_row4: .space 512
	frog_pos: .space 64
	success_zone1: .space 256
	success_zone2: .space 256
	success_zone3: .space 256
	fail_zone: .space 256
	
	num_lives: .word 0x3
	f1bool: .word 0x0
	f2bool: .word 0x0
	f3bool: .word 0x0
	
	movementSound: .word 60
	movementSoundDuration: .word 100
	movementSoundVolume: .word 127
	movementSoundInstrument: .word 39

	deathSound: .word 70
	deathSoundDuration: .word 100
	deathSoundVolume: .word 127
	deathSoundInstrument: .word 39
	
	gameEndSound: .word 52
	gameEndSoundDuration: .word 100
	gameEndSoundVolume: .word 127
	gameEndSoundInstrument: .word 20
	
	gameEndSound2: .word 40
	gameEndSoundDuration2: .word 300
	gameEndSoundVolume2: .word 127
	gameEndSoundInstrument2: .word 20

	goalSound: .word 80
	goalSoundDuration: .word 200
	goalSoundVolume: .word 127
	goalSoundInstrument: .word 25
	
	goalSound2: .word 68
	goalSoundDuration2: .word 100
	goalSoundVolume2: .word 127
	goalSoundInstrument2: .word 25

	goalSound3: .word 80
	goalSoundDuration3: .word 300
	goalSoundVolume3: .word 127
	goalSoundInstrument3: .word 25

	winSound: .word 85
	winSoundDuration: .word 200
	winSoundVolume: .word 127
	winSoundInstrument: .word 10
	winSoundDuration2: .word 600
	
	pausePrompt: .asciiz "Press P to continue...\n"


.text

main:

initialization: # initialize num_lives, f1bool, f2bool, f3bool
	addi $t0, $zero, 3
	sw $t0, num_lives
	sw $zero, f1bool
	sw $zero, f2bool
	sw $zero, f3bool

### Beginning of initial array filling ###
fillSpaces:
# fill the arrays for different objects with initial display address
# fillVehiclesRow1
	la $t0, vehicles_row1
	lw $t1, displayAddress
	addi $t1, $t1, 10240
	move $a0, $t0
	move $a1, $t1
	jal fillObstacles
# fillVehiclesRow2
	la $t0, vehicles_row2
	lw $t1, displayAddress
	addi $t1, $t1, 11296
	move $a0, $t0
	move $a1, $t1
	jal fillObstacles
# fillVehiclesRow3
	la $t0, vehicles_row3
	lw $t1, displayAddress
	addi $t1, $t1, 12352
	move $a0, $t0
	move $a1, $t1
	jal fillObstacles
# fillVehiclesRow4
	la $t0, vehicles_row4
	lw $t1, displayAddress
	addi $t1, $t1, 13344
	move $a0, $t0
	move $a1, $t1
	jal fillObstacles
# fillWaterRow1
	la $t0, water_row1
	lw $t1, displayAddress
	addi $t1, $t1, 3136
	move $a0, $t0
	move $a1, $t1
	jal fillObstacles
# fillWaterRow2
	la $t0, water_row2
	lw $t1, displayAddress
	addi $t1, $t1, 4160
	move $a0, $t0
	move $a1, $t1
	jal fillObstacles
# fillWaterRow3
	la $t0, water_row3
	lw $t1, displayAddress
	addi $t1, $t1, 5184
	move $a0, $t0
	move $a1, $t1
	jal fillObstacles
# fillWaterRow4
	la $t0, water_row4
	lw $t1, displayAddress
	addi $t1, $t1, 6208
	move $a0, $t0
	move $a1, $t1
	jal fillObstacles
# fillLogsRow1
	la $t0, logs_row1
	lw $t1, displayAddress
	addi $t1, $t1, 3072
	move $a0, $t0
	move $a1, $t1
	jal fillObstacles
# fillLogsRow2
	la $t0, logs_row2
	lw $t1, displayAddress
	addi $t1, $t1, 4096
	move $a0, $t0
	move $a1, $t1
	jal fillObstacles
# fillLogsRow3
	la $t0, logs_row3
	lw $t1, displayAddress
	addi $t1, $t1, 5120
	move $a0, $t0
	move $a1, $t1
	jal fillObstacles
# fillLogsRow4
	la $t0, logs_row4
	lw $t1, displayAddress
	addi $t1, $t1, 6144
	move $a0, $t0
	move $a1, $t1
	jal fillObstacles
# fillFailInitial
	la $t0, fail_zone
	lw $t1, displayAddress
	addi $t1, $t1, 2112
	move $a0, $t0
	move $a1, $t1
	jal fillFail
# fillSuccessInitial1
	la $t0, success_zone1
	lw $t1, displayAddress
	addi $t1, $t1, 2048
	move $a0, $t0
	move $a1, $t1
	jal fillSuccess
# fillSuccessInitial2
	la $t0, success_zone2
	lw $t1, displayAddress
	addi $t1, $t1, 2144
	move $a0, $t0
	move $a1, $t1
	jal fillSuccess
# fillSuccessInitial3
	la $t0, success_zone3
	lw $t1, displayAddress
	addi $t1, $t1, 2240
	move $a0, $t0
	move $a1, $t1
	jal fillSuccess
	j drawScene
### End of initial array filling ###

### Beginning of refreshing the scene
refreshScene:
	# Sleep for $a0 ms
	li $v0, 32
	li $a0, 500
	syscall
	
	# Check if the player has filled all the goal regions
	lw $t0, f1bool
	lw $t1, f2bool
	lw $t3, f3bool
	add $t0, $t0, $t1
	add $t0, $t0, $t3
	addi $t4, $zero, 3
	beq $t0, $t4, youWON # If all the goal regions are filled, go to winning end screen

### Filling the frog_pos array with the current position of the frog
	lw $t9, frog_x # $t9 holds the frog's x-coordinate
	lw $t8, frog_y # $t8 holds the frog's y-coordinate
	la $t7, frog_pos # $t7 holds the address of the frog_pos array
	lw $t6, displayAddress # $t6 holds the address of the display
	addi $t5, $zero, 256
	mul $t8, $t8, $t5
	add $t8, $t8, $t6
	add $t8, $t8, $t9 # $t8 holds the address of the top left pixel of the frog
	move $a0, $t8
	move $a1, $t7
	jal frogPosFillerLoopSetup # call frogPosFillerLoopSetup with $a0 = address of the tope left pixel of the frog, $a1 = address of the frog_pos array

### Detect collisions
	la $a0, frog_pos
	la $a1, vehicles_row1
	jal collisionDetectionLoopSetup
	la $a1, vehicles_row2
	jal collisionDetectionLoopSetup
	la $a1, vehicles_row3
	jal collisionDetectionLoopSetup
	la $a1, vehicles_row4
	jal collisionDetectionLoopSetup
	
	la $a1, water_row1
	jal collisionDetectionLoopSetup
	la $a1, water_row2
	jal collisionDetectionLoopSetup
	la $a1, water_row3
	jal collisionDetectionLoopSetup
	la $a1, water_row4
	jal collisionDetectionLoopSetup
	
	la $a1, fail_zone
	jal failDetectionLoopSetup
	
	la $a1, logs_row1
	jal logDetectionRightLoopSetup
	la $a1, logs_row2
	jal logDetectionLeftLoopSetup
	la $a1, logs_row3
	jal logDetectionRightFastLoopSetup
	la $a1, logs_row4
	jal logDetectionLeftFastLoopSetup

	addi $t1, $zero, 10
	lw $t0, frog_y
	ble $t0, $t1, winCon

### Key press detection
keyboardCheck:
	lw $t0, 0xffff0000
	beq $t0, 1, keyboardInput
	j moveSpaces

keyboardInput:
	lw $t0, 0xffff0004
	beq $t0, 0x77, respondToW
	beq $t0, 0x61, respondToA
	beq $t0, 0x73, respondToS
	beq $t0, 0x64, respondToD
	beq $t0, 0x70, respondToP
	beq $t0, 0x71, respondToQ
	j moveSpaces
respondToW:
	lw $t8, frog_y
	la $t7, frog_y
	addi $t8, $t8, -4
	jal playMovementSound
	ble $t8, $zero, respondToWset0
	sw $t8, 0($t7)
	j moveSpaces
respondToWset0:
	sw $zero, 0($t7)
	j moveSpaces
respondToA:
	lw $t8, frog_x
	la $t7, frog_x
	addi $t8, $t8, -16
	jal playMovementSound
	ble $t8, $zero, respondToAset0
	sw $t8, 0($t7)
	j moveSpaces
respondToAset0:
	sw $zero, 0($t7)
	j moveSpaces
respondToS:
	lw $t8, frog_y
	la $t7, frog_y
	addi $t8, $t8, 4
	addi $t3, $zero, 60
	jal playMovementSound
	bge $t8, $t3, respondToSset62
	sw $t8, 0($t7)
	j moveSpaces
respondToSset62:
	sw $t3, 0($t7)
	j moveSpaces
respondToD:
	lw $t8, frog_x
	la $t7, frog_x
	addi $t8, $t8, 16
	addi $t3, $zero, 240
	jal playMovementSound
	bge $t8, $t3, respondToDset240
	sw $t8, 0($t7)
	j moveSpaces
respondToDset240:
	sw $t3, 0($t7)
	j moveSpaces
respondToP:
	jal readPause
	j moveSpaces
respondToQ:
	j Exit


# Move the objects in the arrays to be redrawn
moveSpaces:
# moveVehiclesRow1
	la $t9, vehicles_row1
	lw $t8, displayAddress
	addi $t8, $t8, 11264
	jal moveObstaclesRightFastLoopSetup
# moveVehiclesRow2
	la $t9, vehicles_row2
	lw $t8, displayAddress
	addi $t8, $t8, 11264
	jal moveObstaclesLeftLoopSetup
# moveVehiclesRow3
	la $t9, vehicles_row3
	lw $t8, displayAddress
	addi $t8, $t8, 13312
	jal moveObstaclesRightLoopSetup
# moveVehiclesRow4
	la $t9, vehicles_row4
	lw $t8, displayAddress
	addi $t8, $t8, 13312
	jal moveObstaclesLeftFastLoopSetup
# moveWaterRow1
	la $t9, water_row1
	lw $t8, displayAddress
	addi $t8, $t8, 4096
	jal moveObstaclesRightLoopSetup
# moveWaterRow2
	la $t9, water_row2
	lw $t8, displayAddress
	addi $t8, $t8, 4096
	jal moveObstaclesLeftLoopSetup
# moveWaterRow3
	la $t9, water_row3
	lw $t8, displayAddress
	addi $t8, $t8, 6144
	jal moveObstaclesRightFastLoopSetup
# moveWaterRow4
	la $t9, water_row4
	lw $t8, displayAddress
	addi $t8, $t8, 6144
	jal moveObstaclesLeftFastLoopSetup
# moveLogsRow1
	la $t9, logs_row1
	lw $t8, displayAddress
	addi $t8, $t8, 4096
	jal moveObstaclesRightLoopSetup
# moveLogsRow2
	la $t9, logs_row2
	lw $t8, displayAddress
	addi $t8, $t8, 4096
	jal moveObstaclesLeftLoopSetup
# moveLogsRow3
	la $t9, logs_row3
	lw $t8, displayAddress
	addi $t8, $t8, 6144
	jal moveObstaclesRightFastLoopSetup
# moveLogsRow4
	la $t9, logs_row4
	lw $t8, displayAddress
	addi $t8, $t8, 6144
	jal moveObstaclesLeftFastLoopSetup

### Draw the scene!
drawScene:
# drawGoalRegion
	lw $t0, grassColor # set color to grassColor
	addi $t1, $zero, 0 # from row 0
	addi $t2, $zero, 16 # to row 8
	jal drawRectangle
# drawSafeRegion
	lw $t0, safeColor # set color to safeColor
	addi $t1, $zero, 28 # from row 16
	addi $t2, $zero, 12 # to row 20
	jal drawRectangle
# drawStartRegion
	lw $t0, grassColor # set color to grassColor
	addi $t1, $zero, 56 # from row 28
	addi $t2, $zero, 8 # to row 32
	jal drawRectangle
# drawRoad
	lw $t0, roadColor # set color to roadColor
	addi $t1, $zero, 40 # from row 20
	addi $t2, $zero, 16 # to row 28
	jal drawRectangle
# drawLives
	lw $t0, livesColor # set color to livesColor
	lw $t1, num_lives
	addi $t2, $zero, 3
	beq $t1, $t2, drawLives3
	addi $t2, $zero, 2
	beq $t1, $t2, drawLives2
	addi $t2, $zero, 1
	beq $t1, $t2, drawLives1
	beq $t1, $zero, drawLives0

# draw the obstacles
drawObstacles:
# draw vehicles row 1
	la $t9, vehicles_row1
	lw $t7, displayAddress
	lw $t5, carColor
	jal drawObs
# draw vehicles row 2
	la $t9, vehicles_row2
	lw $t7, displayAddress
	lw $t5, carColor
	jal drawObs
# draw vehicles row 3
	la $t9, vehicles_row3
	lw $t7, displayAddress
	lw $t5, carColor
	jal drawObs
# draw vehicles row 4
	la $t9, vehicles_row4
	lw $t7, displayAddress
	lw $t5, carColor
	jal drawObs
# draw water row 1
	la $t9, water_row1
	lw $t7, displayAddress
	lw $t5, waterColor
	jal drawObs
# draw water row 2
	la $t9, water_row2
	lw $t7, displayAddress
	lw $t5, waterColor
	jal drawObs
# draw water row 3
	la $t9, water_row3
	lw $t7, displayAddress
	lw $t5, waterColor
	jal drawObs
# draw water row 4
	la $t9, water_row4
	lw $t7, displayAddress
	lw $t5, waterColor
	jal drawObs
# draw logs row 1
	la $t9, logs_row1
	lw $t7, displayAddress
	lw $t5, logColor
	jal drawObs
# draw logs row 2
	la $t9, logs_row2
	lw $t7, displayAddress
	lw $t5, logColor
	jal drawObs
# draw logs row 3
	la $t9, logs_row3
	lw $t7, displayAddress
	lw $t5, logColor
	jal drawObs
# draw logs row 4
	la $t9, logs_row4
	lw $t7, displayAddress
	lw $t5, logColor
	jal drawObs

# draw the fail zones
	la $t9, fail_zone
	lw $t7, displayAddress
	lw $t5, failColor
	jal drawFail

# draw success zone 1
	la $t9, success_zone1
	lw $t7, displayAddress
	lw $t5, pinkColor
	jal drawSucc
# draw success zone 2
	la $t9, success_zone2
	lw $t7, displayAddress
	lw $t5, pinkColor
	jal drawSucc
# draw success zone 3
	la $t9, success_zone3
	lw $t7, displayAddress
	lw $t5, pinkColor
	jal drawSucc

# draw frogs in goal zones
drawFrog1:
	lw $t0, f1bool
	beq $t0, $zero, drawFrog2
	lw $t0, displayAddress # $t0 stores the base address for display
	lw $t5, orangeColor # $t5 stores the color of the frog (purple)
	sw $t5, 2072($t0)
	sw $t5, 2076($t0)
	sw $t5, 2080($t0)
	sw $t5, 2084($t0)
	sw $t5, 2332($t0)
	sw $t5, 2336($t0)
	sw $t5, 2588($t0)
	sw $t5, 2592($t0)
	sw $t5, 2584($t0)
	sw $t5, 2596($t0)
	sw $t5, 2840($t0)
	sw $t5, 2852($t0)
drawFrog2:
	lw $t0, f2bool
	beq $t0, $zero, drawFrog3
	lw $t0, displayAddress # $t0 stores the base address for display
	lw $t5, orangeColor # $t5 stores the color of the frog (purple)
	sw $t5, 2168($t0)
	sw $t5, 2172($t0)
	sw $t5, 2176($t0)
	sw $t5, 2180($t0)
	sw $t5, 2428($t0)
	sw $t5, 2432($t0)
	sw $t5, 2684($t0)
	sw $t5, 2688($t0)
	sw $t5, 2680($t0)
	sw $t5, 2692($t0)
	sw $t5, 2936($t0)
	sw $t5, 2948($t0)
drawFrog3:
	lw $t0, f3bool
	beq $t0, $zero, drawScore
	lw $t0, displayAddress # $t0 stores the base address for display
	lw $t5, orangeColor # $t5 stores the color of the frog (purple)
	sw $t5, 2264($t0)
	sw $t5, 2268($t0)
	sw $t5, 2272($t0)
	sw $t5, 2276($t0)
	sw $t5, 2524($t0)
	sw $t5, 2528($t0)
	sw $t5, 2780($t0)
	sw $t5, 2784($t0)
	sw $t5, 2776($t0)
	sw $t5, 2788($t0)
	sw $t5, 3032($t0)
	sw $t5, 3044($t0)

# Draw the score in the top right corner
drawScore:
	lw $t1, f1bool
	lw $t2, f2bool
	lw $t3, f3bool
	add $t1, $t1, $t2
	add $t1, $t1, $t3
	addi $t2, $zero, 100
	mul $t1, $t1, $t2
	beq $t1, $zero, drawZero
	beq $t1, $t2, drawOneHundred
	addi $t2, $zero, 200
	beq $t1, $t2, drawTwoHundred
	addi $t2, $zero, 300
	beq $t1, $t2, drawThreeHundred

# Finally, draw the frog!
drawFrog:
	lw $t0, displayAddress # $t0 stores the base address for display
	lw $t8, frog_x # $t8 stores the x-coordinate of the frog's top left
	lw $t7, frog_y # $t7 stores the y-coordinate of the frog's top left
	lw $t5, frogColor # $t5 stores the color of the frog (purple)
	addi $t6, $zero, 256 # set $t6 to 256
	mul $t9, $t7, $t6 # set $t9 = y-coordinate * 256
	add $t9, $t9, $t8 # set $t9 = $t9 + x-coordinate
	add $t9, $t9, $t0 # $t9 holds the address of the top left pixel of the frog
	sw $t5, 0($t9)
	sw $t5, 12($t9)
	sw $t5, 256($t9)
	sw $t5, 260($t9)
	sw $t5, 264($t9)
	sw $t5, 268($t9)
	sw $t5, 516($t9)
	sw $t5, 520($t9)
	sw $t5, 768($t9)
	sw $t5, 772($t9)
	sw $t5, 776($t9)
	sw $t5, 780($t9)
	j refreshScene






### Beginning of initial array fill calls ###
fillObstacles: # fill an obstacle array stored at $a0 with pixel address starting from $a1
	add $a2, $zero, $a1
	add $a3, $zero, $a0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillObstaclesLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 256
	addi $a3, $a0, 64
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillObstaclesLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 512
	addi $a3, $a0, 128
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillObstaclesLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 768
	addi $a3, $a0, 192
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillObstaclesLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 128
	addi $a3, $a0, 256
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillObstaclesLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 384
	addi $a3, $a0, 320
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillObstaclesLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 640
	addi $a3, $a0, 384
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillObstaclesLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 896
	addi $a3, $a0, 448
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillObstaclesLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

fillFail: # fill a fail_zone array stored at $a0 with pixel address starting from $a1
	add $a2, $zero, $a1
	add $a3, $zero, $a0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillFailLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 256
	addi $a3, $a0, 32
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillFailLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 512
	addi $a3, $a0, 64
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillFailLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 768
	addi $a3, $a0, 96
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillFailLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 96
	addi $a3, $a0, 128
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillFailLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 352
	addi $a3, $a0, 160
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillFailLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 608
	addi $a3, $a0, 192
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillFailLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a2, $a1, 864
	addi $a3, $a0, 224
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillFailLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

fillSuccess: # fill the success_zone array stored at $a0 with pixel address starting from $a1
	add $a2, $zero, $a1
	add $a3, $zero, $a0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillSuccessLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	addi $a2, $a1, 256
	addi $a3, $a0, 64
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillSuccessLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	addi $a2, $a1, 512
	addi $a3, $a0, 128
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillSuccessLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	addi $a2, $a1, 768
	addi $a3, $a0, 192
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal fillSuccessLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
### End of initial array fill calls ###


### Beginning of initial array filling loops ###
fillObstaclesLoopSetup: # function for filling a line (16 pixels) of pixels starting from $a2 at the address starting from $a3
	add $t0, $zero, $zero
	add $t1, $zero, 16
fillObstaclesLoop:
	beq $t0, $t1, fillObstaclesQuit
	addi $t2, $zero, 4
	mul $t3, $t0, $t2 # $t3 is the offset from the first pixel of the row being filled
	add $t4, $a2, $t3 # $t4 is the pixel address being stored
	add $t5, $a3, $t3 # $t5 is the address in the array where the pixel address is being stored
	sw $t4, 0($t5) # store the pixel address at the correct address in the array
	addi $t0, $t0, 1 # add 1 to $t0 for the loop to continue
	j fillObstaclesLoop
fillObstaclesQuit:
	jr $ra

fillFailLoopSetup:
	add $t0, $zero, $zero
	add $t1, $zero, 8
fillFailLoop:
	beq $t0, $t1, fillFailQuit
	addi $t2, $zero, 4
	mul $t3, $t0, $t2 # $t3 is the offset from the first pixel of the row being filled
	add $t4, $a2, $t3 # $t4 is the pixel address being stored
	add $t5, $a3, $t3 # $t5 is the address in the array where the pixel address is being stored
	sw $t4, 0($t5) # store the pixel address at the correct address in the array
	addi $t0, $t0, 1 # add 1 to $t0 for the loop to continue
	j fillFailLoop
fillFailQuit:
	jr $ra
	
fillSuccessLoopSetup:
	add $t0, $zero, $zero
	add $t1, $zero, 16
fillSuccessLoop:
	beq $t0, $t1, fillSuccessQuit
	addi $t2, $zero, 4
	mul $t3, $t0, $t2 # $t3 is the offset from the first pixel of the row being filled
	add $t4, $a2, $t3 # $t4 is the pixel address being stored
	add $t5, $a3, $t3 # $t5 is the address in the array where the pixel address is being stored
	sw $t4, 0($t5) # store the pixel address at the correct address in the array
	addi $t0, $t0, 1 # add 1 to $t0 for the loop to continue
	j fillSuccessLoop
fillSuccessQuit:
	jr $ra
### End of initial array filling loops ###

### Beginning of frog_pos filling loop ###
frogPosFillerLoopSetup: # fill the frog_pos array with the pixels the frog is covering with the top left corner at address $a0 with address of frog_pos in $a1
	add $t0, $zero, $zero
	addi $t1, $zero, 4
frogPosFillerLoop:
	beq $t0, $t1, frogPosFillerQuit
	mul $t2, $t0, $t1
	addi $t4, $zero, 16
	mul $t5, $t0, $t4
	add $t6, $a0, $t2
	add $t7, $a1, $t5
	sw $t6, 0($a1)
	addi $t6, $t6, 256
	sw $t6, 4($a1)
	addi $t6, $t6, 256
	sw $t6, 8($a1)
	addi $t6, $t6, 256
	sw $t6, 12($a1)
	addi $a1, $a1, 16
	addi $t0, $t0, 1
	j frogPosFillerLoop
frogPosFillerQuit:
	jr $ra
### End of frog_pos filling loop ###
	
### Beginning of collision detection loops
collisionDetectionLoopSetup: # Detect collision between the frog_pos at array $a0 and an object stored at array $a1
	add $t0, $zero, $zero # $t0 = 0
	addi $t1, $zero, 128 # $t1 = 128
collisionDetectionLoop:
	beq $t0, $t1, collisionDetectionLoopExit # while $t0 < $t1
	addi $t2, $zero, 4
	mul $t2, $t2, $t0 # $t2 = $t0 * 4
	move $a2, $t2
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal frogLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $t0, $t0, 1
	j collisionDetectionLoop
collisionDetectionLoopExit:
	jr $ra

failDetectionLoopSetup:
	add $t0, $zero, $zero # $t0 = 0
	addi $t1, $zero, 64 # $t1 = 128
failDetectionLoop:
	beq $t0, $t1, failDetectionLoopExit # while $t0 < $t1
	addi $t2, $zero, 4
	mul $t2, $t2, $t0 # $t2 = $t0 * 4
	move $a2, $t2
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal frogLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $t0, $t0, 1
	j failDetectionLoop
failDetectionLoopExit:
	jr $ra


frogLoopSetup:
	add $t9, $zero, $zero # $t9 = 0
	addi $t8, $zero, 16 # $t8 = 16
frogLoop:
	beq $t9, $t8, frogLoopExit # while $t9 < $t8
	addi $t3, $zero, 4
	mul $t3, $t9, $t3 # $t4 = $t9 * 4
	add $t3, $t3, $a0
	lw $t3, ($t3) # $t4 = frog_pos[i]
	add $t4, $a1, $a2
	lw $t4, ($t4) # $t5 = some_space[j]
	beq $t3, $t4, deathProcess
	addi $t9, $t9, 1
	j frogLoop
frogLoopExit:
	jr $ra


logDetectionRightLoopSetup:
	add $t0, $zero, $zero # $t0 = 0
	addi $t1, $zero, 128 # $t1 = 128
logDetectionRightLoop:
	beq $t0, $t1, logDetectionRightLoopExit # while $t0 < $t1
	addi $t2, $zero, 4
	mul $t2, $t2, $t0 # $t3 = $t0 * 4
	move $a2, $t2
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal logFrogRightLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $t0, $t0, 1
	j logDetectionRightLoop
logDetectionRightLoopExit:
	jr $ra
	
logFrogRightLoopSetup:
	add $t9, $zero, $zero # $t9 = 0
	addi $t8, $zero, 16 # $t8 = 16
logFrogRightLoop:
	beq $t9, $t8, logFrogRightLoopExit # while $t9 < $t8
	addi $t3, $zero, 4
	mul $t3, $t9, $t3 # $t4 = $t9 * 4
	add $t3, $t3, $a0
	lw $t3, ($t3) # $t4 = frog_pos[i]
	add $t4, $a1, $a2
	lw $t4, ($t4) # $t5 = some_space[j]
	beq $t3, $t4, moveWithLogRight
	addi $t9, $t9, 1
	j logFrogRightLoop
logFrogRightLoopExit:
	jr $ra

logDetectionLeftLoopSetup:
	add $t0, $zero, $zero # $t0 = 0
	addi $t1, $zero, 128 # $t1 = 128
logDetectionLeftLoop:
	beq $t0, $t1, logDetectionLeftLoopExit # while $t0 < $t1
	addi $t2, $zero, 4
	mul $t2, $t2, $t0 # $t3 = $t0 * 4
	move $a2, $t2
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal logFrogLeftLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $t0, $t0, 1
	j logDetectionLeftLoop
logDetectionLeftLoopExit:
	jr $ra

logFrogLeftLoopSetup:
	add $t9, $zero, $zero # $t9 = 0
	addi $t8, $zero, 16 # $t8 = 16
logFrogLeftLoop:
	beq $t9, $t8, logFrogLeftLoopExit # while $t9 < $t8
	addi $t3, $zero, 4
	mul $t3, $t9, $t3 # $t4 = $t9 * 4
	add $t3, $t3, $a0
	lw $t3, ($t3) # $t4 = frog_pos[i]
	add $t4, $a1, $a2
	lw $t4, ($t4) # $t5 = some_space[j]
	beq $t3, $t4, moveWithLogLeft
	addi $t9, $t9, 1
	j logFrogLeftLoop
logFrogLeftLoopExit:
	jr $ra


logDetectionRightFastLoopSetup:
	add $t0, $zero, $zero # $t0 = 0
	addi $t1, $zero, 128 # $t1 = 128
logDetectionRightFastLoop:
	beq $t0, $t1, logDetectionRightFastLoopExit # while $t0 < $t1
	addi $t2, $zero, 4
	mul $t2, $t2, $t0 # $t3 = $t0 * 4
	move $a2, $t2
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal logFrogRightFastLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $t0, $t0, 1
	j logDetectionRightFastLoop
logDetectionRightFastLoopExit:
	jr $ra



logFrogRightFastLoopSetup:
	add $t9, $zero, $zero # $t9 = 0
	addi $t8, $zero, 16 # $t8 = 16
logFrogRightFastLoop:
	beq $t9, $t8, logFrogRightFastLoopExit # while $t9 < $t8
	addi $t3, $zero, 4
	mul $t3, $t9, $t3 # $t4 = $t9 * 4
	add $t3, $t3, $a0
	lw $t3, ($t3) # $t4 = frog_pos[i]
	add $t4, $a1, $a2
	lw $t4, ($t4) # $t5 = some_space[j]
	beq $t3, $t4, moveWithLogRightFast
	addi $t9, $t9, 1
	j logFrogRightFastLoop
logFrogRightFastLoopExit:
	jr $ra


logDetectionLeftFastLoopSetup:
	add $t0, $zero, $zero # $t0 = 0
	addi $t1, $zero, 128 # $t1 = 128
logDetectionLeftFastLoop:
	beq $t0, $t1, logDetectionLeftFastLoopExit # while $t0 < $t1
	addi $t2, $zero, 4
	mul $t2, $t2, $t0 # $t3 = $t0 * 4
	move $a2, $t2

	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal logFrogLeftFastLoopSetup
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $t0, $t0, 1
	j logDetectionLeftFastLoop
logDetectionLeftFastLoopExit:
	jr $ra


logFrogLeftFastLoopSetup:
	add $t9, $zero, $zero # $t9 = 0
	addi $t8, $zero, 16 # $t8 = 16
logFrogLeftFastLoop:
	beq $t9, $t8, logFrogLeftFastLoopExit # while $t9 < $t8
	addi $t3, $zero, 4
	mul $t3, $t9, $t3 # $t4 = $t9 * 4
	add $t3, $t3, $a0
	lw $t3, ($t3) # $t4 = frog_pos[i]
	add $t4, $a1, $a2
	lw $t4, ($t4) # $t5 = some_space[j]
	beq $t3, $t4, moveWithLogLeftFast
	addi $t9, $t9, 1
	j logFrogLeftFastLoop
logFrogLeftFastLoopExit:
	jr $ra
### End of collision detection loops ###


### Beginning of moving with logs ###
moveWithLogRight:
	lw $t0, frog_x
	addi $t0, $t0, 8
	addi $t1, $zero, 240
	ble $t0, $t1, moveWithLogRightMove
	sw $t1, frog_x
	j keyboardCheck
moveWithLogRightMove:
	sw $t0, frog_x
	j keyboardCheck

moveWithLogLeft:
	lw $t0, frog_x
	addi $t0, $t0, -8
	bge $t0, $zero, moveWithLogLeftMove
	sw $zero, frog_x
	j keyboardCheck
moveWithLogLeftMove:
	sw $t0, frog_x
	j keyboardCheck

moveWithLogRightFast:
	lw $t0, frog_x
	addi $t0, $t0, 16
	addi $t1, $zero, 240
	ble $t0, $t1, moveWithLogRightFastMove
	sw $t1, frog_x
	j keyboardCheck
moveWithLogRightFastMove:
	sw $t0, frog_x
	j keyboardCheck

moveWithLogLeftFast:
	lw $t0, frog_x
	addi $t0, $t0, -12
	bge $t0, $zero, moveWithLogLeftFastMove
	sw $zero, frog_x
	j keyboardCheck
moveWithLogLeftFastMove:
	sw $t0, frog_x
	j keyboardCheck
### End of moving with logs ###


### Beginning of obstacle movement loops ###
moveObstaclesRightLoopSetup: # change the values in the array at $t9 by adding the value 4 but if it exceeds the value at $t8, subtract 1024
	add $t0, $zero, $zero
	add $t1, $zero, 128
moveObstaclesRightLoop:
	beq $t0, $t1, moveObstaclesRightQuit
	addi $t2, $zero, 4
	mul $t3, $t0, $t2
	add $t4, $t9, $t3 # address where it needs to change
	lw $t5, 0($t4) # get the value the memory was holding at that address and store in $t5
	addi $t5, $t5, 8 # add 8 to that value
	bge $t5, $t8, moveObstaclesRightLoopElse
	sw $t5, 0($t4)
	addi $t0, $t0, 1
	j moveObstaclesRightLoop
moveObstaclesRightLoopElse:
	addi $t5, $t5, -1024
	sw $t5, 0($t4)
	addi $t0, $t0, 1
	j moveObstaclesRightLoop
moveObstaclesRightQuit:
	jr $ra

moveObstaclesRightFastLoopSetup: # change the values in the array at $t9 by adding the value 4 but if it exceeds the value at $t8, subtract 1024
	add $t0, $zero, $zero
	add $t1, $zero, 128
moveObstaclesRightFastLoop:
	beq $t0, $t1, moveObstaclesRightFastQuit
	addi $t2, $zero, 4
	mul $t3, $t0, $t2
	add $t4, $t9, $t3 # address where it needs to change
	lw $t5, 0($t4) # get the value the memory was holding at that address and store in $t5
	addi $t5, $t5, 16 # add 12 to that value
	bge $t5, $t8, moveObstaclesRightFastLoopElse
	sw $t5, 0($t4)
	addi $t0, $t0, 1
	j moveObstaclesRightFastLoop
moveObstaclesRightFastLoopElse:
	addi $t5, $t5, -1024
	sw $t5, 0($t4)
	addi $t0, $t0, 1
	j moveObstaclesRightFastLoop
moveObstaclesRightFastQuit:
	jr $ra

moveObstaclesLeftLoopSetup: # change the values in the array at $t9 by adding the value -4 but if it goes below the value at $t8, add 1024
	add $t0, $zero, $zero
	add $t1, $zero, 128
moveObstaclesLeftLoop:
	beq $t0, $t1, moveObstaclesLeftQuit
	addi $t2, $zero, 4
	mul $t3, $t0, $t2
	add $t4, $t9, $t3 # address where it needs to change
	lw $t5, 0($t4) # get the value the memory was holding at that address and store in $t5
	addi $t5, $t5, -8 # add -4 to that value
	blt $t5, $t8, moveObstaclesLeftLoopElse
	sw $t5, 0($t4)
	addi $t0, $t0, 1
	j moveObstaclesLeftLoop
moveObstaclesLeftLoopElse:
	addi $t5, $t5, 1024
	sw $t5, 0($t4)
	addi $t0, $t0, 1
	j moveObstaclesLeftLoop
moveObstaclesLeftQuit:
	jr $ra

moveObstaclesLeftFastLoopSetup: # change the values in the array at $t9 by adding the value 4 but if it exceeds the value at $t8, subtract 512
	add $t0, $zero, $zero
	add $t1, $zero, 128
moveObstaclesLeftFastLoop:
	beq $t0, $t1, moveObstaclesLeftFastQuit
	addi $t2, $zero, 4
	mul $t3, $t0, $t2
	add $t4, $t9, $t3 # address where it needs to change
	lw $t5, 0($t4) # get the value the memory was holding at that address and store in $t5
	addi $t5, $t5, -12 # add 4 to that value
	blt $t5, $t8, moveObstaclesLeftFastLoopElse
	sw $t5, 0($t4)
	addi $t0, $t0, 1
	j moveObstaclesLeftFastLoop
moveObstaclesLeftFastLoopElse:
	addi $t5, $t5, 1024
	sw $t5, 0($t4)
	addi $t0, $t0, 1
	j moveObstaclesLeftFastLoop
moveObstaclesLeftFastQuit:
	jr $ra
### End of obstacle movement loops ###


### Beginning of drawing the number of lives left ###
drawLives3:
	lw $t9, displayAddress
	sw $t0, 0($t9)
	sw $t0, 4($t9)
	sw $t0, 8($t9)
	sw $t0, 264($t9)
	sw $t0, 512($t9)
	sw $t0, 516($t9)
	sw $t0, 520($t9)
	sw $t0, 776($t9)
	sw $t0, 1024($t9)
	sw $t0, 1028($t9)
	sw $t0, 1032($t9)
	j drawObstacles
drawLives2:
	lw $t9, displayAddress
	sw $t0, 0($t9)
	sw $t0, 4($t9)
	sw $t0, 8($t9)
	sw $t0, 264($t9)
	sw $t0, 512($t9)
	sw $t0, 516($t9)
	sw $t0, 520($t9)
	sw $t0, 768($t9)
	sw $t0, 1024($t9)
	sw $t0, 1028($t9)
	sw $t0, 1032($t9)
	j drawObstacles
drawLives1:
	lw $t9, displayAddress
	sw $t0, 8($t9)
	sw $t0, 264($t9)
	sw $t0, 520($t9)
	sw $t0, 776($t9)
	sw $t0, 1032($t9)
	j drawObstacles
drawLives0:
	lw $t9, displayAddress
	sw $t0, 0($t9)
	sw $t0, 4($t9)
	sw $t0, 8($t9)
	sw $t0, 256($t9)
	sw $t0, 512($t9)
	sw $t0, 768($t9)
	sw $t0, 1024($t9)
	sw $t0, 1028($t9)
	sw $t0, 1032($t9)
	sw $t0, 776($t9)
	sw $t0, 520($t9)
	sw $t0, 264($t9)
	j drawObstacles
### End of drawing the number of lives left ###
	
	
### Death Process (sadge) ###
deathProcess:
	li $v0, 31
	lw $a0, deathSound
	lw $a1, deathSoundDuration
	lw $a2, deathSoundInstrument
	lw $a3, deathSoundVolume
	syscall
	
	lw $t0, frog_x_initial
	lw $t1, frog_y_initial
	sw $t0, frog_x
	sw $t1, frog_y
	lw $t2, num_lives
	addi $t2, $t2, -1
	blt $t2, $zero, playGameEndSound
	sw $t2, num_lives
	j fillSpaces
### Death Process (sadge) ###


### endGameSound ###
playGameEndSound:
	li $v0, 31
	lw $a0, gameEndSound
	lw $a1, gameEndSoundDuration
	lw $a2, gameEndSoundInstrument
	lw $a3, gameEndSoundVolume
	syscall
	
	li $v0, 32
	li $a0, 100
	syscall
	
	li $v0, 31
	lw $a0, gameEndSound2
	lw $a1, gameEndSoundDuration2
	lw $a2, gameEndSoundInstrument2
	lw $a3, gameEndSoundVolume2
	syscall
	j endScreen
### endGameSound ###


### goalSound ###
playGoalSound:
	li $v0, 31
	lw $a0, goalSound
	lw $a1, goalSoundDuration
	lw $a2, goalSoundInstrument
	lw $a3, goalSoundVolume
	syscall
	
	li $v0, 32
	li $a0, 200
	syscall
	
	li $v0, 31
	lw $a0, goalSound2
	lw $a1, goalSoundDuration2
	lw $a2, goalSoundInstrument2
	lw $a3, goalSoundVolume2
	syscall

	li $v0, 32
	li $a0, 100
	syscall

	li $v0, 31
	lw $a0, goalSound3
	lw $a1, goalSoundDuration3
	lw $a2, goalSoundInstrument3
	lw $a3, goalSoundVolume3
	syscall
	
	jr $ra
### goalSound ###


### movementSound ###
playMovementSound:
	li $v0, 31
	lw $a0, movementSound
	lw $a1, movementSoundDuration
	lw $a2, movementSoundInstrument
	lw $a3, movementSoundVolume
	syscall
	
	jr $ra
### movementSound ###
	
	
### Beginning of win condition (possible fail) ###
winCon:
	lw $t0, frog_x
	addi $t1, $zero, 64
	ble $t0, $t1, f1YAY
	addi $t1, $zero, 160
	ble $t0, $t1, f2YAY
	j f3YAY

f1YAY:
	addi $t1, $zero, 1
	lw $t2, f1bool
	bne $t2, $zero, deathProcess
	
	jal playGoalSound
	
	sw $t1, f1bool
	lw $t3, frog_x_initial
	lw $t4, frog_y_initial
	sw $t3, frog_x
	sw $t4, frog_y
	j fillSpaces

f2YAY:
	addi $t1, $zero, 1
	lw $t2, f2bool
	bne $t2, $zero, deathProcess
	
	jal playGoalSound
	
	sw $t1, f2bool
	lw $t3, frog_x_initial
	lw $t4, frog_y_initial
	sw $t3, frog_x
	sw $t4, frog_y
	j fillSpaces

f3YAY:
	addi $t1, $zero, 1
	lw $t2, f3bool
	bne $t2, $zero, deathProcess
	
	jal playGoalSound
	
	sw $t1, f3bool
	lw $t3, frog_x_initial
	lw $t4, frog_y_initial
	sw $t3, frog_x
	sw $t4, frog_y
	j fillSpaces
### End of win condition ###
	
	
### Beginning of drawing the points ###
drawZero:
	lw $t9, waterColor # set color to livesColor
	lw $t5, displayAddress
	sw $t9, 244($t5)
	sw $t9, 248($t5)
	sw $t9, 252($t5)
	sw $t9, 508($t5)
	sw $t9, 764($t5)
	sw $t9, 1020($t5)
	sw $t9, 1276($t5)
	sw $t9, 1272($t5)
	sw $t9, 1268($t5)
	sw $t9, 1012($t5)
	sw $t9, 756($t5)
	sw $t9, 500($t5)
	j drawFrog

drawOneHundred:
	lw $t9, waterColor # set color to livesColor
	lw $t5, displayAddress
	sw $t9, 244($t5)
	sw $t9, 248($t5)
	sw $t9, 252($t5)
	sw $t9, 508($t5)
	sw $t9, 764($t5)
	sw $t9, 1020($t5)
	sw $t9, 1276($t5)
	sw $t9, 1272($t5)
	sw $t9, 1268($t5)
	sw $t9, 1012($t5)
	sw $t9, 756($t5)
	sw $t9, 500($t5) # far right 0

	sw $t9, 228($t5)
	sw $t9, 232($t5)
	sw $t9, 236($t5)
	sw $t9, 492($t5)
	sw $t9, 748($t5)
	sw $t9, 1004($t5)
	sw $t9, 1260($t5)
	sw $t9, 1256($t5)
	sw $t9, 1252($t5)
	sw $t9, 996($t5)
	sw $t9, 740($t5)
	sw $t9, 484($t5) # middle 0
	
	sw $t9, 220($t5)
	sw $t9, 476($t5)
	sw $t9, 732($t5)
	sw $t9, 988($t5)
	sw $t9, 1244($t5)
	j drawFrog

drawTwoHundred:
	lw $t9, waterColor # set color to livesColor
	lw $t5, displayAddress
	sw $t9, 244($t5)
	sw $t9, 248($t5)
	sw $t9, 252($t5)
	sw $t9, 508($t5)
	sw $t9, 764($t5)
	sw $t9, 1020($t5)
	sw $t9, 1276($t5)
	sw $t9, 1272($t5)
	sw $t9, 1268($t5)
	sw $t9, 1012($t5)
	sw $t9, 756($t5)
	sw $t9, 500($t5) # far right 0

	sw $t9, 228($t5)
	sw $t9, 232($t5)
	sw $t9, 236($t5)
	sw $t9, 492($t5)
	sw $t9, 748($t5)
	sw $t9, 1004($t5)
	sw $t9, 1260($t5)
	sw $t9, 1256($t5)
	sw $t9, 1252($t5)
	sw $t9, 996($t5)
	sw $t9, 740($t5)
	sw $t9, 484($t5) # middle 0
	
	sw $t9, 220($t5)
	sw $t9, 216($t5)
	sw $t9, 212($t5)
	sw $t9, 476($t5)
	sw $t9, 732($t5)
	sw $t9, 728($t5)
	sw $t9, 724($t5)
	sw $t9, 980($t5)
	sw $t9, 1236($t5)
	sw $t9, 1240($t5)
	sw $t9, 1244($t5)
	j drawFrog

drawThreeHundred:
	lw $t9, waterColor # set color to livesColor
	lw $t5, displayAddress
	sw $t9, 244($t5)
	sw $t9, 248($t5)
	sw $t9, 252($t5)
	sw $t9, 508($t5)
	sw $t9, 764($t5)
	sw $t9, 1020($t5)
	sw $t9, 1276($t5)
	sw $t9, 1272($t5)
	sw $t9, 1268($t5)
	sw $t9, 1012($t5)
	sw $t9, 756($t5)
	sw $t9, 500($t5) # far right 0

	sw $t9, 228($t5)
	sw $t9, 232($t5)
	sw $t9, 236($t5)
	sw $t9, 492($t5)
	sw $t9, 748($t5)
	sw $t9, 1004($t5)
	sw $t9, 1260($t5)
	sw $t9, 1256($t5)
	sw $t9, 1252($t5)
	sw $t9, 996($t5)
	sw $t9, 740($t5)
	sw $t9, 484($t5) # middle 0
	
	sw $t9, 220($t5)
	sw $t9, 216($t5)
	sw $t9, 212($t5)
	sw $t9, 476($t5)
	sw $t9, 732($t5)
	sw $t9, 728($t5)
	sw $t9, 724($t5)
	sw $t9, 988($t5)
	sw $t9, 1236($t5)
	sw $t9, 1240($t5)
	sw $t9, 1244($t5)
	j drawFrog
### End of drawing the points ###
	
	
### Beginning of drawing the beautiful scenery ###
drawSucc: # draw the space $t9 (size 256 bytes) with color $t5
	add $t0, $zero, $zero
	addi $t1, $zero, 64
drawSuccLoop:
	beq $t0, $t1, drawSuccQuit
	add $t3, $zero, 4
	mul $t2, $t0, $t3
	add $t8, $t9, $t2
	lw $t7, 0($t8)
	sw $t5, 0($t7)
	addi $t0, $t0, 1
	j drawSuccLoop
drawSuccQuit:
	jr $ra

drawFail: # draw the space $t9 (size 1024 bytes) with color $t5
	add $t0, $zero, $zero
	addi $t1, $zero, 64
drawFailLoop:
	beq $t0, $t1, drawFailQuit
	add $t3, $zero, 4
	mul $t2, $t0, $t3
	add $t8, $t9, $t2
	lw $t7, 0($t8)
	sw $t5, 0($t7)
	addi $t0, $t0, 1
	j drawFailLoop
drawFailQuit:
	jr $ra

drawObs: # draw the space $t9 (size 512 bytes) with color $t5
	add $t0, $zero, $zero
	addi $t1, $zero, 128
drawObsLoop:
	beq $t0, $t1, drawObsQuit
	add $t3, $zero, 4
	mul $t2, $t0, $t3
	add $t8, $t9, $t2
	lw $t7, 0($t8)
	sw $t5, 0($t7)
	addi $t0, $t0, 1
	j drawObsLoop
drawObsQuit:
	jr $ra

drawRectangle: # draw a $t0 colored rectangle starting from $t1'th row with size $t2
	lw $t9, displayAddress # set $t9 to the displayAddress start
	mul $t1, $t1, 256
	mul $t2, $t2, 256
	add $t1, $t1, $t9 # $t1 is the starting point of the drawing
	addi $t3, $zero, 0
drawRectangleLoop:
	beq $t3, $t2, drawRectangleQuit
	add $t4, $t1, $t3
	sw $t0, 0($t4)
	addi $t3, $t3, 4
	j drawRectangleLoop
drawRectangleQuit:
	jr $ra
### End of drawing the beautiful scenery ###


### tfw you won poggies ###
youWON:
# play a sick sound
	li $v0, 31
	lw $a0, winSound
	lw $a1, winSoundDuration
	lw $a2, winSoundInstrument
	lw $a3, winSoundVolume
	syscall
	
	li $v0, 32
	li $a0, 200
	syscall
	
	li $v0, 31
	lw $a0, winSound
	lw $a1, winSoundDuration
	lw $a2, winSoundInstrument
	lw $a3, winSoundVolume
	syscall

	li $v0, 32
	li $a0, 200
	syscall

	li $v0, 31
	lw $a0, winSound
	lw $a1, winSoundDuration2
	lw $a2, winSoundInstrument
	lw $a3, winSoundVolume
	syscall
	
# now a sick screen to let you know you won (yes this is pretty bad)
	addi $t1, $zero, 300
	addi $t4, $zero, 16384
	add $t2, $zero, $zero
	lw $t5, displayAddress
yellowScreen:
	beq $t2, $t4, youWONmessage
	add $t6, $t5, $t2
	addi $t7, $zero, 0xadd8e6
	sw $t7, 0($t6)
	addi $t2, $t2, 4
	j yellowScreen
youWONmessage:
	lw $t5, displayAddress
	addi $t9, $zero, 0x0000ff
	sw $t9, 7200($t5)
	sw $t9, 7456($t5)
	sw $t9, 7712($t5)
	sw $t9, 7968($t5)
	sw $t9, 8224($t5)
	sw $t9, 7204($t5)
	sw $t9, 7208($t5)
	sw $t9, 7464($t5)
	sw $t9, 7716($t5)
	sw $t9, 7976($t5)
	sw $t9, 8232($t5) # R
	sw $t9, 8744($t5)
	sw $t9, 8740($t5)
	sw $t9, 8736($t5) # underline
	sw $t9, 7220($t5)
	sw $t9, 7224($t5)
	sw $t9, 7228($t5)
	sw $t9, 7476($t5)
	sw $t9, 7732($t5)
	sw $t9, 7736($t5)
	sw $t9, 7740($t5)
	sw $t9, 7988($t5)
	sw $t9, 8244($t5)
	sw $t9, 8248($t5)
	sw $t9, 8252($t5) # E
	sw $t9, 7240($t5)
	sw $t9, 7244($t5)
	sw $t9, 7500($t5)
	sw $t9, 7756($t5)
	sw $t9, 8012($t5)
	sw $t9, 8268($t5)
	sw $t9, 7248($t5) # T
	sw $t9, 7260($t5)
	sw $t9, 7516($t5)
	sw $t9, 7772($t5)
	sw $t9, 8028($t5)
	sw $t9, 8284($t5)
	sw $t9, 7264($t5)
	sw $t9, 7268($t5)
	sw $t9, 7524($t5)
	sw $t9, 7776($t5)
	sw $t9, 8036($t5)
	sw $t9, 8292($t5) # R
	sw $t9, 7280($t5)
	sw $t9, 7536($t5)
	sw $t9, 7540($t5)
	sw $t9, 7544($t5)
	sw $t9, 7288($t5)
	sw $t9, 7796($t5)
	sw $t9, 8052($t5)
	sw $t9, 8308($t5) # Y
	sw $t9, 9292($t5)
	sw $t9, 9548($t5)
	sw $t9, 9804($t5)
	sw $t9, 10060($t5)
	sw $t9, 10316($t5)
	sw $t9, 10320($t5)
	sw $t9, 10324($t5)
	sw $t9, 10328($t5)
	sw $t9, 9296($t5)
	sw $t9, 9300($t5)
	sw $t9, 9556($t5)
	sw $t9, 9812($t5)
	sw $t9, 10068($t5) # Q
	sw $t9, 10828($t5)
	sw $t9, 10832($t5)
	sw $t9, 10836($t5) # underline
	sw $t9, 9312($t5)
	sw $t9, 9568($t5)
	sw $t9, 9824($t5)
	sw $t9, 10080($t5)
	sw $t9, 10336($t5)
	sw $t9, 10340($t5)
	sw $t9, 10344($t5)
	sw $t9, 10088($t5)
	sw $t9, 9832($t5)
	sw $t9, 9576($t5)
	sw $t9, 9320($t5) # U
	sw $t9, 9332($t5)
	sw $t9, 9588($t5)
	sw $t9, 9844($t5)
	sw $t9, 10100($t5)
	sw $t9, 10356($t5) # I
	sw $t9, 9344($t5)
	sw $t9, 9348($t5)
	sw $t9, 9604($t5)
	sw $t9, 9860($t5)
	sw $t9, 10116($t5)
	sw $t9, 10372($t5)
	sw $t9, 9352($t5) # T
	sw $t9, 3200($t5)
	sw $t9, 3456($t5)
	sw $t9, 3712($t5)
	sw $t9, 3716($t5)
	sw $t9, 3720($t5)
	sw $t9, 3204($t5)
	sw $t9, 3208($t5)
	sw $t9, 3464($t5)
	sw $t9, 3968($t5)
	sw $t9, 4224($t5) # P
	sw $t9, 3220($t5)
	sw $t9, 3224($t5)
	sw $t9, 3480($t5)
	sw $t9, 3736($t5)
	sw $t9, 3992($t5)
	sw $t9, 4248($t5)
	sw $t9, 3228($t5) # T
	sw $t9, 3240($t5)
	sw $t9, 3244($t5)
	sw $t9, 3248($t5)
	sw $t9, 3496($t5)
	sw $t9, 3752($t5)
	sw $t9, 3756($t5)
	sw $t9, 3760($t5)
	sw $t9, 4016($t5)
	sw $t9, 4272($t5)
	sw $t9, 4268($t5)
	sw $t9, 4264($t5) # S
	sw $t9, 552($t5)
	sw $t9, 808($t5)
	sw $t9, 812($t5)
	sw $t9, 816($t5)
	sw $t9, 560($t5)
	sw $t9, 1068($t5)
	sw $t9, 1324($t5)
	sw $t9, 1580($t5) # Y
	sw $t9, 568($t5)
	sw $t9, 572($t5)
	sw $t9, 576($t5)
	sw $t9, 832($t5)
	sw $t9, 1088($t5)
	sw $t9, 1344($t5)
	sw $t9, 1600($t5)
	sw $t9, 1596($t5)
	sw $t9, 1592($t5)
	sw $t9, 1336($t5)
	sw $t9, 1080($t5)
	sw $t9, 824($t5) # O
	sw $t9, 584($t5)
	sw $t9, 840($t5)
	sw $t9, 1096($t5)
	sw $t9, 1352($t5)
	sw $t9, 1608($t5)
	sw $t9, 1612($t5)
	sw $t9, 1616($t5)
	sw $t9, 1360($t5)
	sw $t9, 1104($t5)
	sw $t9, 848($t5)
	sw $t9, 592($t5) # U
	sw $t9, 608($t5)
	sw $t9, 864($t5)
	sw $t9, 1120($t5)
	sw $t9, 1376($t5)
	sw $t9, 1632($t5)
	sw $t9, 1636($t5)
	sw $t9, 1640($t5)
	sw $t9, 1384($t5)
	sw $t9, 1128($t5)
	sw $t9, 872($t5)
	sw $t9, 616($t5)
	sw $t9, 1644($t5)
	sw $t9, 1648($t5)
	sw $t9, 1392($t5)
	sw $t9, 1136($t5)
	sw $t9, 880($t5)
	sw $t9, 624($t5) # W
	sw $t9, 632($t5)
	sw $t9, 888($t5)
	sw $t9, 1144($t5)
	sw $t9, 1400($t5)
	sw $t9, 1656($t5)
	sw $t9, 1660($t5)
	sw $t9, 1664($t5)
	sw $t9, 1408($t5)
	sw $t9, 1152($t5)
	sw $t9, 896($t5)
	sw $t9, 640($t5)
	sw $t9, 636($t5) # O
	sw $t9, 648($t5)
	sw $t9, 904($t5)
	sw $t9, 1160($t5)
	sw $t9, 1416($t5)
	sw $t9, 1672($t5)
	sw $t9, 908($t5)
	sw $t9, 1168($t5)
	sw $t9, 1428($t5)
	sw $t9, 1688($t5)
	sw $t9, 1432($t5)
	sw $t9, 1176($t5)
	sw $t9, 920($t5)
	sw $t9, 664($t5) # N
	sw $t9, 680($t5)
	sw $t9, 936($t5)
	sw $t9, 1192($t5)
	sw $t9, 1704($t5) # !
	j endMessage
### End of letting you know you won... ###
	

### tfw you didn't win sadge ###
endScreen:
	lw $t1, f1bool
	lw $t2, f2bool
	lw $t3, f3bool
	addi $t4, $zero, 100
	mul $t1, $t1, $t4
	mul $t2, $t2, $t4
	mul $t3, $t3, $t4
	add $t1, $t1, $t2
	add $t1, $t1, $t3 # $t1 holds the points the user ended with
	addi $t4, $zero, 16384
	add $t2, $zero, $zero
	lw $t5, displayAddress
blackScreen:
	beq $t2, $t4, endMessageTemplate
	add $t6, $t5, $t2
	addi $t7, $zero, 0x000000
	sw $t7, 0($t6)
	addi $t2, $t2, 4
	j blackScreen
endMessageTemplate:
	lw $t5, displayAddress
	addi $t9, $zero, 0xffffff
	sw $t9, 7200($t5)
	sw $t9, 7456($t5)
	sw $t9, 7712($t5)
	sw $t9, 7968($t5)
	sw $t9, 8224($t5)
	sw $t9, 7204($t5)
	sw $t9, 7208($t5)
	sw $t9, 7464($t5)
	sw $t9, 7716($t5)
	sw $t9, 7976($t5)
	sw $t9, 8232($t5) # R
	sw $t9, 8744($t5)
	sw $t9, 8740($t5)
	sw $t9, 8736($t5) # underline
	sw $t9, 7220($t5)
	sw $t9, 7224($t5)
	sw $t9, 7228($t5)
	sw $t9, 7476($t5)
	sw $t9, 7732($t5)
	sw $t9, 7736($t5)
	sw $t9, 7740($t5)
	sw $t9, 7988($t5)
	sw $t9, 8244($t5)
	sw $t9, 8248($t5)
	sw $t9, 8252($t5) # E
	sw $t9, 7240($t5)
	sw $t9, 7244($t5)
	sw $t9, 7500($t5)
	sw $t9, 7756($t5)
	sw $t9, 8012($t5)
	sw $t9, 8268($t5)
	sw $t9, 7248($t5) # T
	sw $t9, 7260($t5)
	sw $t9, 7516($t5)
	sw $t9, 7772($t5)
	sw $t9, 8028($t5)
	sw $t9, 8284($t5)
	sw $t9, 7264($t5)
	sw $t9, 7268($t5)
	sw $t9, 7524($t5)
	sw $t9, 7776($t5)
	sw $t9, 8036($t5)
	sw $t9, 8292($t5) # R
	sw $t9, 7280($t5)
	sw $t9, 7536($t5)
	sw $t9, 7540($t5)
	sw $t9, 7544($t5)
	sw $t9, 7288($t5)
	sw $t9, 7796($t5)
	sw $t9, 8052($t5)
	sw $t9, 8308($t5) # Y
	sw $t9, 9292($t5)
	sw $t9, 9548($t5)
	sw $t9, 9804($t5)
	sw $t9, 10060($t5)
	sw $t9, 10316($t5)
	sw $t9, 10320($t5)
	sw $t9, 10324($t5)
	sw $t9, 10328($t5)
	sw $t9, 9296($t5)
	sw $t9, 9300($t5)
	sw $t9, 9556($t5)
	sw $t9, 9812($t5)
	sw $t9, 10068($t5) # Q
	sw $t9, 10828($t5)
	sw $t9, 10832($t5)
	sw $t9, 10836($t5) # underline
	sw $t9, 9312($t5)
	sw $t9, 9568($t5)
	sw $t9, 9824($t5)
	sw $t9, 10080($t5)
	sw $t9, 10336($t5)
	sw $t9, 10340($t5)
	sw $t9, 10344($t5)
	sw $t9, 10088($t5)
	sw $t9, 9832($t5)
	sw $t9, 9576($t5)
	sw $t9, 9320($t5) # U
	sw $t9, 9332($t5)
	sw $t9, 9588($t5)
	sw $t9, 9844($t5)
	sw $t9, 10100($t5)
	sw $t9, 10356($t5) # I
	sw $t9, 9344($t5)
	sw $t9, 9348($t5)
	sw $t9, 9604($t5)
	sw $t9, 9860($t5)
	sw $t9, 10116($t5)
	sw $t9, 10372($t5)
	sw $t9, 9352($t5) # T
	sw $t9, 3200($t5)
	sw $t9, 3456($t5)
	sw $t9, 3712($t5)
	sw $t9, 3716($t5)
	sw $t9, 3720($t5)
	sw $t9, 3204($t5)
	sw $t9, 3208($t5)
	sw $t9, 3464($t5)
	sw $t9, 3968($t5)
	sw $t9, 4224($t5) # P
	sw $t9, 3220($t5)
	sw $t9, 3224($t5)
	sw $t9, 3480($t5)
	sw $t9, 3736($t5)
	sw $t9, 3992($t5)
	sw $t9, 4248($t5)
	sw $t9, 3228($t5) # T
	sw $t9, 3240($t5)
	sw $t9, 3244($t5)
	sw $t9, 3248($t5)
	sw $t9, 3496($t5)
	sw $t9, 3752($t5)
	sw $t9, 3756($t5)
	sw $t9, 3760($t5)
	sw $t9, 4016($t5)
	sw $t9, 4272($t5)
	sw $t9, 4268($t5)
	sw $t9, 4264($t5) # S

# letting you know how many pts you had when you lost
endMessage:
	ble $t1, $zero, youSuck
	addi $t2, $zero, 100
	ble $t1, $t2, one_hundred_pts
	addi $t2, $zero, 200
	ble $t1, $t2, two_hundred_pts
	addi $t2, $zero, 300
	ble $t1, $t2, three_hundred_pts
three_hundred_pts:
	sw $t9, 3104($t5)
	sw $t9, 3108($t5)
	sw $t9, 3112($t5)
	sw $t9, 3368($t5)
	sw $t9, 3624($t5)
	sw $t9, 3620($t5)
	sw $t9, 3616($t5)
	sw $t9, 3880($t5)
	sw $t9, 4136($t5)
	sw $t9, 4132($t5)
	sw $t9, 4128($t5) # 3
	sw $t9, 3124($t5)
	sw $t9, 3128($t5)
	sw $t9, 3132($t5)
	sw $t9, 3388($t5)
	sw $t9, 3644($t5)
	sw $t9, 3900($t5)
	sw $t9, 4156($t5)
	sw $t9, 4152($t5)
	sw $t9, 4148($t5)
	sw $t9, 3892($t5)
	sw $t9, 3636($t5)
	sw $t9, 3380($t5) # 0
	sw $t9, 3144($t5)
	sw $t9, 3148($t5)
	sw $t9, 3152($t5)
	sw $t9, 3408($t5)
	sw $t9, 3664($t5)
	sw $t9, 3920($t5)
	sw $t9, 4176($t5)
	sw $t9, 4172($t5)
	sw $t9, 4168($t5)
	sw $t9, 3912($t5)
	sw $t9, 3656($t5)
	sw $t9, 3400($t5) # 0
	j endScreenCheck
two_hundred_pts:
	sw $t9, 3104($t5)
	sw $t9, 3108($t5)
	sw $t9, 3112($t5)
	sw $t9, 3368($t5)
	sw $t9, 3624($t5)
	sw $t9, 3620($t5)
	sw $t9, 3616($t5)
	sw $t9, 3872($t5)
	sw $t9, 4128($t5)
	sw $t9, 4132($t5)
	sw $t9, 4136($t5) # 2
	sw $t9, 3124($t5)
	sw $t9, 3128($t5)
	sw $t9, 3132($t5)
	sw $t9, 3388($t5)
	sw $t9, 3644($t5)
	sw $t9, 3900($t5)
	sw $t9, 4156($t5)
	sw $t9, 4152($t5)
	sw $t9, 4148($t5)
	sw $t9, 3892($t5)
	sw $t9, 3636($t5)
	sw $t9, 3380($t5) # 0
	sw $t9, 3144($t5)
	sw $t9, 3148($t5)
	sw $t9, 3152($t5)
	sw $t9, 3408($t5)
	sw $t9, 3664($t5)
	sw $t9, 3920($t5)
	sw $t9, 4176($t5)
	sw $t9, 4172($t5)
	sw $t9, 4168($t5)
	sw $t9, 3912($t5)
	sw $t9, 3656($t5)
	sw $t9, 3400($t5) # 0
	j endScreenCheck
one_hundred_pts:
	sw $t9, 3112($t5)
	sw $t9, 3368($t5)
	sw $t9, 3624($t5)
	sw $t9, 3880($t5)
	sw $t9, 4136($t5) # 1
	sw $t9, 3124($t5)
	sw $t9, 3128($t5)
	sw $t9, 3132($t5)
	sw $t9, 3388($t5)
	sw $t9, 3644($t5)
	sw $t9, 3900($t5)
	sw $t9, 4156($t5)
	sw $t9, 4152($t5)
	sw $t9, 4148($t5)
	sw $t9, 3892($t5)
	sw $t9, 3636($t5)
	sw $t9, 3380($t5) # 0
	sw $t9, 3144($t5)
	sw $t9, 3148($t5)
	sw $t9, 3152($t5)
	sw $t9, 3408($t5)
	sw $t9, 3664($t5)
	sw $t9, 3920($t5)
	sw $t9, 4176($t5)
	sw $t9, 4172($t5)
	sw $t9, 4168($t5)
	sw $t9, 3912($t5)
	sw $t9, 3656($t5)
	sw $t9, 3400($t5) # 0
	j endScreenCheck
youSuck:
	sw $t9, 3144($t5)
	sw $t9, 3148($t5)
	sw $t9, 3152($t5)
	sw $t9, 3408($t5)
	sw $t9, 3664($t5)
	sw $t9, 3920($t5)
	sw $t9, 4176($t5)
	sw $t9, 4172($t5)
	sw $t9, 4168($t5)
	sw $t9, 3912($t5)
	sw $t9, 3656($t5)
	sw $t9, 3400($t5) # 0
	j endScreenCheck

# asking the user if they want to play more
endScreenCheck: # get the text the user inputs
	li $v0, 32
	li $a0, 500
	syscall
	lw $t5, 0xffff0000
	beq $t5, 1, endScreenResult
	j endScreenCheck
endScreenResult:
	lw $t6, 0xffff0004
	beq $t6, 0x72, respondToR
	beq $t6, 0x71, respondToQEND
	j endScreenCheck
respondToR:
	j initialization
respondToQEND:
	j Exit
	

# when the user pauses
readPause: # Ask user to press P to continue
    	li $v0, 4
    	la $a0, pausePrompt
    	syscall
pauseCheck:
	# get the text the user inputs
	li $v0, 32
	li $a0, 500
	syscall
	lw $t5, 0xffff0000
	beq $t5, 1, pauseCheckCheck
	j pauseCheck
pauseCheckCheck:
	lw $t6, 0xffff0004
	beq $t6, 0x70, respondToPCHECK
	j pauseCheck
respondToPCHECK:
	j moveSpaces


# End game
Exit:
# turn the screen black before terminating the program!
	addi $t4, $zero, 16384
	add $t2, $zero, $zero
	lw $t5, displayAddress
ExitScreen:
	beq $t2, $t4, ExitForReal
	add $t6, $t5, $t2
	addi $t7, $zero, 0x000000
	sw $t7, 0($t6)
	addi $t2, $t2, 4
	j ExitScreen
ExitForReal:
	li $v0, 10 # terminate the program gracefully
	syscall
