--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgf.AddEffectWhenTrigger(c,m,cm.operation)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_CIRCLE,0,1,1,nil)
	vgf.AtkUp(c,g,100000000,nil)
end