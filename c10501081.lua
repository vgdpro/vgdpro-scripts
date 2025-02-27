--坚实的步伐 佩可莉
local cm,m,o=GetID()
function cm.initial_effect(c)
    -- 【永】【R】：你的回合中，你有含有「诚意真心」的单位的话，这个单位的力量+2000。
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 2000, cm.con)
end

function cm.con(e)
    local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
    local a=vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_CIRCLE,0,1)
	return vgf.con.IsR(e) and a and Duel.GetTurnPlayer()==tp
end

function cm.filter(c)
    return c:IsSetCard(0xb6)
end