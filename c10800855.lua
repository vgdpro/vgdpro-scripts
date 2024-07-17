--能量发生器
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.Rule(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_MOVE)
    e1:SetCondition(cm.con1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
    e2:SetRange(LOCATION_EMBLEM)
    e2:SetCountLimit(1)
    e2:SetCondition(cm.con2)
    e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_EMBLEM)
    e3:SetCountLimit(1)
    e3:SetCost(vgf.EnergyCost(7))
    e3:SetOperation(cm.op3)
    c:RegisterEffect(e3)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_EMBLEM) and tp==1 and Duel.GetTurnPlayer()==tp
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local code=10800730
    local selfcode1,selfcode2=c:GetOriginalCode()
    if selfcode2==10800855 then code=code+1 end
    local token1=Duel.CreateToken(tp,code)
    local token2=Duel.CreateToken(tp,code)
    local token3=Duel.CreateToken(tp,code)
    local g=Group.FromCards(token1,token2,token3)
    vgf.Sendto(LOCATION_EMBLEM,g,tp,POS_FACEUP_ATTACK,REASON_EFFECT)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and vgf.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_EMBLEM,0,nil,code)<10
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local code=10800730
    local selfcode1,selfcode2=c:GetOriginalCode()
    if selfcode2==10800855 then code=code+1 end
    if vgf.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_EMBLEM,0,nil,code)>=10 then return end
    local ct=10-vgf.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_EMBLEM,0,nil,code)
    local token1=Duel.CreateToken(tp,code)
    local token2=Duel.CreateToken(tp,code)
    local token3=Duel.CreateToken(tp,code)
    local sg=Group.FromCards(token1,token2,token3)
    local g=vgf.GetCardsFromGroup(sg,ct)
    vgf.Sendto(LOCATION_EMBLEM,g,tp,POS_FACEUP_ATTACK,REASON_EFFECT)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end