local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_SPSUMMON_SUCCESS,cm.operation,vgf.cost.CounterBlast(1),cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.filter.IsR(c) and eg:IsExists(cm.filter,1,nil,tp)
end
function cm.filter(c,tp)
	return c:IsSummonType(SUMMON_VALUE_REVOLT) and vgf.filter.IsV(c) and c:IsControler(tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,10000)
	end
end