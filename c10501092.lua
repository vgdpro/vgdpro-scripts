--任性姑娘 赫尔米娜
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    -- 【自】：这个单位登场到R时，你的R上有其他的〈幽灵〉的话，选择你的1张后防者，这个回合中，力量+5000。
    vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,tp,vgf.RMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
    vgf.AtkUp(c,g,5000)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    return vgf.RSummonCondition(e) and vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,c)
end
function cm.filter(c)
    return c:IsSetCard(0xa013) and vgf.RMonsterFilter(c)
end