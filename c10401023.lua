local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,vgf.RSummonCondition)
	vgd.AbilityAct(c,m,LOCATION_CIRCLE,cm.op1,vgf.cost.Retire(),vgf.RMonsterCondition)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,3)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,AFFECT_CODE_SOUL_BLAST_FREE_WHEN_ALCHEMAGIC,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,vgf.Stringid(m,0))
end