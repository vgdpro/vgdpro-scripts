local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.Order(c,m,cm.op,cm.cost)
	vgf.AddAlchemagicFilter(c,m,cm.filter)
	vgf.AddAlchemagicCountMin(c,m,1)
	vgf.AddAlchemagicCountMax(c,m,1)
	vgf.AddAlchemagicFrom(c,m,"LOCATION_HAND")
	vgf.AddAlchemagicTo(c,m,"LOCATION_DROP")

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
	vgf.Sendto(LOCATION_DROP,g,REASON_COST+REASON_DISCARD)
end
function cm.filter(c)
	return c:IsSetCard(0x201)
end