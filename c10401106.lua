local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.SpellActivate(c,m,cm.op,cm.cost)
	VgF.AddMixCostGroupFrom(c,m,"LOCATION_OVERLAY")
	VgF.AddMixCostGroupTo(c,m,"LOCATION_DROP")
	VgF.AddMixCostGroupFilter(c,m,function (tc) return tc:IsLevel(3) end)
	VgF.AddMixCostGroupCountMin(c,m,1)
	VgF.AddMixCostGroupCountMax(c,m,1)
end
function cm.filter(c,p)
	return c:IsControler(p) and vgf.RMonsterFilter(c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_OPPO,e,tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()==0 then return end
	local sg=vgf.GetColumnGroup(g:GetFirst()):Filter(cm.filter,nil,1-tp)
	if sg:GetCount()>0 then g:Sub(sg) end
	vgf.Sendto(LOCATION_DECK,g,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if #og>1 then
		Duel.SortDecktop(1-tp,1-tp,#og)
		for i=1,#og do
			local dg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil,nil):GetFirst():GetOverlayGroup():IsExists(Card.IsLevel,1,nil,3)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local g=vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup():FilterSelect(tp,Card.IsLevel,1,1,nil,3)
	vgf.Sendto(LOCATION_DROP,g,REASON_COST)
end