extends Node

var inv = {}

var plr

func plrstantiate(playr):
	plr = playr

func eq_arm(arm):
	if arm.type == "helm":
		plr.helm = arm
	else:
		plr.chest = arm
	plr.armorstantiate()
	var scrip = arm.power.new()
	scrip.plr = plr
	plr.add_child(scrip)

func add_to_inv(item, qty):
	inv[item] = inv.get(item, 0) + qty

func remove_from_inv(item, qty):
	if inv.has(item):	
		inv[item] -= qty
		if inv[item] <= 0:
			inv.erase(item)
