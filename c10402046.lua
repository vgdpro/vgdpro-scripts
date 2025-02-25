local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.CostAnd(vgf.DamageCost(1),vgf.LeaveFieldCost(vgf.RMonsterFilter,1,1,c)))
	vgd.GlobalCheckEffect(c,m,EVENT_TO_GRAVE,cm.chkcon)
	vgd.AbilityContChangeAttack(c,m,LOCATION_R_CIRCLE,EFFECT_TYPE_SINGLE,5000,cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_RMONSTER,e,tp,nil,tp,0,LOCATION_V_CIRCLE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	vgd.TriggerCountUp(c, m, 1, nil, RESET_PHASE+PHASE_END)
end
function cm.checkfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.chkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.checkfilter,1,nil,Duel.GetTurnPlayer())
end
function cm.con(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,m)>0
end