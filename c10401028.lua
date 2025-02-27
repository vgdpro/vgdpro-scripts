--龙族骑士 达巴弗
local cm,m,o=GetID()
function cm.initial_effect(c)
--【自】：这个单位登场到R时，通过【费用】[计数爆发2]，灵魂填充1，选择对手的1张后防者，退场。
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,vgf.cost.CounterBlast(2),vgf.con.RideOnRCircle)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.op.SoulCharge(1)(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,vgf.filter.IsR,tp,0,LOCATION_CIRCLE,1,1,nil)
	if g:GetCount()>0 then
		vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	end
end
