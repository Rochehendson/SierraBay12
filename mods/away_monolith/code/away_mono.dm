/obj/overmap/visitable/ship/away_monolith
	name = "refeer ship"
	desc = "A Free Trade Union ship with cargo or passangers onboard."
	color = "#168f12"
	vessel_mass = 9000
	max_speed = 1/(2 SECONDS)
	initial_generic_waypoints = list(
		"nav_away_monolith_1",
		"nav_away_monolith_2",
		"nav_away_monolith_3",
		"nav_away_monolith_antag"
	)

/obj/overmap/visitable/ship/away_monolith/New(nloc, max_x, max_y)
	name = "FTU [pick("Last Cargo", "Dark Ledger", "Blind Eye", "Merchant of the Void", "Cryptic Freight", "Partner", "Hollow Void", "Green Invoice", "Ghost of Space", "Dead Man", "Blood Money", "Judas", "Penance", "Sinner", "30k")], \a [name]"
	..()

/obj/overmap/visitable/ship/get_scan_data(mob/user)
	. = list({"<b>Scan conducted at</b>: <br>[stationtime2text()] [stationdate2text()] <b>Grid coordinates</b>:<br> [x],[y]\n\n[scanner_desc]"})
	for(var/id in scans)
		var/datum/sector_scan/scan = scans[id]
		if (!scan.required_skill || user.skill_check(scan.required_skill, scan.required_skill_level))
			. += "\nInterference of unknown origin has been detected, be advised"
		if (scan.low_skill_description)
			. += scan.low_skill_description


/datum/map_template/ruin/away_site/away_monolith
	name = "Away Monolith Ship"
	id = "awaysite_monolith_ship"
	description = "Dark-green reefer"
	prefix = "mods/away_monolith/maps/"
	suffixes = list("away_mono.dmm")
	spawn_cost = 1
	player_cost = 5
	spawn_weight = 0.67
	area_usage_test_exempted_root_areas = list(/area/monolithship)

/obj/submap_landmark/joinable_submap/monolithship
	name = "refeer ship"
	archetype = /singleton/submap_archetype/monolithship

/obj/shuttle_landmark/away_monolith/nav1
	name = "Monolith Ship Navpoint #1"
	landmark_tag = "nav_away_monolith_1"

/obj/shuttle_landmark/away_monolith/nav2
	name = "Monolith Ship Navpoint #2"
	landmark_tag = "nav_away_monolith_2"

/obj/shuttle_landmark/away_monolith/nav3
	name = "Monolith Ship Navpoint #3"
	landmark_tag = "nav_away_monolith_3"

/obj/shuttle_landmark/away_monolith/nav4
	name = "Monolith Ship Navpoint #4"
	landmark_tag = "nav_away_monolith_antag"
