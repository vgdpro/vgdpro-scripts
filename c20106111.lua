local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_R_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_CUSTOM+EVENT_SUPPORT,cm.operation)
end
function cm.filter(c)
	return c:IsFaceup()
end
-- 计数爆发1，能量爆发2
cm.cost=vgf.cost.And(vgf.cost.CounterBlast(1),vgf.cost.EnergyBlast(2))
-- 选择你的3个单位
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_RMONSTER,e,tp,cm.filter,tp,LOCATION_R_CIRCLE,0,3,3,nil)
	if g:GetClassCount(Card.GetCode)==3 and cm.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,vgf.Stringid(m,0)) then
		cm.cost(e,tp,eg,ep,ev,re,r,rp,1)
		-- 抽1张卡，这次战斗中，这个单位的力量+5000
		Duel.Draw(tp,1,REASON_EFFECT)
		local c=e:GetHandler()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			vgf.effect.Reset(c,vgf.AtkUp(c,c,5000),EVENT_BATTLED)
		end
	end
end