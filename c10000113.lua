local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.CardToG(c,nil,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=vgf.SelectMatchingCard(HINTMSG_SELF,e,tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	if tg:GetCount()>0 then tg:GetFirst():RegisterFlagEffect(DefenseEntirelyFlag,RESET_EVENT+RESETS_STANDARD,0,1) end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		g=g:FilterSelect(tp,Card.IsDiscardable,1,1,nil,REASON_EFFECT)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end