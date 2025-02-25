--花开的季节 露蒂
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【自】【R】：你的后防者被返回手牌时，这个回合中，这个单位的力量+5000。
    vgd.AbilityAuto(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_TO_HAND, cm.op,nil,cm.con)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,5000,nil)
	end
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return vgf.RMonsterCondition(e) and eg:IsPreviousLocation(LOCATION_MZONE)
end
