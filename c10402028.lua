local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and vgf.GetVMonster(tp):IsSetCard(0x79)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=vgf.AtkUp(c,c,5000,nil)
        vgf.effect.Reset(c,e1,EVENT_BATTLED)
    end
	Duel.BreakEffect()
	if vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectEffectYesNo(tp,vgf.stringid(VgID,10)) then
		vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,1)
		local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,cm.filter,tp,0,LOCATION_CIRCLE,1,1,nil)
		vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	end
end
function cm.filter(c)
	return c:IsRearguard() and c:IsLevelBelow(2)
end