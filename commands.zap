
	.SEGMENT "0"


	.FUNCT	V-GET-ADVICE:ANY:0:0
	ICALL2	WPRINTD,LEADER
	PRINTI	" asked the group for advice, but none was offered."
	RTRUE	


	.FUNCT	V-HELP:ANY:0:0
	PRINTI	"Journey is an interactive story in which you guide a party of characters through a dangerous quest. To learn about the background of your quest, select BACKGROUND after reading this material."
	CRLF	
	CRLF	
	PRINTI	"There are two types of commands that you can give; those which are performed for the entire party (e.g. moving from place to place, retreating after a losing battle) and those which are performed by an individual character (e.g. examining an object, casting a spell, mingling in a tavern.)  Party Commands are the leftmost column of commands on the screen; the next column lists the characters in your party; and the three following columns are for the Individual Commands."
	CRLF	
	CRLF	
	PRINTI	"To select a command of either type, simply use the arrow-keys on your keyboard to reposition the highlighted command on the screen (the ""cursor"") until that cursor rests on the command you desire; then hit RETURN. Alternatively, if you are using a mouse, move it such that the "
	CALL1	APPLE2?
	ZERO?	STACK /?CCL3
	PRINTI	"dot"
	JUMP	?CND1
?CCL3:	PRINTI	"arrow"
?CND1:	PRINTI	" on the screen is pointing to that command; then click your mouse button."
	CRLF	
	CRLF	
	PRINTI	"If you are using the keyboard, use the spacebar as a shortcut to move between the Party Commands and the Individual Commands. Also, typing the first letter of a command or object name will select that command or object."
	CRLF	
	CRLF	
	PRINTI	"Have fun!"
	CALL	NEW-DEFAULT,2,-1
	RSTACK	


	.FUNCT	V-BUY:ANY:0:0
	PRINTI	"We bought the "
	ICALL2	WPRINTD,ACTION-OBJECT
	PRINTI	" and packed it away."
	FSET	ACTION-OBJECT,DONT-EXAMINE
	ICALL	UPDATE-MOVE,ACTION-OBJECT,INVENTORY
	RTRUE	


	.FUNCT	V-CAST:ANY:0:0
	RFALSE	


	.FUNCT	O-CAST:ANY:0:0
	EQUAL?	ACTOR,TAG \?CND1
	ICALL2	FIND-OBJECT,TAG-POWDERS
	RTRUE	
?CND1:	CALL2	FIND-SPELL-OBJECTS,ALWAYS-SPELLS
	RSTACK	


	.FUNCT	FIND-SPELL-OBJECTS:ANY:1:2,OBJ,BIT,F,CNT
	FIRST?	OBJ >F /?PRG2
?PRG2:	ZERO?	F /TRUE
	EQUAL?	CNT,9 /TRUE
	CALL2	CHECK-ESSENCES,F
	ZERO?	STACK /?CND4
	CALL2	FIND-OBJECT,F >CNT
?CND4:	NEXT?	F >F /?PRG2
	JUMP	?PRG2


	.FUNCT	V-DROP:ANY:0:0
	FSET?	ACTION-OBJECT,DONT-DROP \?CCL3
	REMOVE	HYE-DROP
	ICALL1	FOOL-DROP
	JUMP	?CND1
?CCL3:	ICALL	UPDATE-MOVE,ACTION-OBJECT,HERE
	PRINTI	"Having no more need for the "
	ICALL2	WPRINTD,ACTION-OBJECT
	PRINTI	", we discarded it."
?CND1:	CALL	UPDATE-FSET,HERE,DONT-DROP
	RSTACK	


	.FUNCT	O-DROP:ANY:0:0
	CALL	FIND-OBJECTS,INVENTORY,NEVER-DROP
	RSTACK	


	.FUNCT	FOOL-DROP:ANY:0:0
	CALL2	CHARACTER-HERE?,PRAXIX
	ZERO?	STACK /?CCL3
	PRINTI	"Trying to lighten my load, I started to drop the "
	ICALL2	WPRINTD,ACTION-OBJECT
	PRINTI	" on the ground. """
	ICALL1	WPRINTTAG
	PRINTI	"!"" Praxix called out loudly, startling me. ""What on earth are you doing with that "
	ICALL2	WPRINTD,ACTION-OBJECT
	PRINTI	"? Dropping it here, of all places! How do you know we won't be needing such things? Now make yourself useful before I "
	CALL2	PICK-ONE,PRAXIX-FOOL-TBL
	PRINT	STACK
	PRINTI	"!"" I hardly think Praxix was being serious, or even that such a thing was possible, but he was almost certainly right about the "
	ICALL2	WPRINTD,ACTION-OBJECT
	PRINTC	46
	RTRUE	
