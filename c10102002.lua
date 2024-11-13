local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,cm.cost,vgf.VSummonCondition)
    vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,5000,cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return vgf.IsExistingMatchingCard(vgf.RMonsterFilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=vgf.SelectMatchingCard(HINTMSG_XMATERIAL,e,tp,vgf.RMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
	vgf.Sendto(LOCATION_OVERLAY,g,c)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffectLabel(tp,FLAG_CONDITION)==10102001
end