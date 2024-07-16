local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.GlobalCheckEffect(c,m,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,EVENT_CHANGE_POS,cm.checkcon,cm.checkop)
	vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,5000,cm.con)
	vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,1,cm.con1,nil,nil,EFFECT_UPDATE_LSCALE)
	vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,1,cm.con1,nil,nil,EFFECT_UPDATE_RSCALE)
	vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.op,vgf.DamageCost(1))
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsContains(e:GetHandler())
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,FLAG_CONDITION)
	return VgF.GetValueType(ct)=="number" and ct==10102001
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0 and cm.con(e,tp,eg,ep,ev,re,r,rp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEONFIELD,e,tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end