-- 毫无阴霾之心 米娅耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）
	-- 【自】：这个单位登场到R时，通过【费用】[计数爆发1，灵魂爆发1]，选择你的弃牌区中的1张力量8000的卡，加入手牌。
	vgd.AbilityAuto(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DROP,cm.filter),vgf.CostAnd(vgf.DamageCost(1),vgf.OverlayCost(1)),cm.con)
end

function cm.filter(c)
	return c:GetAttack()==8000
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RSummonCondition(e) and vgf.WhiteWing(e)
end