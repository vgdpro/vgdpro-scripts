local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAutoRided(c,m,10401027,vgf.op.SoulCharge(1))
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_TO_GRAVE,cm.op,vgf.cost.And(vgf.cost.CounterBlast(1),vgf.cost.Retire()),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,Card.IsRearguard,tp,0,LOCATION_CIRCLE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end
function cm.filter(c,tp)
    return c:IsPreviousLocation(LOCATION_CIRCLE) and c:IsPreviousControler(1-tp)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp) and Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==tp
end