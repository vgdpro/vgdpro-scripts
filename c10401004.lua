local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.GlobalCheckEffect(c,m,EVENT_CHANGE_POS,cm.checkcon)
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, 1, EFFECT_UPDATE_CRITICAL, cm.con1)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_HITTING,cm.op,vgf.cost.CounterBlast(1))
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsContains(e:GetHandler())
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,FLAG_CONDITION)
	return vgf.GetValueType(ct)=="number" and ct==10102001
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0 and cm.con(e,tp,eg,ep,ev,re,r,rp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,vgf.filter.IsR,tp,0,LOCATION_CIRCLE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end