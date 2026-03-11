GLOBAL_TYPED_NEW(thralls, /datum/antagonist/thrall)

/datum/antagonist/thrall
	role_text = "Thrall"
	role_text_plural = "Thralls"
	welcome_text = "Your mind is no longer solely your own..."
	id = MODE_THRALL
	flags = ANTAG_IMPLANT_IMMUNE

	var/list/thrall_controllers = list()

/datum/antagonist/thrall/create_objectives(datum/mind/player)
	// [SIERRA-EDIT] — Nasrano na event
	var/datum/objective/first = new
	first.explanation_text = "Мне открыта тайна, теперь я, единое с Треугольной бипирамидой."
	player.objectives |= first
	var/datum/objective/second = new
	second.explanation_text = "Треугольная бипирамида должна быть известна каждому, её должны почитать."
	player.objectives |= second
	var/datum/objective/third = new
	third.explanation_text = "Мне необходимо распространять её влияние. Они должны произнести Треугольная бипирамида."
	player.objectives |= third
	var/datum/objective/fourth = new
	fourth.explanation_text = "Треугольная бипирамида впитает кровь возле себя, чтобы она могла излечивать нас."
	player.objectives |= fourth
	// [/SIERRA-EDIT] — Nasrano na event

/datum/antagonist/thrall/add_antagonist(datum/mind/player, ignore_role, do_not_equip, move_to_spawn, do_not_announce, preserve_appearance, mob/new_controller)
	if(!new_controller)
		return 0
	. = ..()
	if(.) thrall_controllers["\ref[player]"] = new_controller

/datum/antagonist/thrall/greet(datum/mind/player)
	. = ..()
	var/mob/living/controller = thrall_controllers["\ref[player]"]
	if(controller)
		to_chat(player, SPAN_DANGER("Your will has been subjugated by that of [controller.real_name]. Obey them in all things."))
