--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,vgf.True,vgf.con.RideOnVCircle)
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation1,nil,cm.con2)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not cm.con(e,tp,eg,ep,ev,re,r,rp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if vgf.GetAvailableLocation(tp)<=0 then return end
	local g=vgf.SelectMatchingCard(HINTMSG_Call,e,tp,cm.filter,tp,LOCATION_DROP,0,1,1,nil,e,tp)
	vgf.Sendto(LOCATION_CIRCLE,g,0,tp,nil,POS_FACEUP_DEFENSE)
end
function cm.filter(c,e,tp)
	return c:IsLevel(c,0,1) and vgf.IsCanBeCalled(c,e,tp)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,2000)
	end
end