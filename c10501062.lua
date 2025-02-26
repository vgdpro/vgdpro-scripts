-- 朴实前进 罗谢
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【永】【R】：你的回合中，你的指令区中的你的卡每有1张，这个单位的力量+2000。
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, cm.val, cm.con)
end
function cm.val(e)
	local tp=e:GetHandlerPlayer()
	local ct=vgf.GetMatchingGroupCount(nil,tp,LOCATION_ORDER,0,nil)
	return ct*2000
end

function cm.con(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return vgf.con.IsR(e) and Duel.GetTurnPlayer()==tp
end