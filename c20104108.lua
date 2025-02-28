local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.Operation.ThisCard(function (e)
		local tc=e:GetHandler()
		vgf.AtkUp(tc,tc,10000)
	end),nil,cm.condition)
end
-- 从弃牌区登场到R时，有等级3以上的先导者的话
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DROP) and vgf.GetVMonster(tp):IsLevelAbove(3) and c:IsRideOnRCircle()
end