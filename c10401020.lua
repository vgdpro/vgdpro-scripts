local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.CannotBeTarget(c,m,LOCATION_R_CIRCLE)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_HITTING,cm.op,nil,vgf.con.IsR)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	vgf.CounterCharge(1)(e,tp,eg,ep,ev,re,r,rp)
	vgf.op.SoulCharge(1)(e,tp,eg,ep,ev,re,r,rp)
end