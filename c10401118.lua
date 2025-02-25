local cm,m,o=GetID()
--泪流之恶意
--通过【费用】[将你的2张后防者退场]施放！
--抽1张卡，将这张卡放置到灵魂里，计数回充1。
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.Order(c,m,cm.op,vgf.cost.Retire(vgf.RMonsterFilter,2,2))
	vgf.AddAlchemagicFrom(c,m,"LOCATION_CIRCLE")
	vgf.AddAlchemagicTo(c,m,"LOCATION_DROP")
	vgf.AddAlchemagicFilter(c,m,vgf.RMonsterFilter)
	vgf.AddAlchemagicCountMin(c,m,2)
	vgf.AddAlchemagicCountMax(c,m,2)
	
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_TRIGGER)
    vgf.Sendto(LOCATION_SOUL,c)
	vgf.CounterCharge(1)
end