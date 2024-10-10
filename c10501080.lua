--爽朗的王子 哈里耶特
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	-- 【永】【R】：你的回合中，你的指令区中有2张以上的卡的话，这个单位的力量+5000。
    vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,5000,cm.con1)
end

function cm.con1(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return vgf.RMonsterCondition(e) and vgf.IsExistingMatchingCard(nil,tp,LOCATION_ORDER,0,2,nil) and Duel.GetTurnPlayer()==tp
end

