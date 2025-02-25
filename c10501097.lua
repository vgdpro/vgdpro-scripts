--震空的跃动 玛莉布耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    	-- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）
        -- 【永】【R】：你的回合中，这个单位的力量+10000。
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 10000, cm.con)
end
 function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return vgf.WhiteWings(e) and Duel.GetTurnPlayer()==tp and vgf.RMonsterCondition(e)
end