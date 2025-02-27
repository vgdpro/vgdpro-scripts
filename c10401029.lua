--争斗的忍鬼 不动丸
local cm,m,o=GetID()
function cm.initial_effect(c)
	--【自】【R】：这个单位的攻击击中时，通过【费用】[将手牌中的1张卡舍弃]，抽1张卡。
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_HITTING,cm.operation, vgf.cost.Discard(1))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end