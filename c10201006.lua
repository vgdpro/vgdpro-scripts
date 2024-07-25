local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,loc,EFFECT_TYPE_SINGLE,EVENT_MOVE,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GZONE) and re:GetHandler()==c and vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,2,nil)
end
function cm.filter(c)
	return c:IsLevelBelow(2) and vgf.BackFilter(c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=vgf.DefUp(c,c,10000)
	vgf.EffectReset(c,e1,EVENT_BATTLED)
end