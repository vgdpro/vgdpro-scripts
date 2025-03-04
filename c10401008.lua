local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_MOVE,cm.op,nil,cm.con)
	vgd.action.AbilityAct(c,m,LOCATION_CIRCLE,cm.op1,cm.cost1,cm.con1,nil,1)
	vgd.action.GlobalCheckEffect(c,m,EVENT_SPSUMMON_SUCCESS,cm.checkcon)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsV(e) and eg:IsExists(cm.filter,1,nil,tp) and Duel.GetTurnPlayer()==tp and Duel.GetAttackTarget()
end
function cm.filter(c,tp)
	return c:IsTrigger(TRIGGER_CARDS) and c:IsLocation(LOCATION_TRIGGER) and c:IsControler(tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_RMONSTER,e,tp,Card.IsRearguard,tp,LOCATION_CIRCLE,0,1,1,nil)
	vgf.AtkUp(c,g,10000)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_SELFRIDE)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0 and vgf.con.IsV(e)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.cost.SoulBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.cost.SoulBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_TODECK,e,tp,Card.IsTrigger,tp,LOCATION_HAND,0,0,1,nil,TRIGGER_ADVANCE+TRIGGER_CRITICAL_STRIKE)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		vgf.Sendto(LOCATION_DECK,g,tp,SEQ_DECKTOP,REASON_EFFECT)
	end
	vgd.action.DriveUp(c,m,1,nil,RESET_PHASE+PHASE_END)
end