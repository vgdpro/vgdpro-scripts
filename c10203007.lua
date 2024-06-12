local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_SPSUMMON_SUCCESS,cm.operation,vgf.DamageCost(1),cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RMonsterFilter(c) and eg:IsExists(cm.filter,1,nil,tp)
end
function cm.filter(c,tp)
	return c:IsSummonType(SUMMON_VALUE_REVOLT) and vgf.VMonsterFilter(c) and c:IsControler(tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.AtkUp(c,c,10000)
end