-- 毫无阴霾之心 米娅耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）
	-- 【自】：这个单位登场到R时，通过【费用】[计数爆发1，灵魂爆发1]，选择你的弃牌区中的1张力量8000的卡，加入手牌。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,cm.cost,cm.con)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	VgF.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DROP,cm.filter,1,1)(e,tp,eg,ep,ev,re,r,rp)
end

function cm.filter(c)
	return c:GetAttack()==8000
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RSummonCondition(e) and vgf.WhiteWing(e)
end