local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.Order(c,m,cm.op,vgf.CostAnd(vgf.CounterBlast(1),vgf.Discard(1)))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	vgf.SoulCharge(3)(e,tp,eg,ep,ev,re,r,rp)
	if vgf.GetVMonster(tp):GetOverlayCount()>=10 then
		vgf.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_SOUL,nil,1)(e,tp,eg,ep,ev,re,r,rp)
	end
end