local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.CannotBeTarget(c,vgf.RMonsterCondition)
	vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.op,nil,vgf.RMonsterCondition)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	vgf.DamageFill(1)(e,tp,eg,ep,ev,re,r,rp)
	vgf.OverlayFill(1)(e,tp,eg,ep,ev,re,r,rp)
end