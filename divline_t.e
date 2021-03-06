note
	description: "divline_t from p_local.h"

class
	DIVLINE_T

create
	default_create, make_from_line

feature

	make_from_line (li: LINE_T)
		do
			x := li.v1.x
			y := li.v1.y
			dx := li.dx
			dy := li.dy
		end

feature

	x: FIXED_T assign set_x

	set_x (a_x: like x)
		do
			x := a_x
		end

	y: FIXED_T assign set_y

	set_y (a_y: like y)
		do
			y := a_y
		end

	dx: FIXED_T assign set_dx

	set_dx (a_dx: like dx)
		do
			dx := a_dx
		end

	dy: FIXED_T assign set_dy

	set_dy (a_dy: like dy)
		do
			dy := a_dy
		end

end
