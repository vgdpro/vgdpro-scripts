-- 《电光防壁，紧急展开》
-- 通过【费用】[计数爆发2]施放！
-- 选择你的1张先导者，这次战斗中，力量+30000。
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    vgd.Order(c,m,cm.operation,vgf.DamageCost(2))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,vgf.VMonsterFilter,tp,LOCATION_CIRCLE,0,1,1,nil)
    local e1=vgf.AtkUp(c,g,30000,nil)
    vgf.EffectReset(c,e1,EVENT_BATTLED)
end