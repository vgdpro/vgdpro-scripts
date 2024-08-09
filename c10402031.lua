local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.SpellActivate(c,m,cm.op,cm.cost)
	cm.cos_from={LOCATION_HAND}
	cm.cos_to={LOCATION_DROP}
	cm.cos_val={1}
	cm.cos_val_max={1}
	cm.cos_filter={cm.filter}
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil)
	end
	local g=vgf.SelectMatchingCard(HINTMSG_TODROP,tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0x201)
end