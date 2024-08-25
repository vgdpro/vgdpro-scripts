local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,vgf.RSummonCondition)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.op1,cm.cost,vgf.RMonsterCondition)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,3)
	vgf.Sendto(LOCATION_GRAVE,g,REASON_EFFECT)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,AFFECT_CODE_OVERLAY_COST_FREE_WHEN_MIX,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,vgf.Stringid(m,0))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	vgf.Sendto(LOCATION_DROP,e:GetHandler(),REASON_COST)
end