note
	description: "[
		chocolate doom i_midipipe.c
		Client Interface to Midi Server
	]"

class
	I_MIDIPIPE

feature

	midi_server_initialized: BOOLEAN
		-- True if the midi process was initialized at least once and has not been
		-- explicitly shut down. This remains true if the server is momentarily
		-- unreachable.

	midi_server_registered: BOOLEAN
		-- True if the current track is being handled via the MIDI server.

end
