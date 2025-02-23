// AI - Light drones
/datum/ai_holder/simple_animal/ascent_basic

/datum/ai_holder/simple_animal/ascent_basic/post_melee_attack(atom/A)
	if(holder.Adjacent(A))
		holder.IMove(get_step(holder, pick(GLOB.alldirs)))
		holder.face_atom(A)

//Bomber drone
/datum/ai_holder/simple_animal/ascent_basic/bomber
	home_low_priority = TRUE

//Ranged drone
/datum/ai_holder/simple_animal/ascent_basic/ranged
	pointblank = TRUE

// AI - Heavy drones
/datum/ai_holder/simple_animal/ascent_combat
	conserve_ammo = TRUE

/datum/ai_holder/simple_animal/ascent_combat/on_engagement(atom/A)
	if(get_dist(holder, A) < 4)
		holder.IMove(get_step_away(holder, A, 4))


/datum/ai_holder/simple_animal/ascent_combat/rapid
	pointblank = TRUE

/datum/ai_holder/simple_animal/ascent_combat/rapid/post_ranged_attack(atom/A)
	if(holder.Adjacent(A))
		holder.IMove(get_step(holder, pick(GLOB.alldirs)))
		holder.face_atom(A)

/datum/ai_holder/simple_animal/ascent_combat/heavy/on_engagement(atom/A)
	. = ..()
	if(get_dist(holder, A) > 8)
		holder.IMove(get_step_towards(holder, A))
		holder.face_atom(A)


// Light drones
/mob/living/simple_animal/hostile/ascent_basic
	name = "ascent maintainance drone"
	desc = "A small flying repair drone, its look is unusual and alien."
	icon = 'mods/drones/icons/drones.dmi'
	icon_state = "drone-default"
	icon_living = "drone-default"
	icon_dead = "drone-ascent"
	health = 20
	maxHealth = 20
	natural_weapon = /obj/item/natural_weapon/drone_slicer
	faction = "ascent"
	destroy_surroundings = 0
	min_gas = null
	max_gas = null
	minbodytemp = 0
	move_to_delay = -4
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)
	bleed_colour = SYNTH_BLOOD_COLOUR

	meat_type =     null
	meat_amount =   0
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   0

	ai_holder = /datum/ai_holder/simple_animal/ascent_basic
	say_list_type = null

//RANGED
/mob/living/simple_animal/hostile/ascent_basic/ranged
	icon_state = "drone-laser"
	icon_living = "drone-laser"
	ranged = 1
	projectiletype = /obj/item/projectile/beam/particle/small
	base_attack_cooldown = 3 SECONDS
	sa_accuracy = 50

//BOMBER
/mob/living/simple_animal/hostile/ascent_basic/bomber
	icon_state = "drone-bomber"
	icon_living = "drone-bomber"
	name = "ascent bomber drone"
	desc = "Uh oh. Run!!!"
	health = 5
	maxHealth = 5

	special_attack_max_range = 3

/mob/living/simple_animal/hostile/ascent_basic/bomber/attack_target(atom/A)
	. = ..()
	if(A)
		explosion(get_turf(A), 0, 0, 2, 4, FALSE)
		new /obj/gibspawner/robot(src)
		qdel(src)

// MY ASS IS HEAVY
/mob/living/simple_animal/hostile/ascent_combat
	name = "ascent combat drone"
	desc = "A big flying combat drone, its look is unusual and alien."
	icon = 'mods/drones/icons/drones.dmi'
	icon_state = "drone-combat"
	icon_living = "drone-combat"
	icon_dead = "drone-ascent"
	health = 80
	maxHealth = 80
	natural_weapon = /obj/item/natural_weapon/drone_slicer
	faction = "ascent"
	destroy_surroundings = 0
	min_gas = null
	max_gas = null
	minbodytemp = 0
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL
		)
	bleed_colour = SYNTH_BLOOD_COLOUR

	meat_type =     null
	meat_amount =   0
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   0

	ai_holder = /datum/ai_holder/simple_animal/ascent_combat
	say_list_type = null

	ranged = 1
	projectiletype = /obj/item/projectile/beam/particle
	base_attack_cooldown = 5 SECONDS
	sa_accuracy = 85
	ranged_range = 8


/mob/living/simple_animal/hostile/ascent_combat/rapid
	icon_state = "drone-heavy"
	icon_living = "drone-heavy"
	health = 50
	maxHealth = 50

	projectiletype = /obj/item/projectile/beam/particle/small
	rapid = 1
	sa_accuracy = 50
	ranged_range = 5

	needs_reload = TRUE
	reload_max = 3
	reload_time = 3 SECONDS
	base_attack_cooldown = 5

	ai_holder = /datum/ai_holder/simple_animal/ascent_combat/rapid

/mob/living/simple_animal/hostile/ascent_combat/heavy
	health = 200
	maxHealth = 200
	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_HEAVY,
		laser = ARMOR_LASER_HEAVY
		)
	ranged_attack_delay = 10
	projectiletype = /obj/item/projectile/beam/darkmatter
	movement_cooldown = 20
