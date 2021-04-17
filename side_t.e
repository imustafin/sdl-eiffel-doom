note
	description: "[
		side_t from r_defs.h
		
		The SideDef.
	]"

class
	SIDE_T

create
	default_create, from_pointer

feature

	textureoffset: FIXED_T
			-- add this to the calculated texture column

	rowoffset: FIXED_T
			-- add this to the calculated texture top

	toptexture: INTEGER_16

	bottomtexture: INTEGER_16

	midtexture: INTEGER_16

	sector: detachable SECTOR_T
			-- Sector the SideDef is facing.

feature

	from_pointer (m: MANAGED_POINTER; offset: INTEGER; i_main: I_MAIN)
		local
			upper_name: STRING
			middle_name: STRING
			lower_name: STRING
			sector_num: INTEGER_16
		do
			textureoffset := m.read_integer_16_le (offset).to_integer_32 |<< {M_FIXED}.fracbits
			rowoffset := m.read_integer_16_le (offset + 2).to_integer_32 |<< {M_FIXED}.fracbits

				-- Read names
			upper_name := (create {C_STRING}.make_by_pointer_and_count (m.item + offset + 4, 8)).string
			lower_name := (create {C_STRING}.make_by_pointer_and_count (m.item + offset + 12, 8)).string
			middle_name := (create {C_STRING}.make_by_pointer_and_count (m.item + offset + 20, 8)).string
			toptexture := i_main.r_data.R_TextureNumForName (upper_name).to_integer_16
			bottomtexture := i_main.r_data.R_TextureNumForName (lower_name).to_integer_16
			midtexture := i_main.r_data.R_TextureNumForName (middle_name).to_integer_16
			sector_num := m.read_integer_16_le (offset + 28)
			sector := i_main.p_setup.sectors [sector_num]
		end

	structure_size: INTEGER = 30

end
