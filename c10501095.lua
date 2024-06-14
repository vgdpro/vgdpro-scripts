--分赠的幸福 达纳耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    -- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）
    -- 【自】【R】：这个单位支援时，通过【费用】[灵魂爆发2]，选择你其他的1个单位，等级是奇数的这个单位以外的单位每有1个，这个回合中，那个单位的力量+5000。
    vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.op,VgF.OverlayCost(2),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,tp,nil,tp,LOCATION_MZONE,0,1,1,c)
    local ct=Duel.GetMatchingGroupCount(cm.filter2,tp,LOCATION_MZONE,0,c)
    local atk=5000*ct
    vgf.AtkUp(c,g,atk)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return eg:IsContains(c) and cm.con1(e,tp,eg,ep,ev,re,r,rp) and vgf.RMonsterCondition(e)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    local a=vgf.IsExistingMatchingCard(cm.filter1,tp,LOCATION_REMOVED,0,1,nil)
    local b=vgf.IsExistingMatchingCard(cm.filter2,tp,LOCATION_REMOVED,0,1,nil)
    -- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）
    return not a and b
end
function cm.filter1(c)
    return c:GetLevel()%2==1
end
function cm.filter2(c)
    return c:GetLevel()%2==0
end