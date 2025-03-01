local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_R_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_CUSTOM+EVENT_SUPPORT,cm.operation,cm.cost,cm.condition)
end
-- 对手的后防者在2张以下的话
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not vgf.IsExistingMatchingCard(nil,tp,0,LOCATION_R_CIRCLE,3,nil)
end
-- 计数爆发1，能量爆发2
cm.cost=vgf.cost.And(vgf.cost.CounterBlast(1),vgf.cost.EnergyBlast(2))
-- 抽1张卡，这次战斗中，这个单位的力量+5000
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		vgf.AtkUp(c,c,5000,EVENT_BATTLED)
	end
end