local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.BeRidedByCard(c,m,10401008,cm.op)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op2,nil,vgf.RSummonCondition)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,3)
	local ct=g:GetCount()
	if ct>0 then
		Duel.ConfirmCards(tp,g)
		if ct>1 then Duel.SortDecktop(tp,tp,ct) end
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,1)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.DisableShuffleCheck()
		if Duel.SelectOption(tp,1195,1196)==1 then
			Duel.MoveSequence(g:GetFirst(),1)
			if c:IsRelateToEffect(e) and c:IsFaceup() then
				vgf.AtkUp(c,c,2000)
			end
		end
	end
end