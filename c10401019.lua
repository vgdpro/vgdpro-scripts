local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AdditionalEffect(c,m,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.GetMatchingGroup(vgf.filter.Front,tp,LOCATION_CIRCLE,0,nil)
	vgf.AtkUp(c,g,"DOUBLE")
	vgf.StarUp(c,g,"DOUBLE")
end