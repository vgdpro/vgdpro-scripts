--圣裁之刻，来临
local cm,m,o=GetID()
function cm.initial_effect(c)
    VgF.VgCard(c)
    vgd.SpellActivate(c,m,cm.operation)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,2,REASON_EFFECT)
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
    if g then
        Duel.HintSelection(g)
        VgF.AtkUp(c,g,5000)
    end
end