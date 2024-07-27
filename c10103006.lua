--斧钺的骑士 拉夫尔克
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.operation,cm.cost,vgf.RMonsterCondition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
    vgf.AtkUp(c,g,10000,nil)
end
function cm.filter(c)
    return c:IsLevel(3) and vgf.RMonsterFilter(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return true end
    local rc=vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
	vgf.Sendto(LOCATION_OVERLAY,c,rc)
end