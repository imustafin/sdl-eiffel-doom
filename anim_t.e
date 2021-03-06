note
	description: "[
		anim_t from wi_stuff.c
				
		Animation.
		There is another anim_t used in p_spec.
	]"

class
	ANIM_T

create
	make, make2

feature

	make (a_type: like type; a_period: like period; a_nanims: like nanims; a_loc: like loc)
		do
			type := a_type
			period := a_period
			nanims := a_nanims
			loc := a_loc
			create p.make_filled (Void, 0, 2)
		end

	make2 (a_type: like type; a_period: like period; a_nanims: like nanims; a_loc: like loc; a_data1: like data1)
		do
			make (a_type, a_period, a_nanims, a_loc)
			data1 := a_data1
		end

feature

	type: INTEGER

	period: INTEGER
			-- period in tics between animations

	nanims: INTEGER
			-- number of animation frames

	loc: POINT_T
			-- location of animation

	data1: INTEGER
			-- ALWAYS: n/a,
			-- RANDOM: period deviation (<256),
			-- LEVEL: level

	data2: INTEGER
			-- ALWAYS: n/a,
			-- RANDOM: random base period,
			-- LEVEL: n/a

	p: ARRAY [detachable PATCH_T]
			-- actual graphics for frames of animations

		-- following must be initialized to zero before use!

	nexttic: INTEGER assign set_nexttic
			-- next value of bcnt (used in conjunction with period)

	set_nexttic (a_nexttic: like nexttic)
		do
			nexttic := a_nexttic
		end

	lastdrawn: INTEGER
			-- last drawn animation frame

	ctr: INTEGER assign set_ctr
			-- next frame number to animate

	set_ctr (a_ctr: like ctr)
		do
			ctr := a_ctr
		end

	state: INTEGER
			-- used by RANDOM and LEVEL when animating

invariant
	p.lower = 0 and p.count = 3

end
