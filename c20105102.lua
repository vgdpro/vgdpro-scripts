local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 被等级3的含有「克里斯提阿诺斯」的单位RIDE时
	vgd.action.AbilityAutoRided(c,m,cm.ridefilter,cm.operation)
	-- 盾护+10000
	vgd.action.AbilityCont(c,m,LOCATION_G_CIRCLE,EFFECT_TYPE_SINGLE,EFFECT_UPDATE_DEFENSE,10000,cm.powercon)
end
function cm.ridefilter(c)
	return c:IsLevel(3) and c:IsSetCard(0x12f)
end
function cm.filter(c,e,tp)
	return c:IsLevelBelow(1) and vgf.IsCanBeCalled(c,e,tp)
end
-- 你可以选择你的弃牌区中的1张等级1以下的卡，CALL到R上
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_CALL,e,tp,cm.filter,tp,LOCATION_DROP,0,0,1,nil,e,tp)
	if g:GetCount()>0 then
		vgf.Sendto(LOCATION_CIRCLE,g,0,tp)
	end
end
-- 你有等级3以上的含有「克里斯提阿诺斯」的先导者的话
function cm.powercon(e)
	local tp=e:GetHandlerPlayer()
	local v=vgf.GetVMonster(tp)
	return v and v:IsLevelAbove(3) and v:IsSetCard(0x12f)
end