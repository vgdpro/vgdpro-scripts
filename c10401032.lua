--幻想的奇术师 卡提斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
--【自】：这个单位登场到R时，你有「重力的支配者 磁力重压」的先导者的话，灵魂填充2。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.OverlayFill(2),nil,cm.condition)
--【起】【R】：你的灵魂在10张以上的话，通过【费用】[计数爆发2]，这个回合中，将当前存在于前列的你所有的单位的力量+5000。
vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.operation,vgf.DamageCost(2),cm.condition1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not(c:IsSummonType(SUMMON_TYPE_RIDE) or c:IsSummonType(SUMMON_TYPE_SELFRIDE)) and vgf.GetVMonster(tp):IsCode(10401003)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RMonsterCondition(e) and vgf.GetVMonster(tp):GetOverlayCount()>=10
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetMatchingGroup(vgf.IsSequence,tp,LOCATION_MZONE,0,nil,0,4,5)
    vgf.AtkUp(c,g2,10000,nil)
end