local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,vgf.DamageFill(1),vgf.LeaveFieldCost(10000001),cm.con1)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,vgf.DamageFill(1),vgf.LeaveFieldCost(10000001),cm.con2)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_DEEP_NIGHT)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return cm.con1(e,tp,eg,ep,ev,re,r,rp) and eg:GetFirst()==e:GetHandler()
end