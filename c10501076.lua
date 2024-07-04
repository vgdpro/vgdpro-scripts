--爽朗的大姐 欧德莉
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	-- 【永】【R】：你的回合中，你的指令区中有卡存在的话，这个单位的力量+5000。
    vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,5000,cm.con)
end

function cm.con(e)
	local c = e:GetHandler()
	local tp = e:GetHandlerPlayer()
    local a = vgf.IsExistingMatchingCard(nil,tp,LOCATION_ORDER,0,1,c)
	return vgf.RMonsterCondition(e) and a and Duel.GetTurnPlayer()==tp
end
