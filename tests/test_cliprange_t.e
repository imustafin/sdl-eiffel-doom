note
	description: "Summary description for {TEST_CLIPRANGE_T}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_CLIPRANGE_T

inherit

	EQA_TEST_SET

feature

	test_is_equal
		local
			a: CLIPRANGE_T
			b: CLIPRANGE_T
			aa: CLIPRANGE_T
		do
			create a
			a.first := 1
			a.last := 2
			create aa
			aa.first := 1
			aa.last := 2
			create b
			b.first := 123
			b.last := 456
			assert ("a ~ aa", a ~ aa)
			assert ("a.is_equal(aa)", a.is_equal (aa))
			assert ("a /~ b", a /~ b)
			assert ("not a.is_equal(b)", not a.is_equal (b))
		end

	test_twin
		local
			a: CLIPRANGE_T
			aa: CLIPRANGE_T
			b: CLIPRANGE_T
		do
			create a
			a.first := 1
			a.last := 2
			aa := a.twin
			create b
			b.first := 123
			b.last := 456
			assert ("a ~ aa", a ~ aa)
			assert ("a /~ b", a /~ b)
			assert ("aa /~ b", aa /~ b)
		end

end
