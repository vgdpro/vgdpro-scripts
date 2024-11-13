--梦想之瞳 爱梅莱茵
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【永】【R】：你其他的后防者有3张以上的话，这个单位的力量+5000。
	vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,5000,cm.con1)
end
function cm.con1(e)
    local c= e:GetHandler()
    local tp=e:GetHandlerPlayer()
    return vgf.RMonsterCondition(e) and vgf.IsExistingMatchingCard(vgf.RMonsterFilter,tp,LOCATION_MZONE,0,3,c)
end