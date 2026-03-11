GLOBAL_VAR(triangular_bipyramid_existing_in_world)

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
	var/health_points = 4
	var/charges = 0
	var/last_eat
	var/cooldown
	var/spell_cooldown

/obj/structure/rhombus/Initialize()
	GLOB.triangular_bipyramid_existing_in_world = 1
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/rhombus/Bumped(mob/living/carbon/human/user)
	if(!GLOB.thralls.is_antagonist(user.mind))
		src.anchored = TRUE
		sleep(1 SECOND)
		src.anchored = FALSE
	. = ..()

/obj/structure/rhombus/attack_hand(mob/living/carbon/human/user)
	if(!GLOB.thralls.is_antagonist(user.mind))
		return . = ..()
	if(do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
		if(charges <= 0)
			to_chat(user, SPAN_ITALIC(SPAN_OCCULT("Нужно больше крови")))
			return
		if(!user.lying)
			new /obj/temporary(get_turf(user), 10, 'icons/effects/effects.dmi', "rune_teleport")
		else
			new /obj/temporary(get_turf(user), 10, 'icons/effects/effects.dmi', "rune_convert")
		user.adjustCloneLoss(-20)
		user.adjustOxyLoss(-2)
		user.heal_organ_damage(20, 20)
		user.adjustToxLoss(-20)
		charges -= 1

/obj/structure/rhombus/use_grab(obj/item/grab/grab, list/click_params)
	if(GLOB.thralls.is_antagonist(grab.assailant.mind))
		attack_hand(grab.affecting)
	. = ..()

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
			return
		var/mob/living/carbon/human/affecting = pick(GLOB.thralls.current_antagonists)
		if(affecting && GLOB.thralls.is_antagonist(affecting.mind) && spell_cooldown < world.time)
			switch(charges)
				if(50 to 99)
					if(!("Cure Light Wounds" in affecting.mind.learned_spells))
						charges -= 50
						spell_cooldown = world.time + 5 MINUTES
						affecting.add_spell(new /spell/targeted/heal_target)
						new /obj/temporary(get_turf(affecting), 10, 'icons/effects/effects.dmi', "rune_teleport")
				if(100 to 500)
					if(!("Torment" in affecting.mind.learned_spells))
						charges -= 150
						spell_cooldown = world.time + 5 MINUTES
						affecting.add_spell(new /spell/targeted/torment/rhombus)
						new /obj/temporary(get_turf(affecting), 10, 'icons/effects/effects.dmi', "rune_teleport")
				if(500 to INFINITY)
					if(!("Phase Shift" in affecting.mind.learned_spells))
						charges -= 600
						spell_cooldown = world.time + 5 MINUTES
						affecting.add_spell(new /spell/targeted/ethereal_jaunt/shift)
						new /obj/temporary(get_turf(affecting), 10, 'icons/effects/effects.dmi', "rune_teleport")
// Количества почти не достижимы механом, чтобы сподвигать игрочков ублажать в РП

/obj/structure/rhombus/use_tool(obj/item/I, mob/user)
	..()
	if(istype(I, /obj/item/nullrod) && world.time > cooldown)
		playsound(src, 'mods/psionics/sounds/spiritcast.ogg', vary = TRUE, is_global = TRUE)
		tooc("Мне больно")
		if(cooldown > world.time)
			to_chat(user, SPAN_DANGER("РАНО"))
		if(do_after(user, 5 SECONDS, src, DO_PUBLIC_UNIQUE))
			health_points -= 1
			cooldown = world.time + 10 MINUTES
			if(health_points > 0)
				charges = charges * 0.1
				to_chat(user, SPAN_NOTICE("Я вожу у кристалла инструментом, он слабеет, но мне нужно еще [health_points] раза чтобы уничтожить его действие. \nСледующий обряд будет эффективен только через 10 минут"))
			else
				to_chat(user, SPAN_WARNING("Кристалл тухнет"))
				src.density = 0
				fuckit()

/obj/structure/rhombus/proc/tooc(message)
	if(health_points > 0)
		for(var/datum/mind/M in GLOB.thralls.current_antagonists)
			var/msg = ""
			if(icon)
				msg += "[icon2html(src, M)] "
			to_chat(M.current, (SPAN_OCCULT("<span style='font-variant-caps: all-small-caps;'[msg + message]</span>")))
		var/obj/effect = new(src.loc)
		effect.appearance = src.appearance
		animate(effect, 1 SECOND, transform = matrix()*2, alpha = 0)
		QDEL_IN(effect, 1 SECOND)

/obj/structure/rhombus/proc/fuckit()
	animate(src, 2 SECOND, color = "#333333", transform = turn(src.transform, 90), pixel_y = -16)
	icon_state = "dead"
	if(health_points < 0)
		src.visible_message("Рассыпается в пыль")
		animate(src, 1 SECOND, alpha = 0)
		for(var/datum/mind/M in GLOB.thralls.current_antagonists)
			GLOB.thralls.remove_antagonist(M)
			to_chat(M.current, SPAN_WARNING("Что я здесь делаю? Что случилось?"))
			alert(M.current, "ТЫ ЗАБУДЕШЬ ВСЕ ЧТО ЗНАЕШЬ И НИКОГДА НЕ ВСПОМНИШЬ ТО ЧТО ВИДЕЛ", " ", "Забыть")
			M.current.adjustBrainLoss(10)
		GLOB.triangular_bipyramid_existing_in_world = 0
		Destroy()

/spell/targeted/torment/rhombus/cast(list/targets, mob/user)
	new /obj/temporary(get_turf(user), 10, 'icons/effects/effects.dmi', "rune_teleport")
	for(var/mob/living/carbon/human/H in targets)
		if(!GLOB.thralls.is_antagonist(H.mind))
			H.adjustHalLoss(loss)
