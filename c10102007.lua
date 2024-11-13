local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.CardToG(c,m,cm.op,vgf.DamageCost(1))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.DefUp(c,c,5000)
end