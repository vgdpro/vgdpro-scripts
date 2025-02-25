--能量发生器
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.Rule(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_MOVE)
    e1:SetCondition(cm.con1)
    e1:SetOperation(cm.op)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_CREST)
    e2:SetCountLimit(1)
    e2:SetCondition(cm.con2)
    e2:SetOperation(cm.op)
	c:RegisterEffect(e2)

    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_CREST)
    e3:SetCountLimit(1)
    e3:SetCost(vgf.EnergyCost(7))
    e3:SetOperation(cm.op3)
    c:RegisterEffect(e3)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_CREST) and e:GetHandlerPlayer()==1
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    for i = 1, 3, 1 do
        local token=Duel.CreateToken(tp,20401001)
        vgf.Sendto(LOCATION_CREST,token,tp,POS_FACEUP,REASON_EFFECT)
    end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and vgf.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_CREST,0,nil,20401001)<10
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if vgf.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_CREST,0,nil,20401001)>=10 then return end
    local token=Duel.CreateToken(tp,20401001)
    vgf.Sendto(LOCATION_CREST,token,tp,POS_FACEUP,REASON_EFFECT)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end