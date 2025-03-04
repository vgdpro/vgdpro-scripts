local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)
end
function cm.con(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return vgf.con.IsR(e) and vgf.IsExistingMatchingCard(Card.IsRearguard,tp,LOCATION_CIRCLE,0,4,c)
end