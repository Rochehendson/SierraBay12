/datum/game_mode/changeling
	name = "Psi-Vampire"
	round_description = "Будьте начеку, ведь психонетический-вампир незаметно высасывает ментальную энергию людей и может внезапно перейти в агрессивную фазу охоты."
	extended_round_description = "Слабоизученное явление психонетиков класса Омикрон как чума, распространяется."

	config_tag = "vampire"
	antag_tags = list("vampire")

	round_autoantag = TRUE
	antag_scaling_coeff = 7
	required_players = 2


GLOBAL_TYPED_NEW(vampires, /datum/antagonist/vampire)
/datum/antagonist/vampire
	id = "vampire"
	role_text = "Vampire"
	role_text_plural = "Vampires"
	feedback_tag = "vampire_objective"
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/submap)
	restricted_jobs = list(/datum/job/officer, /datum/job/warden, /datum/job/captain, /datum/job/hos)
	welcome_text = "Набирай чужую психосферу, чтобы не исчезнуть из существования."
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	skill_setter = /datum/antag_skill_setter/station

	faction = "vampire"
