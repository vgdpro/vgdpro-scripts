local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.OverlayFill(1),nil,vgf.RSummonCondition)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.op,vgf.OverlayCost(3),vgf.RMonsterCondition,nil,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end