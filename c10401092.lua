local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.action.Order(c,m,cm.operation,vgf.cost.SoulBlast(1))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,Card.IsV,tp,LOCATION_CIRCLE,0,1,1,nil)
    vgf.AtkUp(c,g,10000,nil)
end