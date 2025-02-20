local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,cm.cost,vgf.RSummonCondition)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.ChangePosDefence(e:GetHandler())(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.ChangePosDefence(e:GetHandler())(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,2)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOTOP)
		local sg=g:select(tp,1,1,nil)
		g:Sub(sg)
		if g:GetCount()>0 then
			Duel.MoveSequence(g:GetFirst(),1)
		end
	end
end