local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,vgf.True,vgf.con.IsV)
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_RTOHAND,e,tp,cm.filter,tp,LOCATION_CIRCLE,0,1,1,nil)
	vgf.Sendto(LOCATION_HAND,g,nil,REASON_EFFECT)
end
function cm.filter(c)
	return vgf.filter.IsR(c)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_CIRCLE,0,1,nil,e:GetHandler()) and Duel.GetAttacker()==e:GetHandler() and vgf.con.IsR(e)
end
function cm.cfilter(c,mc)
	return vgf.GetColumnGroup(c):IsContains(mc) and c:IsControler(mc:GetControler()) and c:GetFlagEffect(FLAG_SUPPORT)>0
end