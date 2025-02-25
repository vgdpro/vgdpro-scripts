--天枪的骑士 勒克斯
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    cm.is_has_continuous=true
    vgd.BeRidedByCard(c,m,10103001,cm.operation,cm.cost)
	vgd.AbilityCont(c, m, LOCATION_MZONE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.condition)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_ADD_SKILL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(SKILL_SUPPORT)
    e2:SetCondition(cm.condition)
    c:RegisterEffect(e2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return vgf.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_HAND,0,3,nil,3) end
    local g=vgf.SelectMatchingCard(HINTMSG_CONFIRM,e,tp,Card.IsLevel,tp,LOCATION_HAND,0,3,3,nil,3)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
end
function cm.condition(e,c)
    local tp=e:GetHandlerPlayer()
    return vgf.RMonsterCondition(e) and vgf.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_MZONE+LOCATION_G_CIRCLE,0,3,nil,3) and Duel.GetTurnPlayer()==tp
end