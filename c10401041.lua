local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_DISCARD,cm.op,vgf.cost.CounterBlast(1),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and vgf.IsCanBeCalled(c,e,tp) then
		vgf.Sendto(LOCATION_CIRCLE,c,0,tp)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,1,nil)
end
function cm.filter(c)
	return c:IsType(TYPE_SET) and c:IsFaceup()
end