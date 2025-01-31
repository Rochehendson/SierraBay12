/singleton/psionic_faculty/energistics
	id = PSI_ENERGISTICS
	name = "Energistics"
	associated_intent = I_HURT
	armour_types = list("energy", "melee")

/singleton/psionic_power/energistics
	faculty = PSI_ENERGISTICS
	abstract_type = /singleton/psionic_power/energistics

/singleton/psionic_power/energistics/zorch
	name =             "Zorch"
	cost =             20
	cooldown =         20
	use_ranged =       TRUE
	min_rank =         PSI_RANK_APPRENTICE
	use_description = "Выберите красный интент и верхнюю часть тела, чтобы по нажатию запустить в цель луч концентрированной псионической энергии."

/singleton/psionic_power/energistics/zorch/invoke(mob/living/user, mob/living/target)
	if(user.zone_sel.selecting != BP_CHEST)
		return FALSE
	. = ..()
	if(.)
		user.visible_message("<span class='danger'>Глаза [user] загораются ярким светом!</span>")

		var/user_rank = user.psi.get_rank(faculty)
		var/meta_rank = user.psi.get_rank(PSI_METAKINESIS)
		var/obj/item/projectile/pew
		var/pew_sound

		switch(user_rank)
			if(PSI_RANK_GRANDMASTER)
				if(user.a_intent == I_HELP)
					if(meta_rank >= PSI_RANK_MASTER)
						pew = new /obj/item/projectile/beam/stun/shock/heavy(get_turf(user))
						pew.name = "gigawatt mental beam"
						pew_sound = 'sound/weapons/taser2.ogg'
					else
						pew = new /obj/item/projectile/beam/stun(get_turf(user))
						pew.name = "mental beam"
						pew.color = "#3ca7b1"
						pew_sound = 'sound/weapons/taser2.ogg'
				if(user.a_intent == I_HURT)
					pew = new /obj/item/projectile/beam/heavylaser(get_turf(user))
					pew.name = "gigawatt mental laser"
					pew.color = "#3ca7b1"
					pew_sound = 'sound/weapons/pulse.ogg'
			if(PSI_RANK_MASTER)
				if(user.a_intent == I_HELP)
					if(meta_rank == PSI_RANK_OPERANT)
						pew = new /obj/item/projectile/beam/stun/shock(get_turf(user))
						pew.name = "megawatt mental beam"
						pew_sound = 'sound/weapons/taser2.ogg'
					else
						pew = new /obj/item/projectile/beam/stun(get_turf(user))
						pew.name = "mental beam"
						pew.color = "#3ca7b1"
						pew_sound = 'sound/weapons/taser2.ogg'
				if(user.a_intent == I_HURT)
					pew = new /obj/item/projectile/beam/megabot(get_turf(user))
					pew.name = "megawatt mental laser"
					pew.color = "#3ca7b1"
					pew_sound = 'sound/weapons/Laser.ogg'
			if(PSI_RANK_OPERANT)
				if(user.a_intent == I_HELP)
					pew = new /obj/item/projectile/beam/stun(get_turf(user))
					pew.name = "mental beam"
					pew.color = "#3ca7b1"
					pew_sound = 'sound/weapons/taser2.ogg'
				if(user.a_intent == I_HURT)
					pew = new /obj/item/projectile/beam/midlaser(get_turf(user))
					pew.name = "mental laser"
					pew.color = "#3ca7b1"
					pew_sound = 'sound/weapons/scan.ogg'
			if(PSI_RANK_APPRENTICE)
				pew = new /obj/item/projectile/beam/stun/smalllaser(get_turf(user))
				pew.name = "mental beam"
				pew.color = "#3ca7b1"
				pew_sound = 'sound/weapons/taser2.ogg'

		if(istype(pew))
			playsound(pew.loc, pew_sound, 25, 1)
			pew.original = target
			pew.current = target
			pew.starting = get_turf(user)
			pew.shot_from = user
			pew.launch(target, user.zone_sel.selecting, (target.x-user.x), (target.y-user.y))
			return TRUE

/singleton/psionic_power/energistics/disrupt
	name =            "Disrupt"
	cost =            10
	cooldown =        60
	use_melee =       TRUE
	min_rank =        PSI_RANK_OPERANT
	use_description = "Выберите глаза на красном интенте и нажмите на любой объект, чтобы создать мощный электромагнитный импульс, направленный в него."

