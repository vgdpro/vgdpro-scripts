local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,loc,EFFECT_TYPE_SINGLE,EVENT_DISCARD,cm.operation,vgf.True,cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_RIDE
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanBeCalled(e,tp) then
		vgf.Sendto(LOCATION_CIRCLE,c,0,tp)
	end
end