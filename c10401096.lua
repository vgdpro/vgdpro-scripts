local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_MOVE,cm.op,vgf.cost.CounterBlast(2),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and eg:IsExists(cm.filter,1,nil,tp) and Duel.GetTurnPlayer()==tp and Duel.GetAttackTarget()
end
function cm.filter(c,tp)
	return c:IsTrigger(TRIGGER_CARDS) and c:IsLocation(LOCATION_TRIGGER) and c:IsControler(tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEUP_ATTACK)
		vgf.AtkUp(c,c,5000)
	end
end