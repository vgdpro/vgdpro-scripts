local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AdditionalEffect(c,m,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.GetMatchingGroup(Card.IsFrontrow,tp,LOCATION_CIRCLE,0,nil)
	vgf.AtkUp(c,g,"DOUBLE")
	VgF.CriticalUp(c,g,"DOUBLE")
end