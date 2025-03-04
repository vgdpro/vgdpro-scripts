--元气爆发 尤丝缇涅
local cm,m,o=GetID()
function cm.initial_effect(c)
    -- 【自】：你的回合中这张卡被从手牌舍弃时，通过【费用】[灵魂爆发1]，将这张卡CALL到不存在单位的R上。
    vgd.action.AbilityAuto(c,m,LOCATION_DROP,EFFECT_TYPE_SINGLE,EVENT_DISCARD,cm.op,vgf.cost.SoulBlast(1),cm.con)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanBeCalled(e,tp) then
		vgf.Sendto(LOCATION_CIRCLE,c,0,tp,"NoUnit")
	end
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end