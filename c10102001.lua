local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_RIDE_START,cm.op,nil,cm.con)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op2,vgf.OverlayCost(5),cm.con2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,FLAG_CONDITION,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,m,vgf.Stringid(m,0))
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and vgf.VMonsterCondition(e)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.GetMatchingGroup(vgf.IsSequence,tp,LOCATION_MZONE,0,nil,0,4)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,FLAG_CONDITION)
	return VgF.GetValueType(ct)=="number" and ct==10102001 and vgf.VMonsterCondition(e)
end