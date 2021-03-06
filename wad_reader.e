note
	description: "Utility class to read WAD contents"

class
	WAD_READER

feature

	read_array_integer_16 (m: MANAGED_POINTER): ARRAY [INTEGER_16]
		require
			divisible_by_integer_16_size: m.count \\ 2 = 0
		local
			i: INTEGER
		do
			create Result.make_filled (0, 0, m.count // 2 - 1)
			from
				i := 0
			until
				i > Result.upper
			loop
				Result [i] := m.read_integer_16_le (i * 2)
				i := i + 1
			end
		ensure
			instance_free: class
			Result.lower = 0
			Result.count = m.count // 2
		end

end
