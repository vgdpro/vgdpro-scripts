local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RMonsterCondition(e) and vgf.GetVMonster(tp):IsSetCard(0x79)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=vgf.AtkUp(c,c,5000,nil)
        vgf.EffectReset(c,e1,EVENT_BATTLED)
    end
	Duel.BreakEffect()
	if vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectEffectYesNo(tp,vgf.stringid(VgID,10)) then
		vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,1)
		local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
		vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	end
end
function cm.filter(c)
	return vgf.RMonsterFilter(c) and c:IsLevelBelow(2)
end