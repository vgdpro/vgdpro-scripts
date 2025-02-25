local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.Order(c,m,cm.op,vgf.cost.And(vgf.cost.CounterBlast(1),vgf.cost.Discard(1)))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	vgf.op.SoulCharge(3)(e,tp,eg,ep,ev,re,r,rp)
	if vgf.GetVMonster(tp):GetOverlayCount()>=10 then
		vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_SOUL,nil,1)(e,tp,eg,ep,ev,re,r,rp)
	end
end