local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,cm.op,cm.cost,cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) end
	local g=vgf.SelectMatchingCard(HINTMSG_OVERLAY,e,tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil)
	vgf.Sendto(LOCATION_OVERLAY,g)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(FLAG_SUPPORT)>0 and vgf.VMonsterFilter(Duel.GetAttackTarget)
end
function cm.filter(c)
	return c:IsLevelBelow(3)
end