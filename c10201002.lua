local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.BeRidedByCard(c,m,cm.filter,cm.operation,VgF.OverlayCost(1))
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_ADD_ATTRIBUTE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(SKILL_SUPPORT)
    e2:SetCondition(cm.condition)
    c:RegisterEffect(e2)

end
function cm.filter(c)
	return c:IsSetCard(0x74)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_CALL,e,tp,vgf.IsLevel,tp,LOCATION_DROP,0,1,1,nil,0,1)
	vgf.Call(g,0,tp)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return vgf.RMonsterCondition(e) and vgf.IsExistingMatchingCard(vgf.IsSequence,tp,LOCATION_MZONE,0,3,nil,1,2,3)
end


