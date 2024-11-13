local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,vgf.RSummonCondition)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetFlagEffectLabel(tp,FLAG_SPELL_COUNT_LIMIT)
    if vgf.GetValueType(ct)~="number" then Duel.RegisterFlagEffect(tp,FLAG_SPELL_COUNT_LIMIT,RESET_PHASE+PHASE_END,0,1,2)
	else Duel.RegisterFlagEffect(tp,FLAG_SPELL_COUNT_LIMIT,RESET_PHASE+PHASE_END,0,1,ct+1) end
end