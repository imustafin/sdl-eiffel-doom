note
	description: "[
		r_defs.h
		This could be wider for >8 bit display.
		Indeed, true color support is possible
		 precalculating 24bpp lightmap/colormap LUT.
		 from darkening PLAYPAL to all black.
		Could even us emore than 32 levels.
	]"

class
	LIGHTTABLE_T

inherit

	NATURAL_8_REF

create
	default_create, from_natural_8

convert
	from_natural_8 ({NATURAL_8}),
	to_natural_8: {NATURAL_8}

feature

	from_natural_8 (a_val: NATURAL_8)
		do
			set_item (a_val)
		end

end
