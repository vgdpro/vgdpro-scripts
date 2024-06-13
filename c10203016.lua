local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_BATTLED,cm.operation,cm.cost,cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RMonsterFilter(c) and vgf.VMonsterFilter(Duel.GetAttackTarget()) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,4,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil,nil):GetFirst():GetOverlayCount()>=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local g=Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup():Select(tp,1,1,nil)
	g:AddCard(e:GetHandler())
	vgf.Sendto(LOCATION_DROP,g,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,3)
    Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,cm.filter,0,1,nil)
	if sg:GetCount()>0 then
		vgf.Sendto(LOCATION_HAND,sg,nil,REASON_EFFECT)
	else
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.filter(c)
	return c:IsLevelAbove(3) and c:IsType(TYPE_MONSTER)
end