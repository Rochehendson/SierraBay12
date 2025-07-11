/obj/item/organ/internal/augment/active/adaptive_monocular
	name = "adaptive monocular"
	augment_slots = AUGMENT_EYES
	icon_state = "adaptive_binoculars"
	desc = "Some sort of adaptive lenses. At the user's control, their image can be greatly enhanced, providing a view of distant areas."
	augment_flags = AUGMENT_BIOLOGICAL | AUGMENT_SCANNABLE | AUGMENT_MECHANICAL
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2)

/obj/item/organ/internal/augment/active/adaptive_monocular/attack_self()
	if(src.zoom)
		unzoom(usr)
	else
		zoom(usr)

/obj/item/organ/internal/augment/active/adaptive_monocular/emp_act(severity)
	. = ..()
	to_chat(owner, SPAN_WARNING("Your eye fill with static as monocular malfunction!"))
	owner.eye_blind += 10
	owner.eye_blurry += 20
	if (src.zoom)
		unzoom(usr)

/obj/item/organ/internal/augment/active/adaptive_monocular/onInstall()
	. = ..()
	limb = owner.get_organ(parent_organ)
	var/image/I = image('icons/mob/robots.dmi', owner, "robot", BASE_HUMAN_LAYER + 0.89)
	owner.AddOverlays(I, ATOM_ICON_CACHE_PROTECTED)

/obj/item/organ/internal/augment/active/adaptive_monocular/zoom(mob/user, tileoffset = 14,viewsize = 9)
	if(!user.client)
		return
	if(zoom)
		return

	if(!user.loc?.MayZoom())
		return

	var/devicename = zoomdevicename || name
	var/mob/living/carbon/human/H = user

	if(user.incapacitated(INCAPACITATION_DISABLED))
		to_chat(user, SPAN_WARNING("You are unable to focus through the [devicename]."))
		return
	else if(!zoom && istype(H) && H.equipment_tint_total >= TINT_MODERATE)
		to_chat(user, SPAN_WARNING("Your eyewear gets in the way of looking through the [devicename]."))
		return

	var/viewoffset = WORLD_ICON_SIZE * tileoffset
	switch(user.dir)
		if (NORTH)
			user.client.pixel_x = 0
			user.client.pixel_y = viewoffset
		if (SOUTH)
			user.client.pixel_x = 0
			user.client.pixel_y = -viewoffset
		if (EAST)
			user.client.pixel_x = viewoffset
			user.client.pixel_y = 0
		if (WEST)
			user.client.pixel_x = -viewoffset
			user.client.pixel_y = 0

	if(user.hud_used.hud_shown)
		user.toggle_zoom_hud()	// If the user has already limited their HUD this avoids them having a HUD when they zoom in
	if(istype(H))
		H.handle_vision()

	user.client.view = viewsize
	zoom = 1

	GLOB.destroyed_event.register(src, src, TYPE_PROC_REF(/obj/item, unzoom))
	GLOB.moved_event.register(user, src, TYPE_PROC_REF(/obj/item, unzoom))
	GLOB.dir_set_event.register(user, src, TYPE_PROC_REF(/obj/item, unzoom))
	GLOB.item_unequipped_event.register(src, user, TYPE_PROC_REF(/mob/living, unzoom))

	GLOB.stat_set_event.register(user, src, TYPE_PROC_REF(/obj/item, unzoom))

	user.visible_message("\The [user] peers through [zoomdevicename ? "the [zoomdevicename] of [src]" : "[src]"].")


/obj/item/device/augment_implanter/adaptive_monocular
	augment = /obj/item/organ/internal/augment/active/adaptive_monocular