?CCL3:	PRINTI	"I thought to lighten my load by dropping the "
	ICALL2	WPRINTD,ACTION-OBJECT
	PRINTI	", but felt that it would serve no purpose save giving Praxix an excuse to fry me in boiling oil when he found out."
	RTRUE	


	.FUNCT	V-EXAMINE:ANY:0:0
	GETPT	ACTION-OBJECT,P?EXBITS
	ZERO?	STACK /?CCL3
	ICALL	CLEAR-EXBIT,ACTION-OBJECT,ACTOR
	JUMP	?CND1
?CCL3:	FSET	ACTION-OBJECT,DONT-EXAMINE
?CND1:	ICALL2	WPRINTD,ACTOR
	PRINTI	" examined the "
	ICALL2	WPRINTD,ACTION-OBJECT
	PRINTI	", but found nothing of interest."
	RTRUE	


	.FUNCT	CLEAR-EXBIT:ANY:0:2,OBJ,CHR,?TMP1
	ASSIGNED?	'OBJ /?CND1
	SET	'OBJ,ACTION-OBJECT
?CND1:	ASSIGNED?	'CHR /?CND3
	SET	'CHR,ACTOR
?CND3:	SET	'UPDATE-FLAG,TRUE-VALUE
	GETP	OBJ,P?EXBITS >?TMP1
	GETP	CHR,P?CBIT
	BCOM	STACK
	BAND	?TMP1,STACK
	PUTP	OBJ,P?EXBITS,STACK
	RTRUE	


	.FUNCT	FIND-EXAMINE:ANY:1:1,OBJ,F,CNT,?TMP1
	FIRST?	OBJ >F /?PRG2
?PRG2:	ZERO?	F /TRUE
	EQUAL?	CNT,9 /TRUE
	FSET?	F,DONT-EXAMINE /?CND4
	GETPT	F,P?EXBITS
	ZERO?	STACK /?CCL9
	GETP	F,P?EXBITS >?TMP1
	GETP	ACTOR,P?CBIT
	BTST	?TMP1,STACK \?CND4
?CCL9:	CALL2	FIND-OBJECT,F >CNT
?CND4:	NEXT?	F >F /?PRG2
	JUMP	?PRG2


	.FUNCT	O-EXAMINE:ANY:0:0
	ICALL2	FIND-EXAMINE,HERE
	ZERO?	SUBGROUP-MODE /?CTR2
	FSET?	TAG,SUBGROUP \?CCL3
?CTR2:	ICALL2	FIND-EXAMINE,INVENTORY
	RTRUE	
?CCL3:	EQUAL?	ACTOR,PRAXIX \TRUE
	ICALL2	FIND-OBJECT,POUCH
	RTRUE	


	.FUNCT	V-TELL-STORY:ANY:0:0
	ICALL2	TELL-TALE,ACTION-OBJECT
	RTRUE	


	.FUNCT	V-TELL-LEGEND:ANY:0:0
	ICALL2	TELL-TALE,ACTION-OBJECT
	RTRUE	


	.FUNCT	O-TELL-LEGEND:ANY:0:0
	FSET?	HERE,DANGEROUS /TRUE
	FSET?	SCENE-OBJECT,DANGEROUS /TRUE
	EQUAL?	ACTOR,PRAXIX \?CCL7
	CALL2	FIND-OBJECTS,PRAXIX-TALES
	RSTACK	
?CCL7:	EQUAL?	ACTOR,HURTH \?CCL9
	CALL2	FIND-OBJECTS,HURTH-STORIES
	RSTACK	
