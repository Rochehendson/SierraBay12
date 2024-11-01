#define INVOKE_PSI_POWERS(holder, powers, target, return_on_invocation) \
	if(holder && holder.psi && holder.psi.can_use()) { \
		for(var/thing in powers) { \
			var/singleton/psionic_power/power = thing; \
			var/obj/item/result = power.invoke(holder, target); \
			if(result) { \
				power.handle_post_power(holder, target); \
				if(istype(result)) { \
					sound_to(holder, sound('sound/effects/psi/power_evoke.ogg')); \
					LAZYADD(holder.psi.manifested_items, result); \
					holder.put_in_hands(result); \
				} \
				return return_on_invocation; \
			} \
		} \
	}

/mob/living/UnarmedAttack(atom/A, proximity)
	. = ..()
	if(. && psi)
		INVOKE_PSI_POWERS(src, psi.get_melee_powers(SSpsi.faculties_by_intent[a_intent]), A, FALSE)
		if(a_intent == I_HURT)
			INVOKE_PSI_POWERS(src, psi.get_melee_powers(SSpsi.faculties_by_name_new["Hyloforia"]), A, FALSE)
			INVOKE_PSI_POWERS(src, psi.get_melee_powers(SSpsi.faculties_by_name_new["Teleplexy"]), A, FALSE)
		if(a_intent == I_GRAB)
			INVOKE_PSI_POWERS(src, psi.get_melee_powers(SSpsi.faculties_by_name_new["Teleplexy"]), A, FALSE)
			INVOKE_PSI_POWERS(src, psi.get_melee_powers(SSpsi.faculties_by_name_new["Metaplexy"]), A, FALSE)
			INVOKE_PSI_POWERS(src, psi.get_melee_powers(SSpsi.faculties_by_name_new["Demiurgy"]), A, FALSE)
		if(a_intent == I_DISARM)
			INVOKE_PSI_POWERS(src, psi.get_melee_powers(SSpsi.faculties_by_name_new["Catastellia"]), A, FALSE)
			INVOKE_PSI_POWERS(src, psi.get_melee_powers(SSpsi.faculties_by_name_new["Allaxetia"]), A, FALSE)
		if(a_intent == I_HELP)
			INVOKE_PSI_POWERS(src, psi.get_melee_powers(SSpsi.faculties_by_name_new["Ephanoferia"]), A, FALSE)
			INVOKE_PSI_POWERS(src, psi.get_melee_powers(SSpsi.faculties_by_name_new["Hyloforia"]), A, FALSE)
			INVOKE_PSI_POWERS(src, psi.get_melee_powers(SSpsi.faculties_by_name_new["Allaxetia"]), A, FALSE)

/mob/living/RangedAttack(atom/A, params)
	if(psi)
		INVOKE_PSI_POWERS(src, psi.get_ranged_powers(SSpsi.faculties_by_intent[a_intent]), A, TRUE)
		if(a_intent == I_HURT)
			INVOKE_PSI_POWERS(src, psi.get_ranged_powers(SSpsi.faculties_by_name_new["Hyloforia"]), A, TRUE)
			INVOKE_PSI_POWERS(src, psi.get_ranged_powers(SSpsi.faculties_by_name_new["Teleplexy"]), A, TRUE)
		if(a_intent == I_GRAB)
			INVOKE_PSI_POWERS(src, psi.get_ranged_powers(SSpsi.faculties_by_name_new["Teleplexy"]), A, TRUE)
			INVOKE_PSI_POWERS(src, psi.get_ranged_powers(SSpsi.faculties_by_name_new["Metaplexy"]), A, TRUE)
			INVOKE_PSI_POWERS(src, psi.get_ranged_powers(SSpsi.faculties_by_name_new["Demiurgy"]), A, TRUE)
		if(a_intent == I_DISARM)
			INVOKE_PSI_POWERS(src, psi.get_ranged_powers(SSpsi.faculties_by_name_new["Catastellia"]), A, TRUE)
		if(a_intent == I_HELP)
			INVOKE_PSI_POWERS(src, psi.get_ranged_powers(SSpsi.faculties_by_name_new["Hyloforia"]), A, TRUE)
			INVOKE_PSI_POWERS(src, psi.get_ranged_powers(SSpsi.faculties_by_name_new["Ephanoferia"]), A, TRUE)
			INVOKE_PSI_POWERS(src, psi.get_ranged_powers(SSpsi.faculties_by_name_new["Allaxetia"]), A, TRUE)
	. = ..()

/mob/living/proc/check_psi_grab(obj/item/grab/grab)
	if(psi && ismob(grab.affecting))
		INVOKE_PSI_POWERS(src, psi.get_grab_powers(SSpsi.faculties_by_intent[a_intent]), grab.affecting, FALSE)
		if(a_intent == I_HURT)
			INVOKE_PSI_POWERS(src, psi.get_grab_powers(SSpsi.faculties_by_name_new["Hyloforia"]), grab.affecting, FALSE)
		if(a_intent == I_GRAB)
			INVOKE_PSI_POWERS(src, psi.get_grab_powers(SSpsi.faculties_by_name_new["Teleplexy"]), grab.affecting, FALSE)
			INVOKE_PSI_POWERS(src, psi.get_grab_powers(SSpsi.faculties_by_name_new["Metaplexy"]), grab.affecting, FALSE)
			INVOKE_PSI_POWERS(src, psi.get_grab_powers(SSpsi.faculties_by_name_new["Demiurgy"]), grab.affecting, FALSE)
		if(a_intent == I_DISARM)
			INVOKE_PSI_POWERS(src, psi.get_grab_powers(SSpsi.faculties_by_name_new["Catastellia"]), grab.affecting, FALSE)
		if(a_intent == I_HELP)
			INVOKE_PSI_POWERS(src, psi.get_grab_powers(SSpsi.faculties_by_name_new["Ephanoferia"]), grab.affecting, FALSE)
			INVOKE_PSI_POWERS(src, psi.get_grab_powers(SSpsi.faculties_by_name_new["Allaxetia"]), grab.affecting, FALSE)

/mob/living/attack_empty_hand(bp_hand)
	if(psi)
		INVOKE_PSI_POWERS(src, psi.get_manifestations(), src, FALSE)
	. = ..()

#undef INVOKE_PSI_POWERS
