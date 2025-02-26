local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.BlitzOrder(c,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.cost.SoulBlast(5)(e,tp,eg,ep,ev,re,r,rp,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_CIRCLE,0,1,1,nil)
	local e1=vgf.AtkUp(c,g,15000)
	vgf.effect.Reset(c,e1,EVENT_BATTLED)
end