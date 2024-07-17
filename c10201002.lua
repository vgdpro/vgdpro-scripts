-- 【自】：这个单位被含有「莲南」的单位RIDE时，通过【费用】[灵魂爆发1]，选择你的废弃区中的1张等级1以下的卡，CALL到R上。
-- 【永】【R】：后列的你的后防者有3张以上的话，这个单位获得『支援』的技能。

local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.BeRidedByCard(c,m,cm.filter,cm.operation,VgF.OverlayCost(1))
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_ADD_ATTRIBUTE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(SKILL_SUPPORT)
    e2:SetCondition(cm.condition)
    c:RegisterEffect(e2)

end
function cm.filter(c)
	return c:IsSetCard(0x74)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
		local g=Duel.SelectMatchingCard(tp,vgf.IsLevel,tp,LOCATION_GRAVE,0,1,1,nil,0,1)
		if g:GetCount()>0 then
			vgf.Call(g,0,tp)
		end
	
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return vgf.VMonsterCondition(e) and Duel.IsExistingMatchingCard(vgf.IsSequence,tp,LOCATION_MZONE,0,3,nil,1,2,3)
end


