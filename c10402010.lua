local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityCont(c, m, LOCATION_MZONE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)
	vgd.GlobalCheckEffect(c,m,EVENT_CHAINING,cm.checkcon)
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,nil,vgf.RSummonCondition)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0 and vgf.RMonsterCondition(e)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,m)
	if vgf.GetValueType(ct)=="number" then
		ct=ct+1
		Duel.ResetFlagEffect(tp,m)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1,ct)
	else Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1,1) end
end