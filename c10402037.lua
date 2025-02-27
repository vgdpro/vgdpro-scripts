local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.Order(c,m,cm.op,vgf.cost.CounterBlast(1))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_EFFECT)
	vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_CIRCLE,LOCATION_HAND,vgf.IsCanBeCalled,1,1,e,tp)
	local ct=Duel.GetFlagEffectLabel(tp,FLAG_CONDITION)
	if vgf.GetValueType(ct)=="number" and ct==10102001 then
		Duel.BreakEffect()
		local g=vgf.GetMatchingGroup(vgf.filter.Front,tp,LOCATION_CIRCLE,0,nil)
		vgf.AtkUp(c,g,10000,nil)
	end
end