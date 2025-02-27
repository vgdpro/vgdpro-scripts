local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_CIRCLE,LOCATION_DROP,cm.filter),vgf.cost.CounterBlast(1),vgf.con.RideOnRCircle)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,vgf.cost.CounterBlast(1),vgf.con.IsR)
end
function cm.filter(c)
	return c:IsLevel(0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,Card.IsLevel,tp,LOCATION_CIRCLE,0,1,1,nil,0)
	vgf.AtkUp(c,g,5000)
end