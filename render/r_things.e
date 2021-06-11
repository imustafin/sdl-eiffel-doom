note
	description: "[
		r_things.c
		Refresh of things, i.e. objects represented by sprites.
	]"

class
	R_THINGS

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create vissprites.make_empty
			create spritelights.make_empty
			create screenheightarray.make_filled (0, 0, {DOOMDEF_H}.SCREENWIDTH - 1)
			create negonearray.make_filled (-1, 0, {DOOMDEF_H}.SCREENWIDTH - 1)
			create vsprsortedhead
			vissprites := {REF_ARRAY_CREATOR [VISSPRITE_T]}.make_ref_array (MAXVISSPRITES)
		end

feature

	MAXVISSPRITES: INTEGER = 128

	vissprites: ARRAY [VISSPRITE_T]

	vissprite_p: INTEGER -- originally pointer inside vissprites

	spritelights: detachable ARRAY [detachable INDEX_IN_ARRAY [LIGHTTABLE_T]] -- lighttable_t**

feature
	-- constant arrays
	-- used for psprite clipping and initializing clipping

	negonearray: ARRAY [INTEGER_16]

	screenheightarray: ARRAY [INTEGER_16]

feature

	R_InitSprites (namelist: ARRAY [STRING])
		do
				-- Stub
		end

	R_ClearSprites
			-- Called at frame start.
		do
			vissprite_p := 0
		end

feature -- R_SortVisSprites

	vsprsortedhead: VISSPRITE_T

	R_SortVisSprites
		local
			i: INTEGER
			count: INTEGER
			ds: INDEX_IN_ARRAY [VISSPRITE_T]
			dss: VISSPRITE_T
			best: VISSPRITE_T
			unsorted: VISSPRITE_T
			bestscale: FIXED_T
		do
			count := vissprite_p - vissprites.lower
			create unsorted
			unsorted.next := unsorted
			unsorted.prev := unsorted
			if count = 0 then
					-- return
			else
				from
					create ds.make (vissprites.lower, vissprites)
				until
					ds.index >= vissprite_p
				loop
					ds.this.next := (ds + 1).this
					ds.this.prev := (ds - 1).this
					ds := ds + 1
				end
				vissprites [0].prev := unsorted
				unsorted.next := vissprites [0]
				vissprites [vissprite_p - 1].next := unsorted
				unsorted.prev := vissprites [vissprite_p - 1]

					-- pull the vissprites out by scale
				vsprsortedhead.next := vsprsortedhead
				vsprsortedhead.prev := vsprsortedhead
				from
					i := 0
				until
					i >= count
				loop
					bestscale := {DOOMTYPE_H}.maxint
					from
						dss := unsorted.next
					until
						dss = unsorted
					loop
						check attached dss then
							if dss.scale < bestscale then
								bestscale := dss.scale
								best := dss
							end
							dss := dss.next
						end
					end
					check attached best then
						check attached best.next as bnext then
							bnext.prev := best.prev
						end
						check attached best.prev as bprev then
							bprev.next := best.next
						end
						best.next := vsprsortedhead
						best.prev := vsprsortedhead.prev
						check attached vsprsortedhead.prev as vprev then
							vprev.next := best
						end
						vsprsortedhead.prev := best
					end
					i := i + 1
				end
			end
		end

