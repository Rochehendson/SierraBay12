/obj/item/clothing/suit/storage/hooded/asamblee
	name = "Asamblee mantle"
	desc = "A thick, layered black undersuit lined with power cables filled with psi-disrupting materials."
	icon = 'mods/psionics/icons/asamblee/asamblee.dmi'
	item_icons = list(slot_wear_suit_str = 'mods/psionics/icons/asamblee/asamblee_onmob.dmi')
	icon_state = "asamblee_red"
	action_button_name = "Toggle Mantle Hood"
	hoodtype = /obj/item/clothing/head/asamblee

/obj/item/clothing/suit/storage/hooded/asamblee/on_update_icon()
	icon_state = "[initial(icon_state)]"

/obj/item/clothing/head/asamblee
	name = "Asamblee mantle hood"
	desc = "It's a bulky design with lots of sensors and looks more like a huge makeshift helmet than a device. Something's missing"
	icon = 'mods/psionics/icons/asamblee/asamblee.dmi'
	icon_state = "asamblee_red_head"
	item_icons = list(slot_head_str = 'mods/psionics/icons/asamblee/asamblee_onmob.dmi')
	flags_inv = HIDEEARS | BLOCKHAIR
