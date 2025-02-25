local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c, m,nil,nil,EVENT_TO_G_CIRCLE,cm.op,vgf.cost.CounterBlast(1))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.DefUp(c,c,5000)
end