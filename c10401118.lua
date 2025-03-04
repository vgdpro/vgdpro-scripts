local cm,m,o=GetID()
--泪流之恶意
--通过【费用】[将你的2张后防者退场]施放！
--抽1张卡，将这张卡放置到灵魂里，计数回充1。
function cm.initial_effect(c)
	vgd.action.Order(c,m,cm.op,vgf.cost.Retire(Card.IsRearguard,2,2))
	VgF.AddAlchemagic(m,"LOCATION_CIRCLE","LOCATION_DROP",2,2,Card.IsR)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_TRIGGER)
    vgf.Sendto(LOCATION_SOUL,c)
	vgf.CounterCharge(1)
end