local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.CounterBlast(1),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RSummonCondition(e)
		and vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_CIRCLE,0,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,vgf.RMonsterFilter,tp,0,LOCATION_CIRCLE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end
function cm.filter(c)
	return c:GetFlagEffectLabel(FLAG_CONDITION)==201
end