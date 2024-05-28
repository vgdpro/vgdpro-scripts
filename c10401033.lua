--电光斯巴达
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】：这个单位被「重力的支配者 磁力重压」RIDE时，通过【费用】[将手牌中的1张卡放置到灵魂里]，抽1张卡，灵魂填充1。
	vgd.BeRidedByCard(c,m,10401003,cm.operation,cm.cost)
	--【自】：这个单位登场到R时，通过【费用】[计数爆发1]，灵魂填充2。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation1,VgF.DamageCost(1),cm.condition)

end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_EFFECT)
	VgF.OverlayFillOP(1,e,tp,eg,ep,ev,re,r,rp,1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_HAND,nil)>=1 end
	local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.HintSelection(g)
	Duel.Overlay(rc,g)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not(c:IsSummonType(SUMMON_TYPE_RIDE) or c:IsSummonType(SUMMON_TYPE_SELFRIDE))
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	vgf.OverlayFillOP(2,e,tp,eg,ep,ev,re,r,rp,1)
end