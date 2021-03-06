class
	MIX_CHUNK

inherit

	MIX_CHUNK_STRUCT_API
		rename
			set_abuf as set_abuf_api,
			abuf as abuf_api
		end

create
	make

feature -- abuf

	abuf_managed: detachable MANAGED_POINTER

	allocate_abuf (len: INTEGER)
		local
			new_abuf: MANAGED_POINTER
		do
			create new_abuf.make (len)
			abuf_managed := new_abuf
			set_c_abuf (item, new_abuf.item)
		end

end
