--天剑的骑士 福特
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    vgd.BeRidedByCard(c,m,10103002,cm.operation,cm.cost)
    vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.operation2,vgf.DamageCost(1),vgf.RMonsterCondition,nil,1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then Duel.IsExistingMatchingCard(vgf.IsLevel,tp,LOCATION_HAND,0,2,nil,3) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,vgf.IsLevel,tp,LOCATION_HAND,0,2,2,nil,3)
    Duel.ConfirmCards(1-tp,g)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=vgf.ReturnCard(g)
    Duel.DisableShuffleCheck()
    if tc:IsType(TYPE_MONSTER) then
        vgf.Call(g,0,tp)
    else
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
    if g then
        vgf.AtkUp(c,g,5000)
    end
end
function cm.filter(c)
    return vgf.IsLevel(c,3) and vgf.RmonsterFilter(c)
end