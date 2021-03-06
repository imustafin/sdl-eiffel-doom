note
	description: "[
		subsector_t from r_defs.h
		
		A SubSector.
		References a Sector.
		Basically, this is a list of LineSegs,
		indicating the visible walls that define
		(all or some) sides of a convex BSP leaf.
	]"

class
	SUBSECTOR_T

create
	default_create, from_pointer

feature

	sector: detachable SECTOR_T assign set_sector

	set_sector (a_sector: like sector)
		do
			sector := a_sector
		end

	numlines: INTEGER_16

	firstline: INTEGER_16

feature

	from_pointer (m: MANAGED_POINTER; offset: INTEGER)
		do
			numlines := m.read_integer_16_le (offset)
			firstline := m.read_integer_16_le (offset + 2)
		end

	structure_size: INTEGER = 4

end
