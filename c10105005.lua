local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_HITTING,cm.operation,nil,cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.filter.IsR(c) and Card.IsSequence(Duel.GetAttackTarget(),5)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not vgf.CheckPrison(tp) then return end
	local g=vgf.SelectMatchingCard(HINTMSG_IMPRISON,e,tp,vgf.filter.IsR,tp,0,LOCATION_CIRCLE,0,2,nil)
	vgf.SendtoPrison(g,tp)
end