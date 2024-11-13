local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.SpellActivate(c,m,cm.op,cm.cost)
	VgF.AddMixCostGroupFilter(c,m,cm.filter)
	VgF.AddMixCostGroupCountMin(c,m,1)
	VgF.AddMixCostGroupCountMax(c,m,1)
	VgF.AddMixCostGroupFrom(c,m,"LOCATION_HAND")
	VgF.AddMixCostGroupTo(c,m,"LOCATION_DROP")

end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil)
	end
	local g=vgf.SelectMatchingCard(HINTMSG_TODROP,e,tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0x201)
end