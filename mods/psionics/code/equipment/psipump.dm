// WITHOUT CRYSTAL
/obj/item/clothing/head/helmet/psipump
	name = "Psi-pump"
	desc = "It's a bulky design with lots of sensors and looks more like a huge makeshift helmet than a device. Something's missing"
	icon = 'mods/psionics/icons/pump/pump.dmi'
	icon_state = "psipump"
	item_icons = list(slot_head_str = 'mods/psionics/icons/pump/pump_on_mob.dmi')
	matter = list(MATERIAL_STEEL = 20000)

	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet"
		)
	w_class = ITEM_SIZE_LARGE

/obj/item/clothing/head/helmet/psipump/attack_hand(mob/living/carbon/human/H)
	if(src == H.head)
		to_chat(H, SPAN_NOTICE("You need help taking this off!"))
		return
	..()

/obj/item/clothing/head/helmet/psipump/MouseDrop(obj/over_object)
	return

/obj/item/clothing/head/helmet/psipump/use_tool(obj/item/tool, mob/user)
	if (istype(tool, /obj/item/device/soulstone))
		qdel(tool)
		new /obj/item/clothing/head/helmet/psipump/active(get_turf(src))
		qdel(src)
	return ..()

/datum/fabricator_recipe/psipump
	name = "Psi-pump assembly"
	path = /obj/item/clothing/head/helmet/psipump

// WITH CRYSTAL
/obj/item/clothing/head/helmet/psipump/active
	name = "Psi-pump"
	desc = "It's a bulky design with lots of sensors and looks more like a huge makeshift helmet than a device."
	icon_state = "psipump"

	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet"
		)
	w_class = ITEM_SIZE_LARGE

/obj/item/clothing/head/helmet/psipump/active/disrupts_psionics()
	return src

/datum/codex_entry/psipump
	associated_paths = list(/obj/item/clothing/head/helmet/psipump, /obj/item/clothing/head/helmet/psipump/active)
	lore_text = "The psi-pump is a device developed by an exonet psychopath, which was subsequently posted online as a template for lathes. The device is securely fixed on the head and without outside help, it is almost impossible to remove. The 'soul' crystal inside disrupts the functioning of psionics."
