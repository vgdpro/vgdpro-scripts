--分赠的幸福 达纳耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）
    -- 【自】【R】：这个单位支援时，通过【费用】[灵魂爆发2]，选择你其他的1个单位，等级是奇数的这个单位以外的单位每有1个，这个回合中，那个单位的力量+5000。
    vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.op,vgf.OverlayCost(2),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,tp,nil,tp,LOCATION_CIRCLE,0,1,1,c)
    local ct=vgf.GetMatchingGroupCount(cm.filter2,tp,LOCATION_CIRCLE,0,c)
    local atk=5000*ct
    vgf.AtkUp(c,g,atk)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return eg:IsContains(c) and vgf.WhiteWing(e) and vgf.RMonsterCondition(e)
end