note
	description: "thinker_t from d_think.h"

class
	THINKER_T

create
	make

feature

	make
		do
			prev := Current
			next := Current
		end

feature

	prev: THINKER_T assign set_prev

	set_prev (a_prev: like prev)
		do
			prev := a_prev
		end

	next: THINKER_T assign set_next

	set_next (a_next: like next)
		do
			next := a_next
		end

	function: detachable PROCEDURE assign set_function

	set_function (a_function: like function)
		do
			function := a_function
		end

invariant
	attached function as i_f implies i_f.open_count = 0

end
