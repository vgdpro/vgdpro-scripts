--元气爆发 尤丝缇涅
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    -- 【自】：你的回合中这张卡被从手牌舍弃时，通过【费用】[灵魂爆发1]，将这张卡CALL到不存在单位的R上。
    vgd.EffectTypeTrigger(c,m,LOCATION_GRAVE,EFFECT_TYPE_SINGLE,EVENT_DISCARD,cm.op,VgF.OverlayCost(1),cm.con)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) and vgf.IsCanBeCalled(c,e,tp) then
		vgf.Sendto(LOCATION_MZONE,c,0,tp,"NoMonster")
	end
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end

