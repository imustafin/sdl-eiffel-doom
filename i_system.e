note
	description: "i_system.c"

class
	I_SYSTEM

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	I_Init
		local
			flags: NATURAL_32
		do
			flags := {SDL_CONSTANT_API}.sdl_init_audio.as_natural_32
			flags := flags | {SDL_CONSTANT_API}.sdl_init_video.as_natural_32
			if {SDL_FUNCTIONS_API}.sdl_init (flags) < 0 then
				 i_main.i_error ("Could not initialze SDL: " + {SDL_ERROR}.sdl_get_error)
			end
			i_main.i_sound.I_InitSound
		end

end
