local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_SPSUMMON_SUCCESS,cm.op,nil,cm.con2)
end
function cm.con(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and vgf.con.IsR(e) and vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,2,nil)
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.con.IsR(e) and vgf.filter.Front(c) and eg:IsExists(cm.filter2,1,nil,tp)
end
function cm.filter2(c,tp)
	return c:IsPreviousLocation(LOCATION_ORDER) and c:IsPreviousControler(tp) and c:IsControler(1-tp) and vgf.filter.RideOnRCircle(c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(cm.filter2,nil,tp)
	vgf.AtkUp(c,g,-5000)
end