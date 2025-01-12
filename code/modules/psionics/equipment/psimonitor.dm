// [SIERRA-REMOVE] - PSIONICS - (Перемещено в /mods/psionics)
/*
/obj/machinery/psi_monitor
	name = "psionic implant monitor"
	icon = 'icons/obj/machines/research/psimeter.dmi'
	icon_state = "meter_on"
	use_power = POWER_USE_ACTIVE
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	req_access = list(list(access_psychiatrist, access_captain, access_cmo, access_hos))

	var/list/psi_violations = list()
	var/show_violations = FALSE
	var/authorized

/obj/machinery/psi_monitor/New()
	SSpsi.psi_monitors += src
	..()

/obj/machinery/psi_monitor/emag_act(remaining_charges, mob/user)
	if(!emagged)
		emagged = TRUE
		remaining_charges--
		req_access.Cut()
		to_chat(user, SPAN_NOTICE("You short out the access protocols."))
		return TRUE
	return FALSE

/obj/machinery/psi_monitor/Topic(href, href_list)

	. = ..()
	if(!.)

		if(href_list["login"])

			var/obj/item/card/id/ID = usr.GetIdCard()
			if(!ID || !allowed(usr))
				to_chat(usr, SPAN_WARNING("Access denied."))
			else
				authorized = "[ID.registered_name] ([ID.assignment])"
			. = 1

		else if(href_list["logout"])
			authorized = FALSE
			. = 1

		else if(href_list["show_violations"])
			show_violations = (href_list["show_violations"] == "1")
			. = 1

		else  if(href_list["remove_violation"])
			var/remove_ind = text2num(href_list["remove_violation"])
			if(remove_ind > 0 && remove_ind <= length(psi_violations))
				psi_violations.Cut(remove_ind, remove_ind++)
				. = 1

		else if(href_list["change_mode"])
			var/obj/item/implant/psi_control/implant = locate(href_list["change_mode"])
			if(implant.imp_in && !implant.malfunction)
				var/choice = input("Select a new implant mode.", "Psi Dampener") as null|anything in list(PSI_IMPLANT_AUTOMATIC, PSI_IMPLANT_SHOCK, PSI_IMPLANT_WARN, PSI_IMPLANT_LOG, PSI_IMPLANT_DISABLED)
				if(choice && implant && implant.imp_in && !implant.malfunction)
					implant.psi_mode = choice
					implant.update_functionality()
					. = 1

		if(. && usr)
			interact(usr)

/obj/machinery/psi_monitor/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/psi_monitor/interact(mob/user)

	var/list/dat = list()
	dat += "<h1>Psi Dampener Monitor</h1>"
	if(authorized)
		dat += "<b>[authorized]</b> <a href='?src=\ref[src];logout=1'>Logout</a>"
	else
		dat += "<a href='?src=\ref[src];login=1'>Login</a>"

	dat += "<h2>Active Psionic Dampeners</h2><hr>"
	dat += "<center><table>"
	dat += "<tr><td><b>Operant</b></td><td><b>System load</b></td><td><b>Mode</b></td></tr>"
	for(var/thing in SSpsi.psi_dampeners)
		var/obj/item/implant/psi_control/implant = thing
		if(!implant.imp_in)
			continue
		dat += "<tr><td>[implant.imp_in.name]</td>"
		if(implant.malfunction)
			dat += "<td>ERROR</td><td>ERROR</td>"
		else
			dat += "<td>[implant.overload]%</td><td>[authorized ? "<a href='?src=\ref[src];change_mode=\ref[implant]'>[implant.psi_mode]</a>" : "[implant.psi_mode]"]</td>"
		dat += "</tr>"
	dat += "</table><hr></center>"

	if(show_violations)
		dat += "<h2>Psionic Control Violations <a href='?src=\ref[src];show_violations=0'>-</a></h2><hr><center><table>"
		if(length(psi_violations))
			for(var/i =  1 to length(psi_violations))
				var/entry = psi_violations[i]
				dat += "<tr><td><br>[entry]</td><td>[authorized ? "<a href='?src=\ref[src];remove_violation=[i]'>Remove</a>" : ""]</td></tr>"
		else
			dat += "<tr><td colspan = 2>None reported.</td></tr>"
		dat += "</table></center><hr>"
	else
		dat += "<h2>Psionic Control Violations <a href='?src=\ref[src];show_violations=1'>+</a></h2><hr>"

	var/datum/browser/popup = new(user, "psi_monitor_\ref[src]", "Psi-Monitor")
	popup.set_content(jointext(dat,null))
	popup.open()


/obj/machinery/psi_monitor/proc/report_failure(obj/item/implant/psi_control/implant)
	psi_violations += SPAN_COLOR("#ff0000", "Critical system failure - [implant.imp_in.name].")

/obj/machinery/psi_monitor/proc/report_violation(obj/item/implant/psi_control/implant, stress)
	psi_violations += "Sigma [round(stress/10)] event - [implant.imp_in.name]."
*/
// [/SIERRA-REMOVE] - PSIONICS - (Перемещено в /mods/psionics)
