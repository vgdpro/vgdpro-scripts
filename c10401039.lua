local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_MOVE,cm.op,nil,cm.con)
	vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,5000,cm.con2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	vgf.AtkUp(c,g,5000)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.VMonsterCondition(e) and eg:IsExists(cm.filter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function cm.filter(c,tp)
	return c:IsSetCard(0x5040) and c:IsLocation(LOCATION_ORDER) and c:IsControler(tp)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RMonsterCondition(e) and Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_DEEP_NIGHT) and Duel.GetTurnPlayer()==tp
end