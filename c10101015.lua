--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.SpellActivate(c,m,cm.operation,vgf.DamageCost(1))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	vgf.AtkUp(c,g,5000,nil)
	vgf.SearchCard(LOCATION_HAND,LOCATION_DROP,cm.filter)(e,tp,eg,ep,ev,re,r,rp)
end
function cm.filter(c)
	return c:IsCode(10101006)
end