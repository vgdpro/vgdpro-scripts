local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,vgf.OverlayCost(1),cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RMonsterFilter(c) and vgf.CheckPrison(tp)
end 
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not vgf.CheckPrison(tp) then return end
	Duel.Hint(HINT_MESSAGE,tp,HINTMSG_IMPRISON)
	local g=Duel.SelectMatchingCard(tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	vgf.SendtoPrison(g,tp)
end