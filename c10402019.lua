local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
    vgd.AbilityAct(c,m,LOCATION_MZONE,vgf.DamageFill(1),cm.cost,vgf.RMonsterCondition,nil,1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=vgf.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil)
	return vgf.Sendto(LOCATION_DROP,g,REASON_COST+REASON_DISCARD)
end
function cm.filter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end