/singleton/psionic_power/energistics/disrupt/invoke(mob/living/user, mob/living/target)
	var/en_rank = user.psi.get_rank(PSI_ENERGISTICS)
	if(user.zone_sel.selecting != BP_EYES)
		return FALSE
	if(user.a_intent != I_HURT)
		return FALSE
	if(istype(target, /turf))
		return FALSE
	. = ..()
	if(.)
		if(en_rank == PSI_RANK_GRANDMASTER)
			var/option = input(user, "Choose something!", "How big should be the empulse?") in list("Concentrated", "Uncontrolled")
			if (!option)
				return
			if(option == "Concentrated")
				new /obj/temporary(get_turf(target),3, 'icons/effects/effects.dmi', "blue_electricity_constant")
				target.visible_message("<span class='danger'>[user] переполняет [target] энергией, провоцируя внезапное высвобождение ЭМИ-импульса!</span>")
				empulse(target, 0, 1)
			if(option == "Uncontrolled")
				new /obj/temporary(get_turf(target),3, 'icons/effects/effects.dmi', "blue_electricity_constant")
				target.visible_message("<span class='danger'>[user] взмахивает рукой, создавая мощную ЭМИ-волну!</span>")
				empulse(target, 6, 8)
		if(en_rank <= PSI_RANK_OPERANT)
			new /obj/temporary(get_turf(target),3, 'icons/effects/effects.dmi', "blue_electricity_constant")
			target.visible_message("<span class='danger'>[user] взмахивает рукой, создавая мощный ЭМИ-импульс!</span>")
			empulse(target, rand(2,4) - en_rank, rand(3,6) - en_rank)
		if(en_rank == PSI_RANK_MASTER)
			new /obj/temporary(get_turf(target),3, 'icons/effects/effects.dmi', "blue_electricity_constant")
			target.visible_message("<span class='danger'>[user] взмахивает рукой, создавая мощный ЭМИ-импульс!</span>")
			empulse(target, 1, 2)
		return TRUE

/singleton/psionic_power/energistics/spit
	name =             "Ballistic Projectile"
	cost =             20
	cooldown =         45
	use_ranged =       TRUE
	use_melee =       TRUE
	min_rank =         PSI_RANK_APPRENTICE
	use_description = "Выберите голову на красном интенте и нажмите по чему угодно, чтобы запустить пулю."

	var/psi_shot = "Standard"

