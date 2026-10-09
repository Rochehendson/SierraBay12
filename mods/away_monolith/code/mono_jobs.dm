/singleton/submap_archetype/monolithship
	descriptor = "refeer ship"
	crew_jobs = list(/datum/job/submap/monolith_head)


/obj/submap_landmark/spawnpoint/monolith_head_spawn
	name = "Ship Head Officer"

/singleton/hierarchy/outfit/job/yachtman
	name = OUTFIT_JOB_NAME("Yachtman")
	id_types = null


/datum/job/submap/monolith_head
	title = "Ship Head Officer"
	info = "Ты, устав от богатой жизни, с друзьями путешествуешь по бескрайнему космосу, в поисках интересной жизни."
	total_positions = 2
	outfit_type = /singleton/hierarchy/outfit/job/yachtman
	economic_power = 5
	alt_titles = list(
		"Caravan Leader",
		"Vessel Overseer",
	)
