local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.SetOrder(c,vgf.cost.SoulBlast(1))
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_MOVE,cm.operation,nil,cm.condition)
	vgd.DarkNight(c,m)--黑夜
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_ORDER)
end