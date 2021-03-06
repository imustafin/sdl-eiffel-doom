class
	SDL_AUDIO_CVT

inherit

	SDL_AUDIO_CVT_STRUCT_API
		rename
			set_buf as set_buf_api,
			buf as buf_api
		end

create
	make

feature

	buf_managed: detachable MANAGED_POINTER

	allocate_buf (length: INTEGER)
		local
			new_buf: MANAGED_POINTER
		do
			create new_buf.make (length)
			buf_managed := new_buf
			set_c_buf (item, new_buf.item)
		end

end
