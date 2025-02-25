local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.Order(c,m,cm.op,vgf.OverlayCost(2))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,4)
	Duel.ConfirmCards(tp,4)
	local ct=bit.ReturnCount(vgf.GetAvailableLocation(tp))
	if chk>0 then
		if ct>2 then ct=2 end
	else
		if ct>1 then ct=1 end
	end
	if ct>0 then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
		local sg=g:FilterSelect(tp,vgf.IsCanBeCalled,0,ct,nil,e,tp)
		vgf.Sendto(LOCATION_CIRCLE,sg,0,tp)
		sg=Duel.GetOperatedGroup()
		vgf.AtkUp(c,sg,5000)
		g:Sub(sg)
	end
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end