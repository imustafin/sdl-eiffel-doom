note
	description: "[
		i_sound.c
		System interface for sound.
	]"

class
	I_SOUND

create
	make

feature -- Chocolate doom snddevice_t

	SNDDEVICE_NONE: INTEGER = 0

	SNDDEVICE_PCSPEAKER: INTEGER = 1

	SNDDEVICE_ADLIB: INTEGER = 2

	SNDDEVICE_SB: INTEGER = 3

	SNDDEVICE_PAS: INTEGER = 4

	SNDDEVICE_GUS: INTEGER = 5

	SNDDEVICE_WAVEBLASTER: INTEGER = 6

	SNDDEVICE_SOUNDCANVAS: INTEGER = 7

	SNDDEVICE_GENMIDI: INTEGER = 8

	SNDDEVICE_AWE32: INTEGER = 9

	SNDDEVICE_CD: INTEGER = 10

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			snd_musicdevice := SNDDEVICE_SB
			snd_sfxdevice := SNDDEVICE_SB
			create music_pack_module.make
		end

feature -- Chocolate doom

	snd_samplerate: INTEGER = 44100 -- Sound sample rate to use for digital output (Hz)

	snd_musicdevice: INTEGER

	snd_sfxdevice: INTEGER

	active_music_module: detachable MUSIC_MODULE_T

	music_packs_active: BOOLEAN

	sound_module: detachable SOUND_MODULE_T

	music_module: detachable MUSIC_MODULE_T

	sound_modules: ARRAY [detachable SOUND_MODULE_T]
		once
			Result := {ARRAY [detachable SOUND_MODULE_T]} <<{SOUND_SDL_MODULE}.sound_sdl_module, {SOUND_PCSOUND_MODULE}.sound_pcsound_module, Void>>
		end

	music_modules: ARRAY [detachable MUSIC_MODULE_T]
		once
			Result := {ARRAY [detachable MUSIC_MODULE_T]} <<{MUSIC_SDL_MODULE}.music_sdl_module, {MUSIC_OPL_MODULE}.music_opl_module, Void>>
		end

feature -- Chocolate doom Sound modules

	music_pack_module: I_MUSICPACK

feature

	steptable: ARRAY [INTEGER]
			-- Pitch to stepping lookup, unused.
		once
			create Result.make_filled (0, 0, 255)
		end

	vol_lookup: ARRAY [INTEGER]
			-- Volume lookups.
		once
			create Result.make_filled (0, 0, 128 * 256 - 1)
		end

feature

	I_InitSound (use_sfx_prefix: BOOLEAN)
		local
			nomusicpacks: BOOLEAN
			nosound: BOOLEAN
			nomusic: BOOLEAN
			nosfx: BOOLEAN
		do
				-- skip -nosound
				-- skip -nosfx
				-- skip -nomusic
				-- skip -nomusicpacks
			nomusicpacks := True

				-- Auto configure the music pack directory.
			{M_CONFIG}.M_SetMusicPackDir

				-- Initialize the sound and music subsystems.

			if not nosound and not i_main.i_video.screensaver_mode then
					-- This is kind of a hack. If native MIDI is enabled, set up
					-- the TIMIDITY_CFG environment variable here before SDL_mixer
					-- is opened.

				if not nomusic and (snd_musicdevice = SNDDEVICE_GENMIDI or snd_musicdevice = SNDDEVICE_GUS) then
					{I_SDLMUSIC}.I_InitTimidityConfig
				end
				if not nosfx then
					InitSfxModule (use_sfx_prefix)
				end
				if not nomusic then
					InitMusicModule
					active_music_module := music_module
				end

					-- We may also have substitute MIDIs we can load.
				if not nomusicpacks and attached music_module as m then
					music_packs_active := music_pack_module.init
				end
			end
		end

	InitSfxModule (use_sfx_prefix: BOOLEAN)
			-- Find and initialize a sound_module_t appropriate for the setting
			-- in snd_sfxdevice.
		do
			sound_module := Void
			across
				sound_modules as i
			loop
				if sound_module = Void and then attached i.item as sm then
					if across sm.sound_devices is x some snd_sfxdevice = x end then
							-- Initialize the module

						if sm.Init (use_sfx_prefix) then
							sound_module := sm
						end
					end
				end
			end
		end

	InitMusicModule
		do
			music_module := Void
			across
				music_modules as i
			loop
				if music_module = Void and then attached i.item as m then
					if across m.sound_devices is d some snd_musicdevice = d end then
							-- Initialize the module

						if m.init then
							music_module := m
						end
					end
				end
			end
		end

	I_SoundIsPlaying (handle: INTEGER): BOOLEAN
		do
				-- Ouch.
			Result := i_main.g_game.gametic < handle
		end

	I_UpdateSoundParams (handle, vol, sep, pitch: INTEGER)
		do
				-- Stub
				-- I fal to see that this is used.
				-- Would be using the handle to identify
				--  on which channel the sound might be active,
				--  and resetting the channel parameters

				-- UNUSED
		end

	I_SetChannels
			-- SFX API
			-- Note: this was called by S_Init.
			-- However, whatever they did in the
			-- old DPMS based DOS version, this
			-- were simply dummies in the Linux
			-- version.
			-- See soundserver initdata().
		local
			i, j: INTEGER
			steptablemid: INTEGER
		do
			steptablemid := 128

				-- skip commented out channels[i] = 0

				-- This table provides step widths for pitch parameters.
				-- I fail to see that this is currently used.
			from
				i := -128
			until
				i >= 128
			loop
				steptable [steptablemid + i] := ((2).to_real.power (i / 64) * 65536).floor
				i := i + 1
			end

				-- Generates volume lookup tables
				--  which also turn the unsigned samples
				--  into signed samples.
			from
				i := 0
			until
				i >= 128
			loop
				from
					j := 0
				until
					j >= 256
				loop
					vol_lookup [i * 256 + j] := (i * (j - 128) * 256) // 127
					j := j + 1
				end
				i := i + 1
			end
		end

	I_SetMusicVolume (volume: INTEGER)
			-- MUSIC API - dummy. Some code from DOS version.
		do
				-- Internal state variable.
			i_main.s_sound.snd_MusicVolume := volume
				-- Now set volume on output device.
				-- Whatever( snd_MusicVolume );
		end

	I_ResumeSong
		do
			if attached active_music_module as m then
				m.resumeMusic
			end
		end

	I_StopSong
		do
			if attached active_music_module as m then
				m.stopsong
			end
		end

	I_UnregisterSong (handle: detachable ANY)
		do
			if attached active_music_module as m then
				m.unregistersong (handle)
			end
		end

	I_RegisterSong (data: detachable ANY; len: INTEGER): detachable ANY
		local
			handle: ANY
		do
				-- If the music pack module is active, check to see if there is a
				-- valid substitution for this track. If there is, we set the
				-- active_music_module pointer to the music pack module for the
				-- duration of this particular track.

			if music_packs_active then
				handle := music_pack_module.RegisterSong (data, len)
				if attached handle as h then
					active_music_module := music_pack_module
					Result := h
				end
			end
			if Result = Void then
					-- No substitution for this track, so use the main module.
				active_music_module := music_module
				if attached active_music_module as m then
					Result := m.RegisterSong (data, len)
				end
			end
		end

	I_PlaySong (handle: detachable ANY; looping: BOOLEAN)
		do
			if attached active_music_module as m then
				m.PlaySong (handle, looping)
			end
		end

end
