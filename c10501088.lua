--鼓起踏步向前的勇气 贝尔缇优
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【自】【R】：这个单位支援时，这个回合中，这个单位的力量+2000。
    vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.op,nil,cm.con)

end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return vgf.filter.IsR(c) and eg:IsContains(c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
        vgf.AtkUp(c,c,2000)
    end
end