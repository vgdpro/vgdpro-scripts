--
local cm,m,o=GetID()
function cm.initial_effect(c)
    vg.VgMonster(c)
    local e100=Effect.CreateEffect(c)
    e100:SetType(EFFECT_TYPE_IGNITION)
    e100:SetRange(LOCATION_MZONE)
    e100:SetOperation(cm.op)
    c:RegisterEffect(e100)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK)
    e1:SetValue(-100)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
    local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
    for tc in vg.Next(g) do
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_ATTACK)
        e2:SetValue(-500)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
    local def=e:GetHandler():GetAttack()
    Debug.Message(def)
end