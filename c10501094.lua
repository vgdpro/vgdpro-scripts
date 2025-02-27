--梦想之瞳 爱梅莱茵
local cm,m,o=GetID()
function cm.initial_effect(c)
    -- 【永】【R】：你其他的后防者有3张以上的话，这个单位的力量+5000。
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con1)
end
function cm.con1(e)
    local c= e:GetHandler()
    local tp=e:GetHandlerPlayer()
    return vgf.con.IsR(e) and vgf.IsExistingMatchingCard(vgf.filter.IsR,tp,LOCATION_CIRCLE,0,3,c)
end