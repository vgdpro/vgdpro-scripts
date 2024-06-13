--震空的跃动 玛莉布耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    	-- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）
        -- 【永】【R】：你的回合中，这个单位的力量+10000。
    VgD.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,10000,cm.con)
end
 function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return cm.con1(e,tp,eg,ep,ev,re,r,rp) and Duel.GetTurnPlayer()==tp and vgf.RMonsterCondition(e)
end

function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_REMOVED,0,1,nil)
    local b=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_REMOVED,0,1,nil)
    -- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）
    return not a and b
end
function cm.filter1(c)
    return c:GetLevel()%2==1
end
function cm.filter2(c)
    return c:GetLevel()%2==0
end