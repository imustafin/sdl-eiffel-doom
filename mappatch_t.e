note
	description: "[
		mappatch_t from r_data.c
		
		Texture definition.
		Each texture is composed of one or more patches,
		with patches being lumps stored in the WAD.
		The lumps are referenced by number, and patched
		into the rectangular texture space using origin
		and possibly other attributes
	]"

class
	MAPPATCH_T

feature

	originx: INTEGER_16 assign set_originx

	set_originx (a_originx: like originx)
		do
			originx := a_originx
		end

	originy: INTEGER_16 assign set_originy

	set_originy (a_originy: like originy)
		do
			originy := a_originy
		end

	patch: INTEGER_16 assign set_patch

	set_patch (a_patch: like patch)
		do
			patch := a_patch
		end

	stepdir: INTEGER_16 assign set_stepdir

	set_stepdir (a_stepdir: like stepdir)
		do
			stepdir := a_stepdir
		end

	colormap: INTEGER_16 assign set_colormap

	set_colormap (a_colormap: like colormap)
		do
			colormap := a_colormap
		end

end
