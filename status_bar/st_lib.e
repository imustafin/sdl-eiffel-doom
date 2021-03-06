note
	description: "[
		st_lib.c
		The status bar widget code.
	]"

class
	ST_LIB

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	sttminus: detachable PATCH_T

	STlib_init
		do
			if i_main.w_wad.w_checknumforname ("STTMINUS") >= 0 then
				sttminus := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("STTMINUS", {Z_ZONE}.pu_cache))
			end
		end

end
