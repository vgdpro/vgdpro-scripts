local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityCont(c, m, LOCATION_G_CIRCLE, EFFECT_TYPE_SINGLE, 5000, EFFECT_UPDATE_DEFENSE, cm.con)
end
function cm.con(e)
	local c = vgf.GetVMonster(1-e:GetHandlerPlayer())
	return c and c:IsLevelAbove(3)
end