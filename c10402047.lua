local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	cm.is_has_continuous = true
	local loc, con = vgf.GetLocCondition(LOCATION_R_CIRCLE,cm.con)
	local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(10402047)
    e1:SetRange(loc)
    e1:SetTargetRange(1, 0)
    e1:SetCondition(con)
    c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return vgf.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_V_CIRCLE,0,1,nil,0x78)
end