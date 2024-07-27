local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.BeRidedByCard(c,m,cm.filter,vgf.SearchCard(LOCATION_HAND,LOCATION_DROP,cm.filter1),vgf.DamageCost(1))
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.operation1,vgf.OverlayCost(1),cm.condition1)
end
function cm.filter(c)
	return c:IsSetCard(0x202)
end
function cm.filter1(c)
	return c:IsLevelAbove(2)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,e:GetHandler()) and Duel.GetAttacker()==e:GetHandler()
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=vgf.AtkUp(c,c,5000,nil)
		vgf.EffectReset(c,e1,EVENT_BATTLED)
	end
end
function cm.cfilter(c,mc)
	return vgf.GetColumnGroup(c):IsContains(mc) and c:IsControler(mc:GetControler()) and c:GetFlagEffect(FLAG_SUPPORT)>0
end