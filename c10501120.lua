local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.ContinuousSpell(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_ORDER,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SING,cm.op,nil,cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
	local g=Duel.SelectMatchingCard(tp,vgf.VMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
	vgf.AtkUp(c,g,5000)
	Duel.ChangePosition(c,POS_FACEDOWN_ATTACK)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end