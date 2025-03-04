--斧钺的骑士 拉夫尔克
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.action.AbilityAct(c,m,LOCATION_CIRCLE,cm.operation,cm.cost,vgf.con.IsR)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,cm.filter,tp,LOCATION_CIRCLE,0,1,1,nil)
    vgf.AtkUp(c,g,10000,nil)
end
function cm.filter(c)
    return c:IsLevel(3) and c:IsRearguard()end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsRelateToEffect(e) end
    local rc=vgf.GetMatchingGroup(Card.IsVanguard,tp,LOCATION_CIRCLE,0,nil):GetFirst()
	vgf.Sendto(LOCATION_SOUL,c,rc)
end