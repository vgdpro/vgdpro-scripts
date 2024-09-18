local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.op,vgf.DamageCost(1),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffectLabel(tp,FLAG_CONDITION)
	if VgF.GetValueType(ct)~="number" or ct~=10102001 then return false end
	return eg:GetFirst()==c and Duel.GetAttacker()==vgf.GetVMonster(tp) and vgf.RMonsterCondition(e)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=vgf.SelectMatchingCard(HINTMSG_VMONSTER,e,tp,vgf.VMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc:IsAttribute(SKILL_TWICE_TRIGGER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_REMOVE_SKILL)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(SKILL_TWICE_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_ADD_SKILL)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(SKILL_THRICE_TRIGGER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
end