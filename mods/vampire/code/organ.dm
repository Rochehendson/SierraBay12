/obj/item/organ/internal/vepiphysis
	name = "gifted epiphysis"
	desc = "pulsating, mass of blue flesh"
	icon = 'mods/vampire/icon/vamp.dmi'
	icon_state = "epiphysis"
	dead_icon = "epiphysis-dead"
	relative_size = 1
	parent_organ = BP_HEAD
	can_be_printed = FALSE

/obj/item/organ/internal/vepiphysis/remove_rejuv()
	return

/obj/item/organ/internal/vepiphysis/die()
	. = ..()
