local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 2000, con)
	vgd.AbilityCont(c, m, LOCATION_G_CIRCLE, EFFECT_TYPE_SINGLE, 5000, EFFECT_UPDATE_DEFENSE, con)
end
function cm.con(e,c)
	local tp=e:GetHandlerPlayer()
	return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,1,nil)
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end