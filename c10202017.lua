--幽冥之朋友 黎恩
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【自】：这个单位登场到R时，查看你的牌堆顶的2张卡，选择1张卡，放置到灵魂里，其余的卡放置到牌堆底。
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,nil,cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return vgf.filter.IsR(e:GetHandler())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.ConfirmCards(tp,g)
	Duel.DisableShuffleCheck()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sc=g:FilterSelect(tp,Card.IsCanOverlay,1,1,nil):GetFirst()
	if sc then
		vgf.Sendto(LOCATION_SOUL,sc,vgf.GetVMonster(tp))
		g:RemoveCard(sc)
	end
	if #g>1 then
		Duel.SortDecktop(tp,tp,#g-1)
		for i=1,#g-1 do
			local dg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
		end
	elseif #g>0 then
		Duel.MoveSequence(g:GetFirst(),SEQ_DECKBOTTOM)
	end
end