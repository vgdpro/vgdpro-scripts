local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.op,nil,cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>0 and vgf.RMonsterCondition(e)
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_SUPPORT)>0 and c:IsCode(10000001)
end