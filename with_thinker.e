note
	description: "Interface for classes having thinker"

deferred class
	WITH_THINKER

feature

	thinker: THINKER_T assign set_thinker

	set_thinker (a_thinker: like thinker)
		do
			thinker := a_thinker
		end

feature

	make_thinker
		do
			create thinker.make
		end

end