?CCL9:	EQUAL?	ACTOR,UMBER \FALSE
	CALL2	FIND-OBJECTS,UMBER-STORIES
	RSTACK	


	.FUNCT	V-INVENTORY:ANY:0:1,UPD?,F
	ASSIGNED?	'UPD? /?CND1
	SET	'UPD?,TRUE-VALUE
?CND1:	EQUAL?	HERE,ASTRIX-MAZE \?CND3
	ICALL	UPDATE-FCLEAR,WEBBA-MAP,DONT-EXAMINE
?CND3:	PRINTI	"I checked our provisions at that point and found, in addition to the basic necessities of food and shelter, "
	CALL2	LIST-CONTENTS,INVENTORY
	ZERO?	STACK \?CND5
	PRINTI	"nothing whatever"
?CND5:	ZERO?	UPD? /?CND7
	ICALL	UPDATE-FSET,HERE,INVENTORIED
?CND7:	PRINTC	46
	RTRUE	


	.FUNCT	LIST-CONTENTS:ANY:1:2,OBJ,AF,F,N
	ASSIGNED?	'AF /?CND1
	SET	'AF,TRUE-VALUE
?CND1:	EQUAL?	OBJ,INVENTORY \?CND3
	REMOVE	POUCH
?CND3:	FIRST?	OBJ >F /?PRG9
	EQUAL?	OBJ,INVENTORY \FALSE
	MOVE	POUCH,INVENTORY
	RFALSE	
?PRG9:	ZERO?	F \?CCL13
	EQUAL?	OBJ,INVENTORY \TRUE
	MOVE	POUCH,INVENTORY
	RTRUE	
?CCL13:	EQUAL?	F,POUCH \?CCL17
	NEXT?	F >F /?PRG9
	JUMP	?PRG9
?CCL17:	ZERO?	AF /?CCL21
	PRINTI	"a "
	JUMP	?CND19
?CCL21:	PRINTI	"the "
?CND19:	ICALL2	WPRINTD,F
	NEXT?	F >F \?PRG9
	PRINTI	", "
	NEXT?	F /?PRG9
	PRINTI	"and "
	JUMP	?PRG9


	.FUNCT	V-NUL:ANY:0:0
	RFALSE	


	.FUNCT	V-RETREAT:ANY:0:0
	ICALL1	END-COMBAT
	PRINTI	"We retreated out of range of attack."
	RTRUE	


	.FUNCT	V-SCOUT:ANY:0:0
	ICALL	UPDATE-FSET,HERE,DONT-SCOUT
	ICALL2	WPRINTD,ACTOR
	PRINTI	" scouted out the area, but found nothing new of interest."
	RTRUE	


	.FUNCT	V-SELL:ANY:0:0
	PRINTI	"[Not implemented.]"
	RTRUE	


	.FUNCT	O-SELL:ANY:0:0
	EQUAL?	HERE,LANDS-END-TAVERN /TRUE
	CALL1	O-DROP
	RSTACK	


	.FUNCT	V-PICK-UP:ANY:0:0
	FSET	ACTION-OBJECT,DONT-EXAMINE
	ICALL	UPDATE-MOVE,ACTION-OBJECT,INVENTORY
	FSET?	TAG,SUBGROUP \?CCL3
	PRINTI	"I decided to take the "
	ICALL2	WPRINTD,ACTION-OBJECT
	PRINTI	", and"
	JUMP	?CND1
?CCL3:	PRINTI	"We decided to take the "
	ICALL2	WPRINTD,ACTION-OBJECT
	PRINTI	", so"
?CND1:	PRINTI	" I put it in my pack for safekeeping."
	RTRUE	


	.FUNCT	O-TAKE:ANY:0:0
	CALL	FIND-OBJECTS,HERE,DONT-TAKE
	RSTACK	


	.FUNCT	V-BUILD-RAFT:ANY:0:0
	FSET	RAFT,SEEN
	GETP	HERE,P?ENTER
	ICALL	STACK
	PRINTI	"There was "
	FSET?	RAFT,TRAPPED \?CND1
	PRINTI	"still "
