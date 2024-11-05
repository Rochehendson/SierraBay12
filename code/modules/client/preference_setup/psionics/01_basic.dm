GLOBAL_LIST_INIT(psi_status2text, list("C", "B", "A", "S"))
GLOBAL_LIST_INIT(text2psi_status, list("C" = 1, "B" = 2, "A" = 3, "S" = 4))

/datum/preferences
	var/psi_threat_level = 0
	var/psi_status       = 4
	var/psi_openness     = FALSE

/datum/category_item/player_setup_item/psionics/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/psionics/basic/load_character(datum/pref_record_reader/R)
	pref.psi_threat_level = R.read("psi_threat_level")
	pref.psi_status       = R.read("psi_status")
	pref.psi_openness     = R.read("psi_openness")

/datum/category_item/player_setup_item/psionics/basic/save_character(datum/pref_record_writer/W)
	W.write("psi_threat_level", pref.psi_threat_level)
	W.write("psi_status",       pref.psi_status)
	W.write("psi_openness",     pref.psi_openness)

/datum/category_item/player_setup_item/psionics/basic/sanitize_character()
	pref.psi_threat_level = clamp(pref.psi_threat_level, 0, 4)
	pref.psi_status       = clamp(pref.psi_status      , 1, 4)

/datum/category_item/player_setup_item/psionics/basic/content()
	. = list()
	. += "Threat level: <a href='?src=\ref[src];select_psi_threat_level=1'><b>[pref.psi_threat_level]</b></a><br>"

	if(pref.psi_threat_level)
		. += "Psionic status: <a href='?src=\ref[src];select_psi_status=1'><b>[GLOB.psi_status2text[pref.psi_status]]</b></a><br>"
		. += "Openness: <a href='?src=\ref[src];toggle_psi_openness=1'><b>[pref.psi_openness ? "Yes" : "No"]</b></a><br>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/psionics/OnTopic(href, list/href_list, mob/user)
	if(href_list["select_psi_threat_level"])
		pref.psi_threat_level = text2num(input("Select threat level", CHARACTER_PREFERENCE_INPUT_TITLE, pref.psi_threat_level) in list("0", "1", "2", "3", "4"))
		pref.psi_threat_level = clamp(pref.psi_threat_level, 0, 4)
		pref.sanitize_psi_abilities()
		return TOPIC_REFRESH

	else if(href_list["select_psi_status"])
		var/selection = input("Select psionics status", CHARACTER_PREFERENCE_INPUT_TITLE, GLOB.psi_status2text[pref.psi_status]) in GLOB.text2psi_status
		if(!(selection in GLOB.text2psi_status))
			return TOPIC_HANDLED

		pref.psi_status = GLOB.text2psi_status[selection]
		return TOPIC_REFRESH

	else if(href_list["toggle_psi_openness"])
		pref.psi_openness = !pref.psi_openness
		return TOPIC_REFRESH

	return ..()
