local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.SetOrder(c)
	vgd.action.AbilityAct(c,m,LOCATION_ORDER,cm.operation,vgf.cost.CounterBlast(2),nil,nil,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_VMONSTER,e,tp,Card.IsV,tp,LOCATION_CIRCLE,0,1,1,nil)
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_FIELD, EFFECT_UPDATE_ATTACK, 5000, nil, cm.tg, LOCATION_CIRCLE, 0, RESET_PHASE+PHASE_END, g:GetFirst())
end
function cm.tg(e,c)
	return c:IsRearguard()end