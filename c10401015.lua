local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.op.SoulCharge(1),nil,vgf.con.RideOnRCircle)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,cm.op,vgf.cost.SoulBlast(3),vgf.con.IsR,nil,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end