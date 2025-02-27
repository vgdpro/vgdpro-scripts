local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAutoRided(c,m,cm.filter,vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DROP,cm.filter1),vgf.cost.CounterBlast(1))
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.operation1,vgf.cost.SoulBlast(1),cm.condition1)
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
		vgf.effect.Reset(c,e1,EVENT_BATTLED)
	end
end
function cm.cfilter(c,mc)
	return c):IsContains(mc:GetColumnGroup() and c:IsControler(mc:GetControler()) and c:GetFlagEffect(FLAG_SUPPORT)>0
end