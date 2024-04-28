local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.ContinuousSpell(c)
	vgd.EffectTypeIgnition(c,m,LOCATION_ORDER,cm.operation,vgf.DamageCost(2))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_VMONSTER)
	local g=Duel.SelectMatchingCard(tp,vgf.VMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
	vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_FIELD,5000,nil,cm.tg,g:GetFirst(),nil,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
end
function cm.tg(e,c)
	return vgf.RMonsterFilter(c)
end