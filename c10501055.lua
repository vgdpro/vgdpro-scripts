-- 不移之绯红
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
-- 通过【费用】[计数爆发1]施放！
-- 抽2张卡，选择你的手牌的1张卡，舍弃。将这张卡放置到灵魂里。
    vgd.Order(c,m,cm.operation,vgf.DamageCost(1))
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,2,REASON_EFFECT)
    VgF.CardsFromTo(REASON_EFFECT,LOCATION_DROP,LOCATION_HAND,nil,1,1)(e,tp,eg,ep,ev,re,r,rp)
    local rc=vgf.GetVMonster(tp)
	if c:IsRelateToEffect(e) then
        c:CancelToGrave()
        vgf.Sendto(LOCATION_OVERLAY,c,rc)
    end
end
