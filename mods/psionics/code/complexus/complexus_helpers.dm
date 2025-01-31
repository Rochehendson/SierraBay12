/datum/psi_complexus/proc/cancel()
	sound_to(owner, sound('sound/effects/psi/power_fail.ogg'))
	if(LAZYLEN(manifested_items))
		for(var/thing in manifested_items)
			owner.drop_from_inventory(thing)
			qdel(thing)
		manifested_items = null

/datum/psi_complexus/proc/stunned(amount)
	var/old_stun = stun
	stun = max(stun, amount)
	if(amount && !old_stun)
		to_chat(owner, SPAN_DANGER("Your concentration has been shattered! You cannot focus your psi power!"))
		ui.update_icon()
	cancel()

/datum/psi_complexus/proc/get_armour(armourtype)
	if(use_psi_armour && can_use_passive())
		return round(clamp(clamp(4 * rating, 0, 20) * get_rank(SSpsi.armour_faculty_by_type[armourtype]), 0, 100) * (stamina/max_stamina))
	else
		return 0

/datum/psi_complexus/proc/get_rank(faculty)
	return LAZYACCESS(ranks, faculty)

/datum/psi_complexus/proc/set_rank(faculty, rank, defer_update, temporary)
	if(get_rank(faculty) != rank)
		LAZYSET(ranks, faculty, rank)
		LAZYSET(ranks_stat, faculty, TRUE)
		if(!temporary)
			LAZYSET(base_ranks, faculty, rank)
		if(!defer_update)
			update()

/datum/psi_complexus/proc/set_cooldown(value)
	next_power_use = world.time + value
	ui.update_icon()

/datum/psi_complexus/proc/can_use_passive()
	return (owner.stat == CONSCIOUS && !suppressed && !stun)

/datum/psi_complexus/proc/can_use(incapacitation_flags)
	return (owner.stat == CONSCIOUS && (!incapacitation_flags || !owner.incapacitated(incapacitation_flags)) && !suppressed && !stun && world.time >= next_power_use)

/datum/psi_complexus/proc/spend_power(value = 0, check_incapacitated)
	. = FALSE
	if(isnull(check_incapacitated))
		check_incapacitated = (INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT)
	if(can_use(check_incapacitated))
		value = max(1, ceil(value * cost_modifier))
		if(value <= stamina)
			stamina -= value
			ui.update_icon()
			. = TRUE
		else
			backblast(abs(stamina - value))
			stamina = 0
			. = FALSE
		ui.update_icon()

/datum/psi_complexus/proc/spend_power_armor(value = 0)
	armor_cost += value

/datum/psi_complexus/proc/hide_auras()
	if(owner.client)
		for(var/thing in SSpsi.all_aura_images)
			owner.client.images -= thing

/datum/psi_complexus/proc/show_auras()
	if(owner.client)
		for(var/image/I in SSpsi.all_aura_images)
			owner.client.images |= I

/datum/psi_complexus/proc/backblast(value)

	// Can't backblast if you're controlling your power.
	if(!owner || suppressed)
		return FALSE

	sound_to(owner, sound('sound/effects/psi/power_feedback.ogg'))
	to_chat(owner, SPAN_DANGER(FONT_LARGE("Wild energistic feedback blasts across your psyche!")))
	stunned(value * 2)
	set_cooldown(value * 100)

	if(prob(value*10)) owner.seizure()

	// Your head asplode.
	owner.adjustBrainLoss(value)
	if(ishuman(owner))
		var/mob/living/carbon/human/pop = owner
//FD PSIONICS//
		if(pop.levitation)
			pop.levitation = FALSE
			pop.pass_flags &= ~PASS_FLAG_TABLE
			pop.pixel_y = 0
			pop.CutOverlays(image('mods/psionics/icons/psi.dmi', "levitation"))
			pop.stop_floating()
//FD PSIONICS//
		if(pop.should_have_organ(BP_BRAIN))
			var/obj/item/organ/internal/brain/sponge = pop.internal_organs_by_name[BP_BRAIN]
			if(sponge && sponge.damage >= sponge.max_damage)
				var/obj/item/organ/external/affecting = pop.get_organ(sponge.parent_organ)
				if(affecting && !affecting.is_stump())
					affecting.droplimb(0, DROPLIMB_BLUNT)
					if(sponge) qdel(sponge)

/datum/psi_complexus/proc/reset()
	aura_color = initial(aura_color)
	ranks = base_ranks ? base_ranks.Copy() : null
	max_stamina = initial(max_stamina)
	stamina = min(stamina, max_stamina)
	cancel()
	update()
