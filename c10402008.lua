local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_CIRCLE,LOCATION_SOUL,Card.IsSetCard,1,1,0x78),nil,vgf.con.RideOnVCircle)
	vgd.action.AbilityAct(c,m,LOCATION_CIRCLE,cm.op,vgf.cost.And(vgf.cost.CounterBlast(1),vgf.cost.Retire(Card.IsRearguard,3,3)),nil,nil,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,Card.IsRearguard,tp,0,LOCATION_CIRCLE,2,2,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	vgf.AtkUp(c,c,10000)
	vgf.StarUp(c,c,1)
end