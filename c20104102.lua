local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 被等级3的含有「扎雷乌萨耶尔」的单位RIDE时
	vgd.action.AbilityAutoRided(c,m,cm.ridefilter,cm.operation)
	-- 盾护+10000
	vgd.action.AbilityCont(c,m,LOCATION_G_CIRCLE,EFFECT_TYPE_SINGLE,EFFECT_UPDATE_DEFENSE,10000,cm.powercon)
end
function cm.ridefilter(c)
	return c:IsLevel(3) and c:IsSetCard(0x12d)
end
function cm.filter(c,e,tp)
	return c:IsLevelBelow(3) and vgf.IsCanBeCalled(c,e,tp)
end
-- 选择你的手牌中的至多1张等级3以下的卡，CALL到R上
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_CALL,e,tp,cm.filter,tp,LOCATION_HAND,0,0,1,nil,e,tp)
	if g:GetCount()>0 and vgf.Sendto(LOCATION_CIRCLE,g,0,tp)>0 then
		-- CALL出场了的话，抽1张卡
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
-- 你有等级3以上的含有「扎雷乌萨耶尔」的先导者的话
function cm.powercon(e)
	local tp=e:GetHandlerPlayer()
	local v=vgf.GetVMonster(tp)
	return v and v:IsLevelAbove(3) and v:IsSetCard(0x12d)
end