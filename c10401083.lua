local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 2000, cm.con)
end
function cm.con(e,c)
	local tp=e:GetHandlerPlayer()
	return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,1,nil) and Duel.GetAttacker()==e:GetHandler() and vgf.con.IsR(e)
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end