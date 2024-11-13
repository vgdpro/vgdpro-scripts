--争斗的忍鬼 不动丸
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【自】【R】：这个单位的攻击击中时，通过【费用】[将手牌中的1张卡舍弃]，抽1张卡。
	vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.operation, vgf.DisCardCost(1))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end