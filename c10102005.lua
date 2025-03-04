local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,nil,vgf.con.RideOnRCircle)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.op.SoulCharge(1)
	Duel.BreakEffect()
	if vgf.filter.FinalRush(tp) and vgf.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,1,nil) and Duel.SelectEffectYesNo(tp,vgf.stringid(VgID,10)) then
        local g=vgf.SelectMatchingCard(HINTMSG_DAMAGE,e,tp,Card.IsFaceup,tp,LOCATION_DAMAGE,0,1,1,nil)
        Duel.ChangePosition(g,POS_FACEDOWN_ATTACK)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			vgf.AtkUp(c,c,15000)
		end
	end
end