note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_ANGLE_T

inherit

	EQA_TEST_SET

feature -- Test routines

	test_abs_positive
			-- abs of positive should give the same
		local
			angle: ANGLE_T
		do
			angle := {NATURAL} 2
			assert ("abs of pos is the the same pos", angle.abs = angle)
		end

	test_abs_negative
			-- abs of negative should give other
		local
			angle_2: ANGLE_T
			angle_minus_2: ANGLE_T
			abs_angle_minus_2: ANGLE_T
		do
			angle_2 := {NATURAL} 2
			angle_minus_2 := - angle_2
			abs_angle_minus_2 := angle_minus_2.abs
			assert ("abs of neg is the pos", abs_angle_minus_2 ~ angle_2)
		end

	test_unary_minus
		-- a = --a
		local
			angle, m_angle, mm_angle: ANGLE_T
		do
			angle := {NATURAL} 3
			m_angle := -angle
			mm_angle := -m_angle
			assert ("minus minus a = a", angle = mm_angle)
			assert ("minus a /= a", angle /= m_angle)
		end

end
