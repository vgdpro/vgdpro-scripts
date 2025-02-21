local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(FLAG_SUPPORT)>0 and vgf.GetVMonster(tp):IsCode(10401003)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	vgf.OverlayFill(1)(e,tp,eg,ep,ev,re,r,rp)
	if vgf.GetVMonster(tp):GetOverlayCount()>=10 and vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,vgf.Stringid(VgID,10)) then
		Duel.BreakEffect()
		vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,1)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end