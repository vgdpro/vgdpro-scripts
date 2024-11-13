--天剑的骑士 福特
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    vgd.BeRidedByCard(c,m,10103002,cm.operation,cm.cost)
    vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.operation2,vgf.DamageCost(1),vgf.RMonsterCondition,nil,1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return vgf.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_HAND,0,2,nil,3) end
    local g=vgf.SelectMatchingCard(HINTMSG_CONFIRM,e,tp,Card.IsLevel,tp,LOCATION_HAND,0,2,2,nil,3)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=vgf.ReturnCard(g)
    Duel.DisableShuffleCheck()
    if vgf.IsCanBeCalled(tc,e,tp) then
        vgf.Sendto(LOCATION_MZONE,g,0,tp)
    else
        vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
    end
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
    if g:GetCount()>0 then
        vgf.AtkUp(c,g,5000)
    end
end
function cm.filter(c)
    return c:IsLevel(3) and vgf.VMonsterFilter(c)
end