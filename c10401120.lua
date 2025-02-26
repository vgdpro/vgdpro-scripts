local cm,m,o=GetID()
--被封闭的道路
function cm.initial_effect(c)
	--通过【费用】[计数爆发2]施放！
    --选择对手的1张先导者，这次战斗中，那个单位的☆-1。
	vgd.VgCard(c)
	vgd.Order(c,m,cm.operation,vgf.cost.CounterBlast(2))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_OPPO,e,tp,vgf.filter.IsV,tp,0,LOCATION_CIRCLE,1,1,nil)
	local e1=vgf.StarUp(c,g,-1,EVENT_BATTLED)
	vgf.effect.Reset(c,e1,EVENT_BATTLED)
end