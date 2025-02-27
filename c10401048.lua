local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_MOVE,vgf.CounterCharge(1),vgf.cost.SoulBlast(2),cm.con,nil,1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and eg:IsExists(cm.filter,1,nil,tp) and Duel.GetTurnPlayer()==tp and Duel.GetAttackTarget()
end
function cm.filter(c,tp)
	return c:IsTrigger(TRIGGER_CARDS) and c:IsLocation(LOCATION_TRIGGER) and c:IsControler(tp)
end