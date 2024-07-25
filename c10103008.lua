--白金之狼
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    --【起】【R】：通过【费用】[灵魂爆发2]，这个回合中，这个单位的力量+5000。
    vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.operation,vgf.OverlayCost(2),vgf.RMonsterCondition)
    
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        vgf.AtkUp(c,c,5000,nil)
    end
end
