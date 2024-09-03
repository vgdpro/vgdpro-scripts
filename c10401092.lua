local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    vgd.SpellActivate(c,m,cm.operation,vgf.OverlayCost(1))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,vgf.VMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
    VgF.AtkUp(c,g,10000,nil)
end