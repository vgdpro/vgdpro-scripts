local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.BeRidedByCard(c,m,10401046,cm.operation,vgf.cost.CounterBlast(1))
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_MOVE,cm.op,vgf.cost.CounterBlast(1),cm.con,nil,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RMonsterCondition(e) and eg:IsExists(cm.filter,1,nil,tp) and Duel.GetTurnPlayer()==tp and Duel.GetAttackTarget()
end
function cm.filter(c,tp)
	return c:IsTrigger(TRIGGER_CARDS) and c:IsLocation(LOCATION_TRIGGER) and c:IsControler(tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_TODECK,e,tp,cm.filter2,tp,0,LOCATION_CIRCLE,1,1,nil)
	vgf.Sendto(LOCATION_DECK,g,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function cm.filter2(c)
	return vgf.FrontFilter(c) and vgf.RMonsterFilter(c)
end