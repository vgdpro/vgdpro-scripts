--希望龟甲阵
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
    -- 你的单位在3个以上的话，选择你的1个单位，这次战斗中，力量+15000。
	vgd.BlitzOrder(c,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return vgf.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,3,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
    local e1=vgf.AtkUp(c,g,15000,EVENT_BATTLED)
    vgf.EffectReset(c,e1,EVENT_BATTLED)
end