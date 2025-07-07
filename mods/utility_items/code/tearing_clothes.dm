/mob/living/carbon/human/proc/handle_clothing_punctures(damtype, damage, def_zone)
	if (damtype != DAMAGE_BURN && damtype != DAMAGE_BRUTE)
		return
	if (def_zone == list(BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT, BP_HEAD)) return

	if(w_uniform)
		var/obj/item/clothing/under/U = w_uniform
		var/datum/tattering/T = new()
		T.create_tattering(U, damtype)
	if(wear_suit && !istype(wear_suit, /obj/item/clothing/suit/space))
		var/obj/item/clothing/suit/S = wear_suit
		var/datum/tattering/T = new()
		T.create_tattering(S, damtype)

/datum/tattering
	var/damtype = DAMAGE_BRUTE
	var/icon/broken_outline = icon('mods/utility_items/icons/tattering.dmi', "tarnished")

/datum/tattering/proc/create_tattering(obj/item/clothing/C, damtype)
	var/icon/I = new(C.icon, C.icon_state)
	I.Blend(icon('mods/utility_items/icons/tattering.dmi', "tarnished"), ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	C.icon = I
	C.update_icon()

	var/image/ret = C.get_mob_overlay(C.loc, slot_w_uniform_str)
	ret.AddOverlays(broken_outline)
