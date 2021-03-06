note
	description: "chocolate doom mus2mid.c"

class
	MUSHEADER

feature

	id: ARRAY [NATURAL_8]
		once
			create Result.make_filled (0, 0, 3)
		end

	scorelength: NATURAL_16 assign set_scorelength

	set_scorelength (a_scorelength: like scorelength)
		do
			scorelength := a_scorelength
		end

	scorestart: NATURAL_16 assign set_scorestart

	set_scorestart (a_scorestart: like scorestart)
		do
			scorestart := a_scorestart
		end

	primarychannels: NATURAL_16 assign set_primarychannels

	set_primarychannels (a_primarychannels: like primarychannels)
		do
			primarychannels := a_primarychannels
		end

	secondarychannels: NATURAL_16 assign set_secondarychannels

	set_secondarychannels (a_secondarychannels: like secondarychannels)
		do
			secondarychannels := a_secondarychannels
		end

	instrumentcount: NATURAL_16 assign set_instrumentcount

	set_instrumentcount (a_instrumentcount: like instrumentcount)
		do
			instrumentcount := a_instrumentcount
		end

end
