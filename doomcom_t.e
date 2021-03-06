note
	description: "d_net.h"

class
	DOOMCOM_T

create
	make

feature

	make
		do
			create data.make
		end

feature

	id: INTEGER assign set_id -- supposed to be DOOMCOM_ID?

	set_id (a_id: like id)
		do
			id := a_id
		end

feature -- Info common to all nodes.

	numnodes: INTEGER assign set_numnodes -- Console is allways node 0.

	ticdup: INTEGER assign set_ticdup -- Flag: 1 = no duplication, 2-5 = dup for slow nets.

	extratics: INTEGER assign set_extratics -- Flag: 1 = send backup tic in every packet.

	deathmatch: INTEGER assign set_deathmatch -- Flag: 1 = deathmatch

	set_deathmatch (a_deathmatch: like deathmatch)
		do
			deathmatch := a_deathmatch
		end

	set_numnodes (a_numnodes: like numnodes)
		do
			numnodes := a_numnodes
		end

	set_ticdup (a_ticdup: like ticdup)
		do
			ticdup := a_ticdup
		end

	set_extratics (a_extratics: like extratics)
		do
			extratics := a_extratics
		end

feature -- Info specific to this node.

	numplayers: INTEGER assign set_numplayers

	set_numplayers (a_numplayers: like numplayers)
		do
			numplayers := a_numplayers
		end

	consoleplayer: INTEGER assign set_consoleplayer

	set_consoleplayer (a_consoleplayer: like consoleplayer)
		do
			consoleplayer := a_consoleplayer
		end

	data: DOOMDATA_T

end
