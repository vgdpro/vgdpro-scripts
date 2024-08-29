-- 《狂乱吧因果，遵循我的意志》
-- 通过【费用】[灵魂爆发1]施放！
-- 选择你的1张先导者，这个回合中，力量+10000。
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    vgd.SpellActivate(c,m,cm.operation,vgf.OverlayCost(1))
end
function cm.operation()
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,vgf.VMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
    VgF.AtkUp(c,g,10000,nil)
end
