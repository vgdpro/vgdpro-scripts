local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.SpellActivate(c,m,cm.op,vgf.CostAnd(vgf.DamageCost(1),vgf.DisCardCost(1)))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	vgf.OverlayFill(3)(e,tp,eg,ep,ev,re,r,rp)
	if vgf.GetVMonster(tp):GetOverlayCount()>=10 then
		vgf.SearchCard(LOCATION_HAND,LOCATION_OVERLAY,nil,1)(e,tp,eg,ep,ev,re,r,rp)
	end
end