/singleton/psionic_power/energistics/spit/invoke(mob/living/user, mob/living/target)

	var/list/options = list(
		"Armor Piercing" = image('mods/psionics/icons/psi.dmi', "AP"),
		"Explosive" = image('mods/psionics/icons/psi.dmi', "EXP"),
		"Piercing Charges" = image('mods/psionics/icons/psi.dmi', "EXPAP"),
		"Standard" = image('mods/psionics/icons/psi.dmi', "DEF")
	)

	if(user.zone_sel.selecting != BP_HEAD)
		return FALSE
	. = ..()
	if(.)

		var/user_rank = user.psi.get_rank(faculty)
		var/obj/item/projectile/pew
		var/pew_sound

		if(target == user && user.a_intent == I_HELP)
			var/chosen_option = show_radial_menu(user, user, options, radius = 20, require_near = TRUE)
			if (!chosen_option)
				return
			psi_shot = chosen_option
			to_chat(user, "<span class='warning'>Теперь, ты будешь выпускать снаряды типа '[chosen_option]' при использовании данной способности.</span>")
			return TRUE

		if(user.a_intent != I_HURT)
			return FALSE

		if(psi_shot == "Standard")
			user.visible_message("<span class='danger'>[user] изображает пальцами пистолет, делая выстрел!</span>")
			if(user_rank < PSI_RANK_MASTER)
				pew = new /obj/item/projectile/psi(get_turf(user))
				pew.name = "small psionic bullet"
				pew_sound = 'sound/weapons/guns/ricochet4.ogg'
			if(user_rank >= PSI_RANK_MASTER)
				pew = new /obj/item/projectile/psi(get_turf(user))
				pew.name = "psionic bullet"
				pew.damage = 40
				pew_sound = 'sound/weapons/guns/ricochet4.ogg'

		if(psi_shot == "Armor Piercing")
			user.visible_message("<span class='danger'>[user] изображает пальцами пистолет, делая выстрел!</span>")
			if(user_rank == PSI_RANK_APPRENTICE)
				if(prob(10))
					pew = new /obj/item/projectile/psi(get_turf(user))
					pew.name = "piercing psionic bullet"
					pew.color = "#a70909"
					pew.armor_penetration = 80
					pew.penetrating = 5
					pew.penetration_modifier = 1.1
					pew_sound = 'sound/weapons/guns/ricochet4.ogg'
				else
					pew = new /obj/item/projectile/psi(get_turf(user))
					pew.name = "small psionic bullet"
					pew_sound = 'sound/weapons/guns/ricochet4.ogg'
					to_chat(user, "<span class='warning'>Ты пытаешься сконцентрировать всю энергию в одном маленьком сгустке, дабы создать пробивной снаряд, но что-то мешает тебе...</span>")
			if(user_rank == PSI_RANK_OPERANT)
				pew = new /obj/item/projectile/psi(get_turf(user))
				pew.name = "piercing psionic bullet"
				pew.color = "#a70909"
				pew.armor_penetration = 80
				pew.penetrating = 5
				pew.penetration_modifier = 1.1
				pew_sound = 'sound/weapons/guns/ricochet4.ogg'
			if(user_rank >= PSI_RANK_MASTER)
				pew = new /obj/item/projectile/psi(get_turf(user))
				pew.name = "piercing psionic bullet"
				pew.color = "#a70909"
				pew.armor_penetration = 100
				pew.penetrating = 6
				pew.penetration_modifier = 1.1
				pew.damage = 40
				pew_sound = 'sound/weapons/guns/ricochet4.ogg'

		if(psi_shot == "Explosive")
			user.visible_message("<span class='danger'>[user] делает резкий выпад рукой, запуская в полёт огромный сгусток энергии!</span>")
			if(user_rank < PSI_RANK_OPERANT)
				if(prob(10))
					pew = new /obj/item/projectile/psi/strong(get_turf(user))
					pew.name = "explosive psionic round"
					pew.damage = 10
					pew_sound = 'sound/weapons/guns/ricochet4.ogg'
				else
					to_chat(user, "<span class='danger'>Огромный ком энергии накапливается внутри тебя, готовясь вырваться наружу, но что-то идёт не так...</span>")
					explosion(get_turf(user), 1, 2)
			if(user_rank >= PSI_RANK_OPERANT)
				pew = new /obj/item/projectile/psi/strong(get_turf(user))
				pew.name = "explosive psionic round"
				pew_sound = 'sound/weapons/guns/ricochet4.ogg'

		if(psi_shot == "Piercing Charges")
			user.visible_message("<span class='danger'>[user] выставляет перед собой руку, создавая импровизированную трубу и пропускает через неё сжатый сгусток энергии!</span>")
			if(user_rank <= PSI_RANK_OPERANT)
				if(prob(30))
					pew = new /obj/item/projectile/psi/strong_piercing(get_turf(user))
					pew.name = "piercing psionic round"
					pew.color = "#a70909"
					pew.damage = 20
					pew_sound = 'sound/weapons/guns/ricochet4.ogg'
				else
					pew = new /obj/item/projectile/psi(get_turf(user))
					pew.name = "piercing psionic bullet"
					pew.color = "#a70909"
					pew.armor_penetration = 80
					pew.penetrating = 5
					pew.penetration_modifier = 1.1
					pew_sound = 'sound/weapons/guns/ricochet4.ogg'
					to_chat(user, "<span class='warning'>Ты пытаешься сконцентрировать всю энергию в одном маленьком сгустке, дабы создать пробивной снаряд, но что-то мешает тебе...</span>")
					explosion(get_turf(user), 2, 3)
			if(user_rank == PSI_RANK_MASTER)
				if(prob(70))
					pew = new /obj/item/projectile/psi/strong_piercing(get_turf(user))
					pew.name = "piercing psionic round"
					pew.color = "#a70909"
					pew.damage = 20
					pew_sound = 'sound/weapons/guns/ricochet4.ogg'
				else
					to_chat(user, "<span class='warning'>Ты пытаешься сконцентрировать всю энергию в одном маленьком сгустке, дабы создать пробивной снаряд, но что-то мешает тебе...</span>")
					explosion(get_turf(user), 2, 3)
			if(user_rank == PSI_RANK_GRANDMASTER)
				pew = new /obj/item/projectile/psi/strong_piercing(get_turf(user))
				pew.name = "piercing psionic round"
				pew.color = "#a70909"
				pew_sound = 'sound/weapons/guns/ricochet4.ogg'

		if(istype(pew))
			playsound(pew.loc, pew_sound, 25, 1)
			pew.original = target
			pew.current = target
			pew.starting = get_turf(user)
			pew.shot_from = user
			pew.launch(target, user.zone_sel.selecting, (target.x-user.x), (target.y-user.y))
		return TRUE

/singleton/psionic_power/energistics/storm
	name =             "Bullet Storm"
	cost =             30
	cooldown =         120
	min_rank =         PSI_RANK_OPERANT
	use_melee =        TRUE
	use_description = "Выберите рот на красном интенте и нажмите в любое место около себя, чтобы создать рой псионических снарядов, летящих в разные стороны."
	var/psi_shot = "Standart"

