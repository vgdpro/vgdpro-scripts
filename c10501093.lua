--可靠的最高年级生 阿莉艾斯
local cm,m,o=GetID()
function cm.initial_effect(c)
    -- 【永】【G】：你的不存在单位的R有3个以上的话，这个单位的盾护+10000。
	vgd.action.AbilityCont(c, m, LOCATION_G_CIRCLE, EFFECT_TYPE_SINGLE, 10000, EFFECT_UPDATE_DEFENSE, cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local ct1=bit.ReturnCount(vgf.GetAvailableLocation(tp))
    local ct2=vgf.GetMatchingGroupCount(Card.IsRearguard,tp,LOCATION_CIRCLE,0,nil)
    return ct1-ct2>=3
end