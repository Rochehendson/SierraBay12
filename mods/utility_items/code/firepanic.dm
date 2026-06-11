/mob/living/carbon/proc/fire_panic()
	while(on_fire)
		set_move_intent(get_movement_datum_by_flag(MOVE_INTENT_QUICK))

		var/turf/move_to_turf = get_step(src, pick(GLOB.alldirs))
		IMove(move_to_turf)
		sleep(3)
	return
