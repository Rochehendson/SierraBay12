// [SIERRA-REMOVE] - PSIONICS - (Перемещено в /mods/psionics)
/*
/obj/item/material/disrupts_psionics()
	return (material && material.is_psi_null()) ? src : FALSE

/obj/item/material/withstand_psi_stress(stress, atom/source)
	. = ..(stress, source)
	if(!health_dead() && . > 0 && disrupts_psionics())
		damage_health(.)
		. = max(0, -(get_current_health()))

/obj/item/material/shard/nullglass/New(newloc)
	..(newloc, MATERIAL_NULLGLASS)
*/
// [/SIERRA-REMOVE] - PSIONICS - (Перемещено в /mods/psionics)
