--可靠的最高年级生 阿莉艾斯
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【永】【G】：你的不存在单位的R有3个以上的话，这个单位的盾护+10000。
    vgd.EffectTypeContinuousChangeDefense(c,m,EFFECT_TYPE_SINGLE,10000,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local ct1=bit.ReturnCount(vgf.GetAvailableLocation(tp))
    local ct2=vgf.GetMatchingGroupCount(vgf.RMonsterFilter,tp,LOCATION_MZONE,0,nil)
    return ct1-ct2>=3
end