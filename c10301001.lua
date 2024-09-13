local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,vgf.OverlayCost(1),vgf.VMonsterCondition)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_BATTLED,cm.operation1,nil,cm.condition1)
	vgd.GlobalCheckEffect(c,m,EVENT_SPSUMMON_SUCCESS,cm.checkcon)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_SELFRIDE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_RTOHAND,e,tp,cm.filter,tp,LOCATION_MZONE,0,1,2,nil)
	vgf.Sendto(LOCATION_HAND,g,nil,REASON_EFFECT)
end
function cm.filter(c)
	return vgf.RMonsterFilter(c)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0 and vgf.VMonsterCondition(e) and Duel.GetAttacker()==e:GetHandler()
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=bit.bnot(vgf.GetAvailableLocation(tp))
	local ct=bit.ReturnCount(zone)
    zone=bit.bor(zone,0xffffff00)
	if ct>2 then ct=2 end
	local g=vgf.SelectMatchingCard(HINTMSG_CALL,e,tp,vgf.IsCanBeCalled,tp,LOCATION_HAND,0,0,ct,nil,e,tp)
	if g:GetCount()==1 then
		vgf.Sendto(LOCATION_MZONE,g,0,tp)
	elseif g:GetCount()==2 then
		local tc1=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CallZONE)
		local szone=Duel.SelectField(tp,1,LOCATION_MZONE,0,zone)
		if vgf.IsExistingMatchingCard(vgd.CallFilter,tp,LOCATION_MZONE,0,1,nil,tp,szone) then
			local tc=vgf.GetMatchingGroup(vgd.CallFilter,tp,LOCATION_MZONE,0,nil,tp,szone):GetFirst()
			vgf.Sendto(LOCATION_DROP,tc,REASON_COST)
		end
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP_ATTACK,szone)
		if szone&0x11>0 then
			zone=0xf1
		else
			zone=0xee
		end
		local tc2=g:GetNext()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CallZONE)
		szone=Duel.SelectField(tp,1,LOCATION_MZONE,0,zone)
		if vgf.IsExistingMatchingCard(vgd.CallFilter,tp,LOCATION_MZONE,0,1,nil,tp,szone) then
			local tc=vgf.GetMatchingGroup(vgd.CallFilter,tp,LOCATION_MZONE,0,nil,tp,szone):GetFirst()
			vgf.Sendto(LOCATION_DROP,tc,REASON_COST)
		end
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP_ATTACK,szone)
		Duel.SpecialSummonComplete()
	end
end