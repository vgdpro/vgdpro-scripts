local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.CardToG(c,vgf.DamageCost(1),cm.op)
end
function m.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.DefUp(c,c,5000)
end