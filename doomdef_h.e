note
	description: "[
		doomdef.h
		Internally used data structures for virtually everything,
		 key definitions, lots of other stuff.
	]"

class
	DOOMDEF_H

feature

	SCREENWIDTH: INTEGER = 320

	SCREENHEIGHT: INTEGER = 200

	MAXPLAYERS: INTEGER = 4

	TICRATE: INTEGER = 35 -- State updates, number of tics / second.

feature -- skill_t

	sk_baby: INTEGER = 0

	sk_easy: INTEGER = 1

	sk_medium: INTEGER = 2

	sk_hard: INTEGER = 3

	sk_nightmare: INTEGER = 4

feature -- DOOM keyboard definition

	KEY_RIGHTARROW: INTEGER = 0xae

	KEY_LEFTARROW: INTEGER = 0xac

	KEY_UPARROW: INTEGER = 0xad

	KEY_DOWNARROW: INTEGER = 0xaf

	KEY_RCTRL: INTEGER
		once
			Result := 0x80 + 0x1d
		end

	KEY_RALT: INTEGER
		once
			Result := 0x80 + 0x38
		end

	KEY_RSHIFT: INTEGER
		once
			Result := 0x80 + 0x36
		end

	KEY_F12: INTEGER
		once
			Result := 0x80 + 0x58
		ensure
			instance_free: class
		end

	KEY_PAUSE: INTEGER = 0xff

	KEY_ENTER: INTEGER = 13

feature -- weapontype_t

	wp_fist: INTEGER = 0

	wp_pistol: INTEGER = 1

	wp_shotgun: INTEGER = 2

	wp_chaingun: INTEGER = 3

	wp_missile: INTEGER = 4

	wp_plasma: INTEGER = 5

	wp_bfg: INTEGER = 6

	wp_chainsaw: INTEGER = 7

	wp_supershotgun: INTEGER = 8

	NUMWEAPONS: INTEGER = 9

	wp_nochange: INTEGER = 10

feature -- gamestate_t

	GS_LEVEL: INTEGER = 0

	GS_INTERMISSION: INTEGER = 1

	GS_FINALE: INTEGER = 2

	GS_DEMOSCREEN: INTEGER = 3

feature

	MTF_AMBUSH: INTEGER = 8
			-- Deaf monsters/do not react to sound

end
