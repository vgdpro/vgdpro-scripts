local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.cost.And(vgf.cost.CounterBlast(1),vgf.cost.Retire(Card.IsR,1,1,c)))
	vgd.action.GlobalCheckEffect(c,m,EVENT_TO_GRAVE,cm.chkcon)
	vgd.action.AbilityCont(c, m, LOCATION_R_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_RMONSTER,e,tp,nil,tp,0,LOCATION_V_CIRCLE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	vgd.action.DriveUp(c, m, 1, nil, RESET_PHASE+PHASE_END)
end
function cm.checkfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_CIRCLE)
end
function cm.chkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.checkfilter,1,nil,Duel.GetTurnPlayer())
end
function cm.con(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,m)>0
end