feature -- R_DrawMaskedColumn

	mfloorclip: detachable ARRAY [INTEGER_16]

	mceilingclip: detachable ARRAY [INTEGER_16]

	spryscale: FIXED_T

	sprtopscreen: FIXED_T

	R_DrawMaskedColumn (column: COLUMN_T)
			-- Used for sprites and masked mid textures.
			-- Masked means: partly transparent, i.e. stored
			-- in posts/runs of opaque pixels.
		local
			topscreen: INTEGER
			bottomscreen: INTEGER
			basetexturemid: FIXED_T
			i: INTEGER
			post: POST_T
		do
			basetexturemid := i_main.r_draw.dc_texturemid
			from
				i := column.posts.lower
			until
				i > column.posts.upper
			loop
					-- calculate unclipped screen coordinates
					-- for post
				post := column.posts [i]
				topscreen := sprtopscreen + spryscale * post.topdelta.to_integer_32
				bottomscreen := topscreen + spryscale * post.length.to_integer_32
				i_main.r_draw.dc_yl := (topscreen + {M_FIXED}.FRACUNIT - 1) |>> {M_FIXED}.FRACBITS
				i_main.r_draw.dc_yh := (bottomscreen - 1) |>> {M_FIXED}.FRACBITS
				check attached mfloorclip as mfc then
					if i_main.r_draw.dc_yh >= mfc [i_main.r_draw.dc_x] then
						i_main.r_draw.dc_yh := mfc [i_main.r_draw.dc_x] - 1
					end
				end
				check attached mceilingclip as mcc then
					if i_main.r_draw.dc_yl <= mcc [i_main.r_draw.dc_x] then
						i_main.r_draw.dc_yl := mcc [i_main.r_draw.dc_x] + 1
					end
				end
				if i_main.r_draw.dc_yl <= i_main.r_draw.dc_yh then
					i_main.r_draw.dc_source := create {BYTE_ARRAY}.with_array (post.body)
					i_main.r_draw.dc_texturemid := basetexturemid - (post.topdelta.to_integer_32 |<< {M_FIXED}.FRACBITS)

						-- Drawn by either R_DrawColumn
						-- or (SHADOW) R_DrawFuzzColumn
					check attached i_main.r_main.colfunc as colfunc then
						colfunc.call
					end
				end
				i := i + 1
			end
			i_main.r_draw.dc_texturemid := basetexturemid
		end

feature -- R_DrawVisSprite

	R_DrawVisSprite (vis: VISSPRITE_T; x1, x2: INTEGER)
			-- mfloorclip and mceiling should also be set
		require
			mfloorclip /= Void
			mceilingclip /= Void
		local
			texturecolumn: INTEGER
			frac: FIXED_T
			patch: PATCH_T
		do
			patch := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpnum (vis.patch + i_main.r_data.firstspritelump, {Z_ZONE}.pu_cache))
			i_main.r_draw.dc_colormap := vis.colormap
			if i_main.r_draw.dc_colormap = Void then
					-- NULL colormap = shadow draw
				i_main.r_main.colfunc := i_main.r_main.fuzzcolfunc
			elseif vis.mobjflags & {P_MOBJ}.MF_TRANSLATION /= 0 then
				i_main.r_main.colfunc := agent (i_main.r_draw).R_DrawTranslatedColumn
				check attached i_main.r_draw.translationtables as ttables then
					i_main.r_draw.dc_translation := create {INDEX_IN_ARRAY [NATURAL_16]}.make (-256 + ((vis.mobjflags & {P_MOBJ}.MF_TRANSLATION) |>> ({P_MOBJ}.MF_TRANSSHIFT - 8)), ttables)
				end
			end
			i_main.r_draw.dc_iscale := (vis.xiscale).abs |>> i_main.r_main.detailshift
			i_main.r_draw.dc_texturemid := vis.texturemid
			frac := vis.startfrac
			spryscale := vis.scale
			sprtopscreen := i_main.r_main.centeryfrac - {M_FIXED}.fixedmul (i_main.r_draw.dc_texturemid, spryscale)
			from
				i_main.r_draw.dc_x := vis.x1
			until
				i_main.r_draw.dc_x > vis.x2
			loop
				texturecolumn := frac |>> {M_FIXED}.fracbits
				check
					RANGECHECK: texturecolumn >= 0 and texturecolumn < patch.width
				end
				R_DrawMaskedColumn (patch.column_by_offset (patch.columnofs [texturecolumn]))
				i_main.r_draw.dc_x := i_main.r_draw.dc_x + 1
				frac := frac + vis.xiscale
			end
			i_main.r_main.colfunc := i_main.r_main.basecolfunc
		end

