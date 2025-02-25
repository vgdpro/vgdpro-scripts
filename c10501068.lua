-- 呼啸的歌谣 珐那耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 黑翼（你的封锁区中的卡只有偶数的等级的场合才有效）-【自】：这个单位登场到R时，灵魂填充1，这个回合中，这个单位的获得『支援』的技能。
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	vgf.SoulCharge(1)(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_ADD_SKILL)
		e2:SetRange(LOCATION_CIRCLE)
		e2:SetValue(SKILL_SUPPORT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.DarkWing(e) and vgf.RSummonCondition(e)
end