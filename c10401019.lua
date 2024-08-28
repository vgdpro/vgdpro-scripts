local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgf.AddEffectWhenTrigger(c,m,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.GetMatchingGroup(vgf.FrontFilter,tp,LOCATION_MZONE,0,nil)
	vgf.AtkUp(c,g,"DOUBLE")
	vgf.StarUp(c,g,"DOUBLE")
end