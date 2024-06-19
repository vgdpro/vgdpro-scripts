--龙族骑士 阿尔瓦利斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】：这个单位登场到R时，通过【费用】[计数爆发1，灵魂爆发1]，选择对手的1张等级2以上的后防者，退场。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,cm.cost,cm.condition)
end
--计数爆发1，灵魂爆发1
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end
--选择对手的1张等级2以上的后防者
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not (c:IsSummonType(SUMMON_TYPE_RIDE) or c:IsSummonType(SUMMON_TYPE_SELFRIDE))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEONFIELD,e,tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	end
end	
function cm.filter(c)
	return vgf.RMonsterFilter(c) and c:IsLevelAbove(3)
end