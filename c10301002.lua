local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,vgf.True,vgf.VMonsterCondition)
	vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,5000,cm.con)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_RTOHAND,e,tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	vgf.Sendto(LOCATION_HAND,g,nil,REASON_EFFECT)
end
function cm.filter(c)
	return vgf.RMonsterFilter(c)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler()) and Duel.GetAttacker()==e:GetHandler() and vgf.RMonsterCondition(e)
end
function cm.cfilter(c,mc)
	return vgf.GetColumnGroup(c):IsContains(mc) and c:IsControler(mc:GetControler()) and c:GetFlagEffect(FLAG_SUPPORT)>0
end