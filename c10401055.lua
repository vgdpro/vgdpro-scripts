local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.Order(c,m,cm.op,vgf.OverlayCost(1))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	vgf.CardsFromTo(REASON_EFFECT,LOCATION_MZONE,LOCATION_DROP,cm.filter,1,1)(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOperatedGroup()
	vgf.AtkUp(c,g,10000)
end
function cm.filter(c)
	local tp=c:GetControl()
	local lv=vgf.GetVMonster(tp):GetLevel()
	return c:IsLevelBelow(lv)
end