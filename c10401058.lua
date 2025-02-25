local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_MOVE,cm.op,vgf.OverlayCost(1),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=vgf.DefUp(c,c,5000)
	vgf.EffectReset(c,e1,EVENT_BATTLED)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_G_CIRCLE) and c:IsPreviousLocation(LOCATION_MZONE) and re:IsHasCategory(CATEGORY_DEFENDER)
end