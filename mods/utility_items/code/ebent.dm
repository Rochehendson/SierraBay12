/obj/structure/rhombus
	name = "Triangular bipyramid"
	desc = "Beatiful flying piece of art"
	icon = 'icons/obj/structures/pylon.dmi'
	icon_state = "pylon"
	light_power = 0.5
	light_range = 13
	light_color = "#3e0000"
	density = 1
	plane = GAME_PLANE_ABOVE_FOV
	var/charges = 0
	var/last_eat

/obj/structure/rhombus/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/rhombus/Bumped(mob/living/carbon/human/user)
	if(!GLOB.thralls.is_antagonist(user.mind))
		src.anchored = TRUE
		animate(src, 5, pixel_y - 8)
		sleep(1 SECOND)
		src.anchored = FALSE
		animate(src, 5, pixel_y - 8)
	. = ..()

/obj/structure/rhombus/attack_hand(mob/living/carbon/human/user)
	if(!GLOB.thralls.is_antagonist(user.mind))
		return . = ..()
	if(do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
		if(charges > 0)
			to_chat(user, SPAN_ITALIC(SPAN_OCCULT("Нужно больше крови")))
		new /obj/temporary(get_turf(user), 10, 'icons/effects/effects.dmi', "rune_teleport")
		user.adjustCloneLoss(-20)
		user.adjustOxyLoss(-2)
		user.heal_organ_damage(20, 20)
		user.adjustToxLoss(-20)
		charges -= 1

/obj/structure/rhombus/Process()
	if(world.time > last_eat)
		var/obj/decal/cleanable/blood/B = locate() in range(3,src)
		if(B)
			last_eat = world.time + 5 SECONDS
			if(istype(B, /obj/decal/cleanable/blood/drip))
				charges += 0.25
			else
				charges += 1
				playsound(src.loc, 'sound/effects/splat.ogg', 50, 1, -3)
			var/turf/sucked = get_turf(B)
			new /obj/temporary(sucked, 10, 'icons/effects/effects.dmi', "cultwall")
			sucked.cultify()
			qdel(B)


/obj/effect/cult/cultwall
	name = "suction"
	icon_state = "cultwall"

/obj/effect/cult/cultwall/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/cult/cultwall/LateInitialize()
	animate(src, alpha = 0, 1 SECOND, easing = EASE_IN)
	QDEL_IN(src, 1 SECOND)
