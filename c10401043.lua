local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.ContinuousSpell(c,vgf.OverlayCost(1))
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_MOVE,cm.operation,nil,cm.condition)
	--黑夜
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(AFFECT_CODE_NIGHT)
    e1:SetRange(LOCATION_ORDER)
    e1:SetTargetRange(1,0)
	e1:SetCondition(cm.con1)
    c:RegisterEffect(e1)
	--深渊黑夜
	local e2=e1:Clone()
    e2:SetCode(AFFECT_CODE_DEEP_NIGHT)
	e2:SetCondition(cm.con2)
    c:RegisterEffect(e2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_ORDER)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,1,nil) and vgf.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ORDER,0,1,nil,0x5040)
		and not vgf.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ORDER,0,2,nil,0x5040)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,1,nil) and vgf.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ORDER,0,2,nil,0x5040)
end
function cm.filter(c)
	return not c:IsSetCard(0x5040) and c:IsType(TYPE_CONTINUOUS)
end