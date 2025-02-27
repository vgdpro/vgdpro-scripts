local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c, m,nil,nil,EVENT_TO_G_CIRCLE,cm.op,vgf.cost.SoulBlast(1),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,1,nil)
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsRearguard() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_CIRCLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(cm.con1)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		vgf.effect.Reset(c,e1,EVENT_BATTLED)
	elseif tc:IsVanguard() then
		tc:RegisterFlagEffect(FLAG_SENTINEL,RESET_EVENT+RESETS_STANDARD,0,1,m)
	end
end
function cm.con1(e)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc or not bc:IsRelateToBattle() then return false end
	return bc:IsLevelBelow(2)
end