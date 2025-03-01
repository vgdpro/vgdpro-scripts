local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,nil,cm.condition)
end
-- 从弃牌区登场到R时，有等级3以上的先导者的话
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DROP) and vgf.GetVMonster(tp):IsLevelAbove(3) and c:IsRideOnRCircle()
end
-- 这个回合中，这个单位的力量+10000
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		vgf.AtkUp(c,c,10000)
	end
end