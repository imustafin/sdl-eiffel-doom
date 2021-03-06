note
	description: "s_sound.c"

class
	CHANNEL_T

create
	make

feature

	make
		do
		end

feature

	sfxinfo: detachable SFXINFO_T assign set_sfxinfo -- sound information (if null, channel avail.)

	set_sfxinfo (a_sfxinfo: like sfxinfo)
		do
			sfxinfo := a_sfxinfo
		end

	origin: detachable MOBJ_T assign set_origin -- origin of sound (orginally void*)

	set_origin (a_origin: like origin)
		do
			origin := a_origin
		end

	handle: INTEGER assign set_handle -- handle of the sound being played

	set_handle (a_handle: like handle)
		do
			handle := a_handle
		end

	pitch: INTEGER assign set_pitch

	set_pitch (a_pitch: like pitch)
		do
			pitch := a_pitch
		end

end
