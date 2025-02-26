--紧张的早晨 珊塔尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【起】【R】【1回合1次】：通过【费用】[计数爆发1]，选择你的1张先导者，这个回合中，力量+5000。
    vgd.AbilityAct(c,m,LOCATION_CIRCLE,cm.op,vgf.cost.CounterBlast(1),vgf.con.IsR,nil,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- 选择你的1张先导者
    local g=vgf.SelectMatchingCard(HINTMSG_VMONSTER,tp,vgf.filter.IsV,tp,LOCATION_CIRCLE,0,1,1,nil)
    vgf.AtkUp(c,g,5000)
end