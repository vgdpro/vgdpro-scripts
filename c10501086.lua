--虚梦少女 汉内洛蕾
local cm,m,o=GetID()
function cm.initial_effect(c)
    -- 【自】【R】：你其他的后防者登场到这个单位的同纵列时，这个回合中，这个单位的力量+2000。
    vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_SPSUMMON_SUCCESS,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return vgf.con.IsR(e) and eg:IsExists(cm.filter,1,nil,tp,c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
        vgf.AtkUp(c,c,2000)
    end
end
function cm.filter(c,tp,mc)
    local g=Card.GetColumnGroup(mc)
    return g:GetCount()>0 and g:IsContains(c)
end