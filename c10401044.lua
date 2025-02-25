local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAct(c,m,LOCATION_CIRCLE,cm.op,vgf.OverlayCost(2),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.GetMatchingGroup(Card.IsLevel,tp,LOCATION_CIRCLE,0,nil,3)
	for tc in vgf.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_ADD_SKILL)
		e1:SetRange(LOCATION_CIRCLE)
		e1:SetValue(SKILL_SUPPORT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_CIRCLE+LOCATION_G_CIRCLE,0,3,nil,3) and vgf.RMonsterCondition(e)
end