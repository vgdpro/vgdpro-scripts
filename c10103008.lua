--白金之狼
local cm,m,o=GetID()
function cm.initial_effect(c)
    VgF.VgCard(c)
    --【起】【R】：通过【费用】[灵魂爆发2]，这个回合中，这个单位的力量+5000。
    vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.operation,vgF.OverlayCost(2),RMonsterCondition)
    
end
function cm.operation()
    local c=e:GetHandler()
    VgF.AtkUp(c,c,5000,nil)
end