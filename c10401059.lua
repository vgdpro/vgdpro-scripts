local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.op,nil,cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=vgf.DefUp(c,c,2000)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c)
end