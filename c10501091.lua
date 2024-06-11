--微小的和平 普拉耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    -- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）-【永】【R/G】：这个单位的力量+2000、盾护+5000。
    VgD.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,2000,cm.con1)
    vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,5000,cm.con2,tg,EFFECT_UPDATE_DEFENSE,reset,LOCATION_GZONE)
end

function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    local a = Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_REMOVED,0,1,nil)
    local b = Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_REMOVED,0,1,nil)
    -- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）
    return not a and b and vgf.RMonsterCondition(e)
end

function cm.con2(e,tp,eg,ep,ev,re,r,rp)
    local a = Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_REMOVED,0,1,nil)
    local b = Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_REMOVED,0,1,nil)
    -- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）
    return not a and b 
end

function cm.filter1(c)
    return c:getlevel() % 2 == 1
end

function cm.filter2(c)
    return c:getlevel() % 2 == 0
end