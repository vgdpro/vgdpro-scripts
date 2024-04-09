--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.SpellActivate(c,m,cm.operation)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	VgF.AtkUp(c,g,5000,nil)
	vgf.SearchCard(LOCATION_DROP,cm.filter)
end
function cm.filter(c)
	return c:IsCode(10101006)
end