// START STEALTH SUIT
/obj/item/clothing/head/helmet/space/vox/stealth
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_SMALL
		)

/obj/item/clothing/suit/space/vox/stealth
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_SMALL
		)
	action_button_name = "Toggle Cloak"
	var/cloak = FALSE
	var/cloak_charge = 300
	var/cloak_charge_max = 300

/obj/item/clothing/suit/space/vox/stealth/attack_self(mob/user)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return
	if(!istype(H.head, /obj/item/clothing/head/helmet/space/vox/stealth) || !istype(H.wear_suit, /obj/item/clothing/suit/space/vox/stealth))
		return
	if(!cloak)
		if(!do_after(H, 5 SECONDS, do_flags = DO_PUBLIC_UNIQUE | DO_USER_CAN_MOVE))
			return
	cloak(H)

/obj/item/clothing/suit/space/vox/stealth/proc/cloak(mob/living/carbon/human/H)
	if(cloak)
		cloak = FALSE
		return 1
	if(cloak_charge <= 30)
		to_chat(H, SPAN_WARNING("Cloak is out of charge!"))
		return
	to_chat(H, SPAN_NOTICE("Stealth mode enabled. Charge: [cloak_charge] seconds"))
	cloak = TRUE
	animate(H, alpha = 255, alpha = 1, time = 10)

	var/currentbrute = 0
	var/currentburn = 0
	var/datum/effect/spark_spread/spark_system = new /datum/effect/spark_spread
	var/remain_cloaked = TRUE
	while(remain_cloaked && cloak_charge > 0)
		currentbrute = H.getBruteLoss()
		currentburn = H.getFireLoss()
		sleep(1 SECOND)
		cloak_charge--
		if(cloak_charge == 60)
			to_chat(H, SPAN_WARNING("60 seconds untill reveal!"))
		if(!cloak)
			remain_cloaked = FALSE
		if(!istype(H.head, /obj/item/clothing/head/helmet/space/vox/stealth))
			remain_cloaked = FALSE
		if(currentbrute < H.getBruteLoss() || currentburn < H.getFireLoss())
			spark_system.set_up(5, 0, src)
			spark_system.attach(src)
			spark_system.start()
			remain_cloaked = FALSE

	H.visible_message(SPAN_WARNING("[H] suddenly fades in, seemingly from nowhere!"))
	to_chat(H, SPAN_NOTICE("Stealth mode disabled."))
	cloak = FALSE
	animate(H, alpha = 1, alpha = 255, time = 10)

	while(!cloak && cloak_charge < cloak_charge_max)
		sleep(1 SECOND)
		cloak_charge += 2
// END STEALTH SUIT
// ————————————————
// START PRESSURE SUIT
/obj/item/clothing/head/helmet/space/vox/pressure
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_STRONG,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_SMALL
		)
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/vox/pressure
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_STRONG,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_SMALL
		)
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/toolbox,/obj/item/storage/briefcase/inflatable,/obj/item/device/t_scanner,/obj/item/rcd,/obj/item/rpd)

/obj/item/clothing/suit/space/vox/pressure/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 1
// END PRESSURE SUIT
// ————————————————
// START MEDIC SUIT
/obj/item/clothing/head/helmet/space/vox/medic
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_STRONG,
		rad = ARMOR_RAD_RESISTANT
		)

/obj/item/clothing/head/helmet/space/vox/medic/Initialize()
	. = ..()
	slowdown_per_slot[slot_head] = 0

/obj/item/clothing/suit/space/vox/medic
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_STRONG,
		rad = ARMOR_RAD_RESISTANT
		)

/obj/item/clothing/suit/space/vox/medic/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = -1
// END MEDIC SUIT
// ————————————————
// START CARAPACE SUIT
/obj/item/clothing/head/helmet/space/vox/carapace
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_SMALL
		)

/obj/item/clothing/suit/space/vox/carapace
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_SMALL
		)
