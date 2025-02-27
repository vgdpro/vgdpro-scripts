local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_MOVE,cm.op,nil,cm.con)
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_CIRCLE,0,1,1,nil)
	vgf.AtkUp(c,g,5000)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsV(e) and eg:IsExists(cm.filter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function cm.filter(c,tp)
	return c:IsSetCard(0x5040) and c:IsLocation(LOCATION_ORDER) and c:IsControler(tp)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_ABYSSAL_DARK_NIGHT) and Duel.GetTurnPlayer()==tp
end