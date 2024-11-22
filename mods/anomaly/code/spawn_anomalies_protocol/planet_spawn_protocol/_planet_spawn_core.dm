/obj/overmap/visitable/sector/exoplanet/build_level()
	generate_atmosphere()
	for (var/datum/exoplanet_theme/T in themes)
		T.adjust_atmosphere(src)
	if (atmosphere)
		//Set up gases for living things
		if (!length(breathgas))
			var/list/goodgases = atmosphere.gas.Copy()
			var/gasnum = min(rand(1,3), length(goodgases))
			for (var/i = 1 to gasnum)
				var/gas = pick(goodgases)
				breathgas[gas] = round(0.4*goodgases[gas], 0.1)
				goodgases -= gas
		if (!badgas)
			var/list/badgases = gas_data.gases.Copy()
			badgases -= atmosphere.gas
			badgas = pick(badgases)
	generate_flora()
	generate_map()
	generate_features()
	for (var/datum/exoplanet_theme/T in themes)
		T.after_map_generation(src)
	//Спавним аномалии
	if(can_spawn_anomalies)
		generate_anomalies()
	//Если у планеты есть погода - спавним погоду
	if(monitor_effect_type)
		generate_monitor_effects()
	generate_landing(2)
	update_biome()
	generate_daycycle()
	generate_planet_image()
	START_PROCESSING(SSobj, src)
