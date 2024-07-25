local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.SpellActivate(c,m,cm.op,vgf.DamageCost(1))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	vgf.AtkUp(c,g,5000)
end
function cm.filter(c)
	return c:IsLevelBelow(2) and vgf.RMonsterFilter(c)
end