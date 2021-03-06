note
	description: "[
		d_ticcmd.h
		System specific interface stuff.
		
		The data sampled per tick (single player)
		and transmitted to other players (multiplayer).
		Mainly movements/button commands per game tick,
		plus a checksum for internal state consistency.
	]"

class
	TICCMD_T

create
	default_create

feature

	forwardmove: INTEGER_8 assign set_forwardmove -- *2048 for move

	set_forwardmove (a_forwardmove: like forwardmove)
		do
			forwardmove := a_forwardmove
		end

	sidemove: INTEGER_8 assign set_sidemove -- *2048 for move

	set_sidemove (a_sidemove: like sidemove)
		do
			sidemove := a_sidemove
		end

	angleturn: INTEGER assign set_angleturn -- <<16 for angle data

	set_angleturn (a_angleturn: like angleturn)
		do
			angleturn := a_angleturn
		end

	consistancy: INTEGER assign set_consistancy -- checks for net game

	set_consistancy (a_consistancy: like consistancy)
		do
			consistancy := a_consistancy
		end

	chatchar: CHARACTER assign set_chatchar

	set_chatchar (a_chatchar: like chatchar)
		do
			chatchar := a_chatchar
		end

	buttons: INTEGER assign set_buttons

	set_buttons (a_buttons: like buttons)
		do
			buttons := a_buttons
		end

feature

	copy_from (a_other: TICCMD_T)
		do
			forwardmove := a_other.forwardmove
			sidemove := a_other.sidemove
			angleturn := a_other.angleturn
			consistancy := a_other.consistancy
			chatchar := a_other.chatchar
			buttons := a_other.buttons
		ensure
			copied: Current ~ a_other
			not_modified_a_other: old a_other ~ a_other
		end

end
