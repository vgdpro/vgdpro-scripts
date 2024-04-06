--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	VgD.CardTrigger(c,cm.operation)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	if g then
		Duel.HintSelection(g)
		vgf.AtkUp(c,g,100000000,nil)
	end
end