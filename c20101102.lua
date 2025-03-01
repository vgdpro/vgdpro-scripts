local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 被等级3的含有「凯旋龙」的单位RIDE时
	vgd.action.AbilityAutoRided(c,m,cm.ridefilter,cm.operation)
	-- 盾护+10000
	vgd.action.AbilityCont(c,m,LOCATION_G_CIRCLE,EFFECT_TYPE_SINGLE,EFFECT_UPDATE_DEFENSE,10000,cm.powercon)
end
function cm.ridefilter(c)
	return c:IsLevel(3) and c:IsSetCard(0x12a)
end
-- 你可以将这张卡CALL到R上
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and vgf.IsCanBeCalled(c,e,tp)
		and Duel.SelectYesNo(tp,vgf.Stringid(m,0)) and vgf.Sendto(LOCATION_CIRCLE,c,0,tp) == 0 then
		-- 没有CALL出场的话，能量填充3
		vgf.op.EnergyCharge(3)
	end
end
-- 你有等级3以上的含有「凯旋龙」的先导者的话
function cm.powercon(e)
	local tp=e:GetHandlerPlayer()
	local v=vgf.GetVMonster(tp)
	return v and v:IsLevelAbove(3) and v:IsSetCard(0x12a)
end