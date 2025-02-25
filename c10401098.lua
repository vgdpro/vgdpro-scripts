local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_MOVE,cm.op,vgf.OverlayCost(1),cm.con,nil,1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RMonsterCondition(e) and eg:IsExists(cm.filter,1,nil,tp) and Duel.GetTurnPlayer()==tp and Duel.GetAttackTarget()
end
function cm.filter(c,tp)
	return c:IsRace(TRIGGER_CARDS) and c:IsLocation(LOCATION_TRIGGER) and c:IsControler(tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,5000)
	end
end