?CND1:	PRINTI	"no suitable way of crossing the river on foot, so we determined to build a raft. After gathering some large branches, it was then a simple matter to lash them together with some of the rope we had been carrying. We then carved ourselves oars, and were soon ready to give the river crossing a"
	CALL	QSET?,RAFT,TRAPPED
	ZERO?	STACK /?CND3
	PRINTI	"nother"
?CND3:	PRINTI	" try."
	RTRUE	


	.FUNCT	V-LAUNCH-RAFT:ANY:0:0
	PRINTI	"""This would seem as good a spot as any,"" "
	FSET?	BERGON,IN-PARTY \?CCL3
	PRINTI	"Bergon"
	JUMP	?CND1
?CCL3:	PRINTI	"Praxix"
?CND1:	PRINTI	" said, indicating the spot where we would launch the raft."
	CRLF	
	CRLF	
	PRINTI	"This "
	EQUAL?	PARTY-MAX,2 \?CCL6
	PRINTI	"sounded good to me"
	JUMP	?CND4
?CCL6:	PRINTI	"met with general approval"
?CND4:	PRINTI	", and, having boarded the raft, we used our crude oars to push ourselves out into the current."
	GETP	HERE,P?TEMP
	PUTP	IN-RIVER,P?TEMP,STACK
	CALL2	MOVE-TO,IN-RIVER
	RSTACK	


	.FUNCT	V-SAVE:ANY:0:1,CAN?,SV
	ASSIGNED?	'CAN? /?CND1
	SET	'CAN?,TRUE-VALUE
?CND1:	ICALL1	TURN-ON-CURSOR
	EQUAL?	INTERPRETER,INT-PC \?CND3
	CRLF	
?CND3:	SAVE	 >SV
	ICALL1	TURN-OFF-CURSOR
	EQUAL?	SV,1 \?CCL7
	ICALL1	TURN-OFF-CURSOR
	PRINTI	"[Saved.]"
	ICALL1	REFRESH-CHECK
	JUMP	?CND5
?CCL7:	EQUAL?	SV,2,3 \?CCL9
	ICALL1	TURN-OFF-CURSOR
	CALL1	SCREEN-NEEDS-INIT
	ZERO?	STACK /?CCL12
	CRLF	
	PRINTI	"[Restored.]"
	JUMP	?CND10
?CCL12:	CLEAR	TEXT-WINDOW
	PRINTI	"[Restored.]"
?CND10:	REMOVE	I-CLEAR-SINGLE-MOVE-GRAPHIC
	EQUAL?	HERE,END-SESSION-ROOM \?CND13
	ICALL1	V-CANCEL
?CND13:	GET	0,8
	BTST	STACK,1 \?CCL17
	SET	'SCRIPTING-FLAG,TRUE-VALUE
	GET	0,8
	BTST	STACK,512 \?CCL20
	SET	'DONT-SCRIPT-INPUT,TRUE-VALUE
	JUMP	?CND15
?CCL20:	SET	'DONT-SCRIPT-INPUT,FALSE-VALUE
	JUMP	?CND15
?CCL17:	SET	'SCRIPTING-FLAG,FALSE-VALUE
?CND15:	ICALL2	REFRESH-CHECK,TRUE-VALUE
	JUMP	?CND5
?CCL9:	ICALL1	TURN-OFF-CURSOR
	PRINTI	"[Failed.]"
?CND5:	CRLF	
	ZERO?	CAN? /TRUE
	ICALL2	V-CANCEL,TRUE-VALUE
	RTRUE	


	.FUNCT	V-RESTORE:ANY:0:1,CAN?,FLG
	ASSIGNED?	'CAN? /?CND1
	SET	'CAN?,TRUE-VALUE
?CND1:	GET	0,8 >FLG
	ZERO?	DONT-SCRIPT-INPUT /?CCL5
	BOR	FLG,512
	PUT	0,8,STACK
	JUMP	?CND3
?CCL5:	BAND	FLG,511
	PUT	0,8,STACK
?CND3:	ICALL1	TURN-ON-CURSOR
	RESTORE	
	ZERO?	STACK /?CCL8
	PRINTI	"[Ok.]"
	JUMP	?CND6
?CCL8:	ICALL1	TURN-OFF-CURSOR
	PRINTI	"[Failed.]"
?CND6:	ICALL1	REFRESH-CHECK
	ZERO?	CAN? /TRUE
	ICALL2	V-CANCEL,TRUE-VALUE
	RTRUE	


	.FUNCT	SAVE-PARTY-COMMANDS:ANY:0:0
	COPYT	PARTY-COMMANDS,SAVED-PARTY-COMMANDS,12
	RTRUE	


	.FUNCT	RESTORE-PARTY-COMMANDS:ANY:0:0
	COPYT	SAVED-PARTY-COMMANDS,PARTY-COMMANDS,12
	ICALL2	PRINT-COLUMNS,TRUE-VALUE
	SET	'PUPDATE-FLAG,FALSE-VALUE
	RETURN	PUPDATE-FLAG


	.FUNCT	V-GAME:ANY:0:1,RM,T
	ASSIGNED?	'RM /?CND1
	SET	'RM,GAME-ROOM
?CND1:	ICALL1	GO-TO-GAME-MODE
	ICALL	MOVE-TO,RM,FALSE-VALUE,TRUE-VALUE,FALSE-VALUE
	ICALL1	CLEAR-FIELDS
	SET	'UPDATE-FLAG,FALSE-VALUE
	CALL1	RNUL
	RSTACK	


	.FUNCT	V-RESTART:ANY:0:0
	RESTART	
	RTRUE	


	.FUNCT	V-QUIT:ANY:0:0
	CLEAR	-1
	QUIT	
	RTRUE	


	.FUNCT	V-END-SESSION:ANY:0:0
	ICALL	MOVE-TO,END-SESSION-ROOM,FALSE-VALUE,TRUE-VALUE,FALSE-VALUE
	CALL1	RNUL
	RSTACK	


	.FUNCT	ANONF-3:ANY:0:0
	EQUAL?	ACTION,SAVE-COMMAND \FALSE
	ICALL2	REMOVE-PARTY-COMMAND,SAVE-COMMAND
	CALL2	V-SAVE,FALSE-VALUE
	RSTACK	


	.FUNCT	V-CONTROLS:ANY:0:0
	ZERO?	SCRIPTING-FLAG /?CCL3
	GET	0,8
	BTST	STACK,1 \?CCL3
	ICALL	CHANGE-TRAVEL-COMMAND,CONTROLS-ROOM,SCRIPT-ON-COMMAND,SCRIPT-OFF-COMMAND
	JUMP	?CND1
?CCL3:	SET	'SCRIPTING-FLAG,FALSE-VALUE
	ICALL	CHANGE-TRAVEL-COMMAND,CONTROLS-ROOM,SCRIPT-OFF-COMMAND,SCRIPT-ON-COMMAND
?CND1:	ICALL	MOVE-TO,CONTROLS-ROOM,FALSE-VALUE,TRUE-VALUE,FALSE-VALUE
	CALL1	RNUL
	RSTACK	


	.FUNCT	V-VERSION:ANY:0:0
	CRLF	
	PRINTI	"JOURNEY: Part I of the Golden Age Trilogy."
	CRLF	
	PRINTI	"Created by Marc Blank"
	CRLF	
	PRINTI	"Illustrations by Donald Langosy"
	CRLF	
	PRINTI	"(c) Copyright 1988, 1989 by Infocom, Inc."
	CRLF	
	PRINTI	"All rights reserved."
	CRLF	
	PRINTI	"JOURNEY is a trademark of Infocom, Inc."
	CRLF	
	ICALL1	TELL-GAME-ID
	CALL2	V-CANCEL,TRUE-VALUE
	RSTACK	


	.FUNCT	V-CHECK-DISK:ANY:0:0
	ICALL1	TELL-GAME-ID
	CRLF	
	PRINTI	"[Verifying.]"
	CRLF	
	VERIFY	 \?CCL3
	PRINTI	"Ok."
	JUMP	?CND1
?CCL3:	PRINTI	"** Bad **"
?CND1:	CALL2	V-CANCEL,TRUE-VALUE
	RSTACK	


	.FUNCT	V-SCRIPT-OFF:ANY:0:0
	SET	'SCRIPTING-FLAG,FALSE-VALUE
	DIROUT	-2
	CALL1	V-CANCEL
	RSTACK	


	.FUNCT	V-SCRIPT-ON:ANY:0:0
	ICALL	MOVE-TO,SCRIPT-ON-ROOM,FALSE-VALUE,TRUE-VALUE,FALSE-VALUE
	CALL1	RNUL
	RSTACK	


	.FUNCT	V-COMMANDS:ANY:0:0
	SET	'SCRIPTING-FLAG,TRUE-VALUE
	SET	'DONT-SCRIPT-INPUT,FALSE-VALUE
	DIROUT	2
	ICALL1	REFRESH-CHECK
	CALL1	V-CANCEL
	RSTACK	


	.FUNCT	V-NO-COMMANDS:ANY:0:0
	SET	'SCRIPTING-FLAG,TRUE-VALUE
	SET	'DONT-SCRIPT-INPUT,TRUE-VALUE
	DIROUT	2
	ICALL1	REFRESH-CHECK
	CALL1	V-CANCEL
	RSTACK	


	.FUNCT	V-REFRESH:ANY:0:0
	ICALL2	REFRESH-SCREEN,TRUE-VALUE
	CALL1	V-CANCEL
	RSTACK	


	.FUNCT	V-CANCEL:ANY:0:1,RT?
	ICALL	MOVE-TO,SAVED-GAME-ROOM,FALSE-VALUE,FALSE-VALUE,FALSE-VALUE
	ICALL	MODE,SAVED-GAME-MODE,FALSE-VALUE,TRUE-VALUE
	ICALL1	RESTORE-PARTY-COMMANDS
	SET	'SMART-DEFAULT-FLAG,TRUE-VALUE
	SET	'GAME-MODE,FALSE-VALUE
	SET	'UPDATE-FLAG,FALSE-VALUE
	ICALL1	PRINT-CHARACTER-COMMANDS
	ICALL2	PRINT-COLUMNS,TRUE-VALUE
	ZERO?	RT? \TRUE
	CALL1	RNUL
	RSTACK	


	.FUNCT	RNUL:ANY:0:0
	SET	'ACTION,NUL-COMMAND
	RTRUE	


	.FUNCT	ILLEGAL-NAME?:ANY:1:1,LEN,MAX,CNT,CNT2,TBL,TBL2,?TMP1
	GET	ILLEGAL-NAMES,0 >MAX
	ADD	NAME-TBL,2 >TBL
?PRG1:	IGRTR?	'CNT,MAX /FALSE
	GET	ILLEGAL-NAMES,CNT >TBL2
	GETB	TBL2,0
	EQUAL?	STACK,LEN \?PRG1
	INC	'TBL2
	SET	'CNT2,-1
?PRG8:	INC	'CNT2
	EQUAL?	CNT2,LEN /TRUE
	GETB	TBL2,CNT2 >?TMP1
	GETB	TBL,CNT2
	EQUAL?	?TMP1,STACK /?PRG8
	JUMP	?PRG1


	.FUNCT	V-CHANGE-NAME:ANY:0:0,OFF,CHR,LN,COL,TBL,CNT,MAX,KBD,FG,BG,?TMP2,?TMP1
	SET	'COL,NAME-COLUMN
	ICALL1	TURN-ON-CURSOR
	LESS?	SCREEN-WIDTH,8-WIDTH \?CCL3
	SET	'MAX,5
	JUMP	?CND1
?CCL3:	SET	'MAX,8
?CND1:	ICALL2	SELECT-SCREEN,COMMAND-WINDOW
	ZERO?	FWC-FLAG \?CND4
	WINGET	-3,11 >FG
	SHIFT	FG,-8 >BG
	BAND	FG,255 >FG
?CND4:	CALL2	PARTY-PCM,TAG
	ADD	COMMAND-START-LINE,STACK
	SUB	STACK,1 >LN
	ICALL	GCURSET,LN,COL
	ZERO?	FWC-FLAG \?CCL8
	COLOR	BG,FG
	ERASE	NAME-WIDTH-PIX
?CND6:	ICALL	GCURSET,LN,COL
	ADD	NAME-TBL,2 >TBL
?PRG16:	INPUT	1 >CHR
	EQUAL?	CHR,13 \?CCL20
	ICALL1	TURN-OFF-CURSOR
	ZERO?	OFF \?CCL23
	ZERO?	FWC-FLAG \?CND24
	COLOR	FG,BG
?CND24:	SET	'UPDATE-FLAG,TRUE-VALUE
	ICALL1	END-CHANGE-NAME
	CALL1	RNUL
	RSTACK	
?CCL8:	ZERO?	FONT3-FLAG \?PRG11
	HLIGHT	H-INVERSE
?PRG11:	IGRTR?	'CNT,MAX /?CND6
	PRINTC	95
	JUMP	?PRG11
?CCL23:	CALL2	ILLEGAL-NAME?,OFF
	ZERO?	STACK /?CND26
	ICALL1	END-CHANGE-NAME
	PRINTR	"[The name you have chosen is reserved. Please try again.]"
?CND26:	ICALL1	REMOVE-TRAVEL-COMMAND
	ZWSTR	NAME-TBL,OFF,2,TAG-NAME
	PUTP	TAG-OBJECT,P?KBD,KBD
	SET	'TAG-NAME-LENGTH,OFF
	SET	'UPDATE-FLAG,TRUE-VALUE
	ZERO?	FWC-FLAG \?CND28
	COLOR	FG,BG
?CND28:	ICALL1	END-CHANGE-NAME
	RTRUE	
?CCL20:	EQUAL?	CHR,DELETE-KEY,BACK-SPACE,LEFT-ARROW \?CCL31
	ZERO?	OFF \?CCL34
	SOUND	1
	JUMP	?PRG16
?CCL34:	ZERO?	FWC-FLAG \?CCL36
	DEC	'OFF
	ZERO?	OFF \?CCL39
	ICALL	GCURSET,LN,COL
	ERASE	NAME-WIDTH-PIX
	JUMP	?PRG16
?CCL39:	DIROUT	3,CENTER-TABLE
	PRINTT	TBL,OFF
	DIROUT	-3
	CALL	GPOS,LN,CHRV >?TMP1
	CALL	GPOS,COL,CHRH >?TMP2
	GET	0,24
	ADD	?TMP2,STACK
	CURSET	?TMP1,STACK
	GET	0,24
	SUB	NAME-WIDTH-PIX,STACK
	ERASE	STACK
	JUMP	?PRG16
?CCL36:	ICALL	GCURSET,LN,COL
	PRINTC	45
	DEC	'COL
	ICALL	GCURSET,LN,COL
	PRINTC	45
	DEC	'OFF
	ICALL	GCURSET,LN,COL
	JUMP	?PRG16
?CCL31:	LESS?	CHR,65 /?PRD43
	GRTR?	CHR,90 \?CTR40
?PRD43:	LESS?	CHR,97 /?CCL41
	GRTR?	CHR,122 /?CCL41
?CTR40:	EQUAL?	OFF,MAX \?CCL50
	SOUND	1
	JUMP	?PRG16
?CCL50:	ZERO?	OFF \?CCL52
	LESS?	CHR,97 /?CND53
	GRTR?	CHR,122 /?CND53
	SUB	CHR,32 >CHR
?CND53:	SET	'KBD,CHR
	JUMP	?CND48
?CCL52:	GRTR?	OFF,0 \?CND48
	LESS?	CHR,65 /?CND48
	GRTR?	CHR,90 /?CND48
	ADD	CHR,32 >CHR
?CND48:	PUTB	TBL,OFF,CHR
	INC	'OFF
	PRINTC	CHR
	ZERO?	FWC-FLAG /?PRG16
	INC	'COL
	ICALL	GCURSET,LN,COL
	JUMP	?PRG16
?CCL41:	SOUND	1
	JUMP	?PRG16


	.FUNCT	END-CHANGE-NAME:ANY:0:0,FOO
	CALL1	APPLE2?
	ZERO?	STACK \?CND1
	ZERO?	FONT3-FLAG \?CND3
	HLIGHT	H-NORMAL
?CND3:	ZERO?	FWC-FLAG \?CND1
	FONT	1 >FOO
?CND1:	CALL2	SELECT-SCREEN,TEXT-WINDOW
	RSTACK	

	.ENDSEG

	.ENDI
