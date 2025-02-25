--无尽之苍蓝
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 选择你的1个单位，这个回合中，力量+5000。将这张卡放置到灵魂里。
    vgd.Order(c,m,cm.operation,nil)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	vgf.AtkUp(c,g,5000,nil)
    local rc=vgf.GetVMonster(tp)
	if c:IsRelateToEffect(e) then
        c:CancelToGrave()
        vgf.Sendto(LOCATION_OVERLAY,c,rc)
    end
end
