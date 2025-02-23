local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.BeRidedByCard(c,m,10401027,vgf.OverlayFill(1))
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_TO_GRAVE,cm.op,vgf.CostAnd(vgf.DamageCost(1),vgf.LeaveFieldCost()),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end
function cm.filter(c,tp)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(1-tp)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp) and Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==tp
end