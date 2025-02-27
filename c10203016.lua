local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_BATTLED,cm.operation,vgf.cost.And(vgf.cost.SoulBlast(1),vgf.cost.Retire()),cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.filter.IsR(c) and vgf.filter.IsV(Duel.GetAttackTarget()) and vgf.IsExistingMatchingCard(nil,tp,LOCATION_CIRCLE+LOCATION_DROP,0,4,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,3)
    Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,cm.filter,0,1,nil,e,tp)
	if sg:GetCount()>0 then
		vgf.Sendto(LOCATION_HAND,sg,nil,REASON_EFFECT)
	else
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.filter(c,e,tp)
	return c:IsLevelAbove(2) and vgf.IsCanBeCalled(c,e,tp)
end