-- 朴实前进 罗谢
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【永】【R】：你的回合中，你的指令区中的你的卡每有1张，这个单位的力量+2000。
	vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.val,cm.con)
end
function cm.val(e)
	local tp=e:GetHandlerPlayer()
	local ct=vgf.GetMatchingGroupCount(nil,tp,LOCATION_ORDER,0,c)
	local val=math.floor(ct)*2000
	return val
end

function cm.con1(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return vgf.RMonsterCondition(e) and Duel.GetTurnPlayer()==tp
end