--爽朗的王子 哈里耶特
-- 未测试
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	-- 【永】【R】：你的回合中，你的指令区中有2张以上的卡的话，这个单位的力量+5000。
    VgD.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,5000,cm.con1)
end

function cm.con1()
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
    local a = Duel.IsExistingMatchingCard(nil,tp,LOCATION_ORDER,0,2,c)
	return vgf.RMonsterCondition(e) and a and Duel.GetTurnPlayer()==tp
end

