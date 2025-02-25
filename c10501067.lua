--亲卫队长 玛尔伦
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【永】【R/G】：你的R上的〈幽灵〉有3张以上的话，这个单位的力量+2000、盾护+5000。
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 2000, cm.con1)
	vgd.AbilityCont(c, m, LOCATION_G_CIRCLE, EFFECT_TYPE_SINGLE, 5000, EFFECT_UPDATE_DEFENSE, cm.con2)
end

function cm.con1(e)
    return cm.con2(e) and vgf.RMonsterCondition(e)
end

function cm.con2(e)
    local c = e:GetHandler()
    local tp = e:GetHandlerPlayer()
    return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_CIRCLE,0,3)
end

function cm.filter(c)
    return c:IsSetCard(0xa013) and vgf.RMonsterFilter(c)
end