/singleton/psionic_power/energistics/storm/invoke(mob/living/user, mob/living/target)
	var/list/options = list(
		"Explosive" = image('mods/psionics/icons/psi.dmi', "EXP"),
		"Standart" = image('mods/psionics/icons/psi.dmi', "DEF")
	)

	if(user.zone_sel.selecting != BP_MOUTH)
		return FALSE
	. = ..()
	if(.)
		var/user_rank = user.psi.get_rank(faculty)

		if(target == user && user.a_intent == I_HELP && user_rank == PSI_RANK_GRANDMASTER)
			var/chosen_option = show_radial_menu(user, user, options, radius = 20, require_near = TRUE)
			if (!chosen_option)
				return
			psi_shot = chosen_option
			to_chat(user, "<span class='warning'>Теперь, ты будешь выпускать снаряды типа '[chosen_option]' при использовании данной способности.</span>")
			return TRUE

		if(user.a_intent != I_HURT)
			return FALSE

		user.visible_message("<span class='danger'>[user] создаёт вокруг себя рой из вращающихся пуль, запуская их в полёт!</span>")

		user.psi.set_cooldown(cooldown)
		sleep(4)
		user.psi.spend_power(cost)
		var/turf/O = get_turf(src)
		switch(user_rank)
			if(PSI_RANK_GRANDMASTER)
				if(psi_shot == "Explosive")
					user.fragmentate(O, 10, 4, list(/obj/item/projectile/psi/strong = 1))
				else
					user.fragmentate(O, 40, 7, list(/obj/item/projectile/psi = 1))
			if(PSI_RANK_MASTER)
				user.fragmentate(O, 30, 6, list(/obj/item/projectile/psi = 1))
			if(PSI_RANK_OPERANT)
				user.fragmentate(O, 20, 5, list(/obj/item/projectile/psi = 1))
		return TRUE

/mob/proc/fragmentate(turf/T=get_turf(src), fragment_number = 30, spreading_range = 5, list/fragtypes=list(/obj/item/projectile))
	set waitfor = 0
	var/list/target_turfs = getcircle(T, spreading_range)
	for(var/turf/O in target_turfs)
		sleep(0)
		var/fragment_type = pickweight(fragtypes)
		var/obj/item/projectile/P = new fragment_type(T)
		P.shot_from = src.name
		P.launch(O)


/singleton/psionic_power/energistics/cloud
	name =            "Cloud"
	cost =            20
	cooldown =        50
	use_melee =       TRUE
	min_rank =        PSI_RANK_OPERANT
	use_description = "Выберите грудь на зелёном интенте и нажмите по себе, чтобы создать дымовую завесу."
	admin_log = FALSE
	var/turf/previousturf = null
	var/inner_radius = -1 //for all your ring spell needs
	var/outer_radius = 2

/obj/smoke_wall
	icon_state = "smoke wall"
	anchored = TRUE
	opacity = FALSE
	layer = ABOVE_HUMAN_LAYER
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke"
	pixel_x = -9
	pixel_y = -6
	var/timer = 30

/obj/smoke_wall/New()
	. = ..()
	run_timer()

/obj/smoke_wall/proc/run_timer()
	set waitfor = 0
	var/T = timer
	while(T > 0)
		sleep(1 SECOND)
		T--
	src.alpha = 200
	sleep(2)
	src.alpha = 150
	sleep(2)
	src.alpha = 100
	sleep(2)
	src.alpha = 50
	sleep(2)
	src.alpha = 20
	sleep(2)
	src.alpha = 10
	qdel(src)

/singleton/psionic_power/energistics/cloud/invoke(mob/living/user, mob/living/target)
	var/en_rank_user = user.psi.get_rank(PSI_ENERGISTICS)

	if(en_rank_user == PSI_RANK_GRANDMASTER)
		outer_radius = 4

	if(user.zone_sel.selecting != BP_CHEST)
		return FALSE
	if(target != user)
		return FALSE
	if(user.a_intent != I_HELP)
		return FALSE

	. = ..()

	if(target == user)
		var/list/targets = list()

		for(var/turf/point in oview_or_orange(outer_radius, user, "range"))
			if(!(point in oview_or_orange(inner_radius, user, "range")))
				if(point.density)
					continue
				if(istype(point, /turf/space))
					continue
				targets += point

		if(!LAZYLEN(targets))
			return FALSE

		var/turf/user_turf = get_turf(user)
		for(var/turf/T in targets)
			var/obj/smoke_wall/IW = new(T)
			if(istype(IW))
				IW.pixel_x = (user_turf.x - T.x) * world.icon_size
				IW.pixel_y = (user_turf.y - T.y) * world.icon_size
				animate(IW, pixel_x = 0, pixel_y = 0, time = 3, easing = EASE_OUT)

		return TRUE
