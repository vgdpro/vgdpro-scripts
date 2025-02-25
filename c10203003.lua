local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.BeRidedByCard(c,m,10203002,cm.operation,vgf.OverlayCost(1))
	vgd.AbilityCont(c, m, LOCATION_MZONE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 2000, cm.con)
end
function cm.con(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,3)
    Duel.ConfirmCards(tp,g)
	Duel.DisableShuffleCheck()
	local off=1
	local ops={}
	local a=g:IsExists(cm.filter,1,nil)
	local b=g:IsExists(cm.filter1,1,nil,e,tp)
	if a then
		ops[off]=1190
		off=off+1
	end
	if b then
		ops[off]=1152
		off=off+1
	end
	ops[off]=1194
	local sel=Duel.SelectOption(tp,table.unpack(ops))
	if sel==0 and a then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,cm.filter,1,1,nil)
		Duel.DisableShuffleCheck()
		vgf.Sendto(LOCATION_HAND,sg,nil,REASON_EFFECT)
		g:RemoveCard(vgf.ReturnCard(sg))
	elseif (sel==1 and a and b) or (sel==0 and not a and b) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
		local sg=g:FilterSelect(tp,cm.filter1,1,1,nil,e,tp)
		vgf.Sendto(LOCATION_MZONE,sg,0,tp)
		g:RemoveCard(vgf.ReturnCard(sg))
	end
	if #g>1 then
		Duel.SortDecktop(tp,tp,#g)
		for i=1,#g do
			local dg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function cm.filter(c)
	return c:IsSetCard(0x77)
end
function cm.filter1(c,e,tp)
	return c:IsLevelBelow(2) and vgf.IsCanBeCalled(c,e,tp)
end