feature

	R_DrawSprite (spr: VISSPRITE_T)
		local
			ds: INDEX_IN_ARRAY [DRAWSEG_T]
			clipbot: ARRAY [INTEGER_16]
			cliptop: ARRAY [INTEGER_16]
			x: INTEGER
			r1: INTEGER
			r2: INTEGER
			scale: FIXED_T
			lowscale: FIXED_T
			silhouette: INTEGER
		do
			create clipbot.make_filled (0, 0, {DOOMDEF_H}.screenwidth - 1)
			create cliptop.make_filled (0, 0, {DOOMDEF_H}.screenwidth - 1)
			from
				x := spr.x1
			until
				x > spr.x2
			loop
				clipbot [x] := -2
				cliptop [x] := -2
				x := x + 1
			end

				-- Scan drawsegs from end to start for obscuring segs.
				-- The first drawseg that has a greater scale
				-- is the clip seg.
			from
				create ds.make (i_main.r_bsp.ds_p, i_main.r_bsp.drawsegs)
			until
				ds.index < i_main.r_bsp.drawsegs.lower
			loop
					-- determine if the drawseg obscures the sprite
				if ds.this.x1 > spr.x2 or ds.this.x2 < spr.x1 or (ds.this.silhouette = 0 and ds.this.maskedtexturecol = Void) then
						-- does not cover sprite
						-- continue
				else
					r1 := if ds.this.x1 < spr.x1 then spr.x1 else ds.this.x1 end
					r2 := if ds.this.x2 > spr.x2 then spr.x2 else ds.this.x2 end
					if ds.this.scale1 > ds.this.scale2 then
						lowscale := ds.this.scale2
						scale := ds.this.scale1
					else
						lowscale := ds.this.scale1
						scale := ds.this.scale2
					end
					check attached ds.this.curline as ds_curline then
						if scale < spr.scale or (lowscale < spr.scale and (i_main.r_main.R_PointOnSegSide (spr.gx, spr.gy, ds_curline) = 0)) then
								-- masked mid texture?
							if ds.this.maskedtexturecol /= Void then
								i_main.r_segs.R_RenderMaskedSegRange (ds.this, r1, r2)
							end
								-- seg is behind sprite
								-- continue
						else
								-- clip this piece of the sprite
							silhouette := ds.this.silhouette
							if spr.gz >= ds.this.bsilheight then
								silhouette := silhouette & {R_DEFS}.SIL_BOTTOM.bit_not
							end
							if spr.gzt <= ds.this.tsilheight then
								silhouette := silhouette & {R_DEFS}.SIL_TOP.bit_not
							end
							if silhouette = 1 then
									-- bottom sil
								from
									x := r1
								until
									x > r2
								loop
									if clipbot [x] = -2 then
										check attached ds.this.sprbottomclip as botclip then
											clipbot [x] := botclip [x]
										end
									end
									x := x + 1
								end
							elseif silhouette = 2 then
									-- top sil
								from
									x := r1
								until
									x > r2
								loop
									if cliptop [x] = -2 then
										check attached ds.this.sprtopclip as topclip then
											cliptop [x] := topclip [x]
										end
									end
									x := x + 1
								end
							elseif silhouette = 3 then
									-- both
								from
									x := r1
								until
									x > r2
								loop
									if clipbot [x] = -2 then
										check attached ds.this.sprbottomclip as botclip then
											clipbot [x] := botclip [x]
										end
									end
									if cliptop [x] = -2 then
										check attached ds.this.sprtopclip as topclip then
											cliptop [x] := topclip [x]
										end
									end
									x := x + 1
								end
							end
						end
					end
				end
				ds := ds - 1
			end

				-- all clipping has been performed, so draw the sprite

				-- check for unclipped columns
			from
				x := spr.x1
			until
				x > spr.x2
			loop
				if clipbot [x] = -2 then
					clipbot [x] := {P_LOCAL}.viewheight.to_integer_16
				end
				if cliptop [x] = -2 then
					cliptop [x] := -1
				end
				x := x + 1
			end
			mfloorclip := clipbot
			mceilingclip := cliptop
			R_DrawVisSprite (spr, spr.x1, spr.x2)
		end

	R_DrawPlayerSprites
		do
				-- Stub
		end

	R_DrawMasked
		local
			spr: VISSPRITE_T
			ds: INTEGER
		do
			R_SortVisSprites
			if vissprite_p > vissprites.lower then
					-- draw all vissprites back to front
				from
					spr := vsprsortedhead.next
				until
					spr = vsprsortedhead
				loop
					check attached spr then
						R_DrawSprite (spr)
						spr := spr.next
					end
				end
			end

				-- render any remaining masked mid textures
			from
				ds := i_main.r_bsp.ds_p - 1
			until
				ds < i_main.r_bsp.drawsegs.lower
			loop
				if i_main.r_bsp.drawsegs [ds].maskedtexturecol /= Void then
					i_main.r_segs.R_RenderMaskedSegRange (i_main.r_bsp.drawsegs [ds], i_main.r_bsp.drawsegs [ds].x1, i_main.r_bsp.drawsegs [ds].x2)
				end
				ds := ds - 1
			end

				-- draw the psprites on top of everything
				-- but does not draw on side views
			if i_main.r_main.viewangleoffset /= 0 then
				R_DrawPlayerSprites
			end
		end

	R_AddSprites (sec: SECTOR_T)
			-- During BSP traversal, this adds sprites by sector.
		local
			thing: detachable MOBJ_T
			lightnum: INTEGER
		do
				-- BSP is traversed by subsector.
				-- A sector might have beend split into several
				-- subsectors during BSP building.
				-- Thus we check whether its already added.
			if sec.validcount /= i_main.r_main.validcount then
					-- Well, now it will be done
				sec.validcount := i_main.r_main.validcount
				lightnum := (sec.lightlevel |>> {R_MAIN}.LIGHTSEGSHIFT) + i_main.r_main.extralight
				check attached i_main.r_main.scalelight as scalelight then
					if lightnum < 0 then
						spritelights := scalelight [0]
					elseif lightnum >= {R_MAIN}.LIGHTLEVELS then
						spritelights := scalelight [{R_MAIN}.LIGHTLEVELS - 1]
					else
						spritelights := scalelight [lightnum]
					end
				end

					-- Handle all things in sector.
				from
					thing := sec.thinglist
				until
					thing = Void
				loop
					R_ProjectSprite (thing)
					thing := thing.snext
				end
			end
		end

	R_ProjectSprite (thing: MOBJ_T)
			-- Generates a vissprite for a thing
			-- if it might be visible.
		do
				-- Stub
		end

feature -- Sprite rotation

		-- Sprite rotation 0 is facing the viewer,
		--  rotation 1 is one angle turn CLOCKWISE around the axis.
		-- This is not the same as the angle,
		--  which increases counter clockwise (protractor).
		-- There was a lot of stuff grabbed wrong, so I changed it...

	pspritescale: FIXED_T assign set_pspritescale

	set_pspritescale (a_pspritescale: like pspritescale)
		do
			pspritescale := a_pspritescale
		end

	pspriteiscale: FIXED_T assign set_pspriteiscale

	set_pspriteiscale (a_pspriteiscale: like pspriteiscale)
		do
			pspriteiscale := a_pspriteiscale
		end

invariant
	screenheightarray.lower = 0
	screenheightarray.count = {DOOMDEF_H}.SCREENWIDTH
	negonearray.lower = 0
	negonearray.count = {DOOMDEF_H}.SCREENWIDTH
	across negonearray as i_neg all i_neg.item = -1 end
	{UTILS [VISSPRITE_T]}.invariant_ref_array (vissprites, MAXVISSPRITES)

end
