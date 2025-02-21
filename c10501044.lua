-- 放学后迷你演出 卡缇娜
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【自】：这个单位登场到R时，通过【费用】[灵魂爆发1，将手牌中的1张卡舍弃]，选择你的弃牌区中的1张宝石卡，加入手牌。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,cm.cost,cm.con)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	vgf.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_GRAVE,cm.filter1,1,1)
end

function cm.filter1(c)
	return c:IsSetCard(0xc040)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) and OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.CardsFromTo(REASON_COST,LOCATION_GRAVE,LOCATION_HAND,nil,1,1)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RSummonCondition(e)
end