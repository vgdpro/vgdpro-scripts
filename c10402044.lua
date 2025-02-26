local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.cost.SoulBlast(1),cm.con)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_MOVE,vgf.CounterCharge(1),vgf.cost.CounterBlast(1),cm.con,nil,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        vgf.AtkUp(c,c,10000,nil)
    end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.RideOnRCircle(e) and vgf.GetVMonster(tp):IsCode(10401008)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.ConfirmCards(tp,g)
	Duel.DisableShuffleCheck()
	Duel.Hint(HINT_SELECTMSG,tp,vgf.Stringid(m,0))
	local sg=g:Select(tp,0,2,nil)
	if #sg>0 then
		for tc in vgf.Next(sg) do
			Duel.MoveSequence(tc,SEQ_DECKTOP)
		end
		Duel.SortDecktop(tp,tp,#sg)
		g:Sub(sg)
	end
	if #g>1 then
		for tc in vgf.Next(g) do
			Duel.MoveSequence(tc,SEQ_DECKTOP)
		end
		Duel.SortDecktop(tp,tp,#g)
		for i=1,#g do
			local dg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end