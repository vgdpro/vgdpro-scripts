--鞭挞的少女 伊蕾尼娅
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【自】：这个单位从手牌登场到R时，通过【费用】[计数爆发1，灵魂爆发1]，选择你的弃牌区中的1张等级2以下的卡，CALL到R上，这个回合中，那个单位的力量+5000。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,cm.cost,cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RSummonCondition(e) and c:IsSummonLocation(LOCATION_HAND)
end
--效果二处理
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.CardsFromTo(REASON_EFFECT,LOCATION_MZONE,LOCATION_DROP,cm.filter2)(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOperatedGroup()
	vgf.AtkUp(c,g,5000)
end
--效果二召唤等级筛选
function cm.filter2(c)
	return c:IsLevelBelow(2)
end
--计数爆发1，灵魂爆发1
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end
