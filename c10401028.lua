--龙族骑士 达巴弗
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
--【自】：这个单位登场到R时，通过【费用】[计数爆发2]，灵魂填充1，选择对手的1张后防者，退场。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,VgF.DamageCost(2),cm.condition)
end
--这个单位从手牌登场到R时
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not(c:IsSummonType(SUMMON_TYPE_RIDE) or c:IsSummonType(SUMMON_TYPE_SELFRIDE)) and c:IsPreviousLocation(LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.OverlayFillOp(1,e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LEAVEONFIELD)
			local g=Duel.SelectTarget(tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
			if g then
				Duel.HintSelection(g)
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
end
