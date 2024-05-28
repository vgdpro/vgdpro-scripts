--龙族骑士 阿尔瓦利斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】：这个单位登场到R时，通过【费用】[计数爆发1，灵魂爆发1]，选择对手的1张等级2以上的后防者，退场。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,cm.cost,cm.condition)
end
--计数爆发1，灵魂爆发1
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.DamageCostOP(1,e,tp,eg,ep,ev,re,r,rp,0) and vgf.OverlayCostOP(1,e,tp,eg,ep,ev,re,r,rp,0) end
vgf.DamageCostOP(1,e,tp,eg,ep,ev,re,r,rp,1)
vgf.OverlayCostOP(1,e,tp,eg,ep,ev,re,r,rp,1)
end
--选择对手的1张等级2以上的后防者
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not (c:IsSummonType(SUMMON_TYPE_RIDE) or c:IsSummonType(SUMMON_TYPE_SELFRIDE))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LEAVEONFIELD)
			local g=Duel.SelectTarget(tp,cm.fliter,tp,0,LOCATION_MZONE,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
end	
function cm.fliter(c)
	return vgf.RMonsterFilter(c) and c:IsLevelAbove(3)
end