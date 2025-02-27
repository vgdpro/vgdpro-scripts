local cm,m,o=GetID()
--幽灵追猎
--选择你的1个单位，这次战斗中，力量+5000。选择你的1张没有正在被攻击的后防者，返回手牌
function cm.initial_effect(c)
	vgd.action.BlitzOrder(c,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_CIRCLE,0,1,1,nil)
	vgf.AtkUp(c,g,5000,EVENT_BATTLED)
	local sg=vgf.SelectMatchingCard(HINTMSG_RTOHAND,vgf.filter.IsR,e,tp,vgf.filter.IsR,tp,LOCATION_CIRCLE,0,1,1,Duel.GetAttackTarget())
	vgf.Sendto(LOCATION_HAND,sg,REASON_EFFECT)
end