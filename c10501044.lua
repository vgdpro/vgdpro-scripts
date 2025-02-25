-- 放学后迷你演出 卡缇娜
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【自】：这个单位登场到R时，通过【费用】[灵魂爆发1，将手牌中的1张卡舍弃]，选择你的弃牌区中的1张宝石卡，加入手牌。
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DROP,Card.IsSetCard,1,1,0xc040),vgf.CostAnd(vgf.SoulBlast(1),vgf.Discard(1)),vgf.RSummonCondition)
end