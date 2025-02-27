local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.CannotCallToGCircleWhenAttack(c, m, function (e,re,tp)
		return re:GetHandler():IsLocation(LOCATION_HAND)
	end)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_HITTING,cm.op,cm.cost,nil,nil,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEUP_ATTACK)
		vgd.DriveUp(c,m,-1,nil,RESET_PHASE+PHASE_END)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.cost.Discard(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.cost.Discard(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end