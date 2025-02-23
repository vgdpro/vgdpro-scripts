local cm,m,o=GetID()
--泪流之恶意
--通过【费用】[将你的2张后防者退场]施放！
--抽1张卡，将这张卡放置到灵魂里，计数回充1。
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.SpellActivate(c,m,cm.op,vgf.LeaveFieldCost(vgf.RMonsterFilter,2,2))
	vgf.AddMixCostGroupFrom(c,m,"LOCATION_MZONE")
	vgf.AddMixCostGroupTo(c,m,"LOCATION_DROP")
	vgf.AddMixCostGroupFilter(c,m,vgf.RMonsterFilter)
	vgf.AddMixCostGroupCountMin(c,m,2)
	vgf.AddMixCostGroupCountMax(c,m,2)
	
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_TRIGGER)
    vgf.Sendto(LOCATION_OVERLAY,c)
	vgf.DamageFill(1)
end