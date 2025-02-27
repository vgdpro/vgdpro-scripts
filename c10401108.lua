local cm,m,o=GetID()
--智虑的贵公子 埃德加尔
function cm.initial_effect(c)
    --【自】【R】：这个单位攻击时，通过【费用】[计数爆发1]，这次战斗中，这个单位的力量+5000。
    vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,vgf.cost.CounterBlast(1),vgf.con.IsR)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local e1=vgf.AtkUp(c,c,5000,EVENT_BATTLED)
    vgf.effect.Reset(c,e1,EVENT_BATTLED)
end