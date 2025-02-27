local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,vgf.cost.SoulBlast(1),cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.filter.IsR(c) and vgf.CheckPrison(tp)
end 
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not vgf.CheckPrison(tp) then return end
	local g=vgf.SelectMatchingCard(HINTMSG_IMPRISON,e,tp,vgf.filter.IsR,tp,0,LOCATION_CIRCLE,1,1,nil)
	vgf.SendtoPrison(g,tp)
end