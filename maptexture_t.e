note
	description: "[
		maptexture_t from r_data.c
		A DOOM wall texture is a list of patches
		which are to be combined in a predefined order.
	]"

class
	MAPTEXTURE_T

create
	make

feature

	make
		do
			name := ""
			create patches.make_empty
		end

feature

	name: STRING assign set_name

	set_name (a_name: like name)
		do
			name := a_name
		end

	masked: BOOLEAN assign set_masked

	set_masked (a_masked: like masked)
		do
			masked := a_masked
		end

	width: INTEGER_16 assign set_width

	set_width (a_width: like width)
		do
			width := a_width
		end

	height: INTEGER_16 assign set_height

	set_height (a_height: like height)
		do
			height := a_height
		end

	patches: ARRAY [MAPPATCH_T] assign set_patches

	set_patches (a_patches: like patches)
		do
			patches := a_patches
		end

invariant
	name.count <= 8

end
