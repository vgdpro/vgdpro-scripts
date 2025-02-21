local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,nil,vgf.RSummonCondition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.OverlayFill(1)
	Duel.BreakEffect()
	local ct=Duel.GetFlagEffectLabel(tp,FLAG_CONDITION)
	if vgf.GetValueType(ct)=="number" and ct==10102001 and vgf.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,1,nil) and Duel.SelectEffectYesNo(tp,vgf.stringid(VgID,10)) then
        local g=vgf.SelectMatchingCard(HINTMSG_DAMAGE,e,tp,Card.IsFaceup,tp,LOCATION_DAMAGE,0,1,1,nil)
        Duel.ChangePosition(g,POS_FACEDOWN_ATTACK)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			vgf.AtkUp(c,c,15000)
		end
	end
end