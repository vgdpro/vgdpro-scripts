local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_DISCARD,cm.op,vgf.True,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.Sendto(LOCATION_SOUL,c)
	end
end