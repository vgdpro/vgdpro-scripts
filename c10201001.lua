local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,5000,cm.con)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,cm.cost,vgf.VMonsterCondition)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() and vgf.IsExistingMatchingCard(function (tc)
		return tc:GetFlagEffect(FLAG_SUPPORT)>0
	end,tp,LOCATION_MZONE,0,nil) and vgf.RMonsterCondition(e)
end
function cm.filter(c)
	return c:IsAttribute(SKILL_SUPPORT) and vgf.BackFilter(c) and c:IsAttackPos()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
	vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=vgf.SelectMatchingCard(HINTMSG_DISCARD,e,tp,nil,tp,LOCATION_HAND,0,1,1,nil)
	vgf.Sendto(LOCATION_GRAVE,g,REASON_COST)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENCE)
	for tc in vgf.Next(g) do
		tc:RegisterFlagEffect(FLAG_SUPPORT,RESET_EVENT+RESETS_STANDARD,0,1)
		Duel.RaiseEvent(tc,EVENT_CUSTOM+EVENT_SUPPORT,e,0,tp,tp,0)
	end
	if g:GetCount()>=3 then
		vgd.TriggerCountUp(c,1,RESET_PHASE+PHASE_END)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLED)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.op2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_RMONSTER,e,tp,function (tc)
		return vgf.BackFilter(tc) and tc:IsPosition(POS_FACEUP_DEFENCE)
	end,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
end