--紧张的瞬间 凯缇
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【永】【V/R】：对手的回合中，这个单位的力量-2000。
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, -2000, cm.con)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer() == 1-tp
end
