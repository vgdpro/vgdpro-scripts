-- 《于无人知晓的黑暗之中》
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.SetOrder(c,vgf.cost.SoulBlast(1))
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_MOVE,cm.operation,nil,cm.condition)
	vgd.DarkNight(c,m)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_OPPO,e,tp,cm.filter,tp,0,LOCATION_CIRCLE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end
function cm.filter(c)
	return vgf.filter.IsR(c) and vgf.filter.Front(c)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_ORDER)
end
