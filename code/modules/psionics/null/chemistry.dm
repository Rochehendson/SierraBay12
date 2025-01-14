/*
// [SIERRA-REMOVE] - PSIONICS - (Перемещено в /mods/psionics)
/singleton/reaction/nullglass
	name = "Soulstone"
	result = null
	required_reagents = list(/datum/reagent/blood = 15, /datum/reagent/crystal = 1)
	result_amount = 1

/singleton/reaction/nullglass/get_reaction_flags(datum/reagents/holder)
	for(var/datum/reagent/blood/blood in holder.reagent_list)
		var/weakref/donor_ref = islist(blood.data) && blood.data["donor"]
		if(istype(donor_ref))
			var/mob/living/donor = donor_ref.resolve()
			if(istype(donor) && (donor.psi || (donor.mind && GLOB.wizards.is_antagonist(donor.mind))))
				return TRUE

/singleton/reaction/nullglass/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	var/location = get_turf(holder.my_atom)
	if(reaction_flags)
		for(var/i = 1, i <= created_volume, i++)
			new /obj/item/device/soulstone(location)
	else
		for(var/i = 1, i <= created_volume*2, i++)
			new /obj/item/material/shard(location, MATERIAL_CRYSTAL)

/datum/reagent/crystal
	name = "crystallizing agent"
	taste_description = "sharpness"
	reagent_state = LIQUID
	color = "#13bc5e"
	should_admin_log = TRUE

/datum/reagent/crystal/affect_blood(mob/living/carbon/M, removed)
	var/result_mat = (M.psi || (M.mind && GLOB.wizards.is_antagonist(M.mind))) ? MATERIAL_NULLGLASS : MATERIAL_CRYSTAL
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in shuffle(H.organs.Copy()))
			if(E.is_stump())
				continue

			if(BP_IS_CRYSTAL(E))
				if((E.brute_dam + E.burn_dam) > 0)
					if(prob(35))
						to_chat(M, SPAN_NOTICE("You feel a crawling sensation as fresh crystal grows over your [E.name]."))
					E.heal_damage(rand(5,8), rand(5,8))
					break
				if(BP_IS_BRITTLE(E))
					E.status &= ~ORGAN_BRITTLE
					break
			else if(prob(15))
				to_chat(H, SPAN_DANGER("Your [E.name] is being lacerated from within!"))
				if(E.can_feel_pain())
					H.emote("scream")
				if(prob(25))
					for(var/i = 1 to rand(1,3))
						new /obj/item/material/shard(get_turf(E), result_mat)
					E.take_external_damage(rand(50,70), 0)
				else
					E.take_external_damage(rand(20,30), 0)
					E.status |= ORGAN_CRYSTAL
					E.status |= ORGAN_BRITTLE
				break

		for(var/obj/item/organ/internal/I in shuffle(H.internal_organs.Copy()))
			if(I.organ_tag == BP_BRAIN)
				continue

			if(BP_IS_CRYSTAL(I))
				if(prob(35))
					to_chat(M, SPAN_NOTICE("You feel a deep, sharp tugging sensation as your [I.name] is mended."))
				I.heal_damage(rand(1,3))
				break
				if(BP_IS_BRITTLE(I))
					I.status &= ~ORGAN_BRITTLE
					break
			else if(prob(15))
				to_chat(H, SPAN_DANGER("You feel visceral, sharp twisting within your body!"))
				if(I.can_feel_pain())
					H.emote("scream")
				if(prob(25))
					I.take_internal_damage(rand(10,15), 0)
				else
					I.take_internal_damage(rand(5,10), 0)
					I.status |= ORGAN_CRYSTAL
					I.status |= ORGAN_BRITTLE
				break
	else
		to_chat(M, SPAN_DANGER("Your flesh is being lacerated from within!"))
		M.adjustBruteLoss(rand(3,6))
		if(prob(10))
			new /obj/item/material/shard(get_turf(M), result_mat)
*/
// [/SIERRA-REMOVE] - PSIONICS - (Перемещено в /mods/psionics)
