local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 被等级3的含有「阿施笃姆」的单位RIDE时
	vgd.action.AbilityAutoRided(c,m,cm.ridefilter,cm.operation)
	-- 盾护+10000
	vgd.action.AbilityCont(c,m,LOCATION_G_CIRCLE,EFFECT_TYPE_SINGLE,EFFECT_UPDATE_DEFENSE,10000,cm.powercon)
end
function cm.ridefilter(c)
	return c:IsLevel(3) and c:IsSetCard(0x12c)
end
function cm.thfilter(c)
	return c:IsCode(20401108)
end
-- 从你的牌堆里探寻至多1张「装甲补给车 普列乔沙」，公开后加入手牌
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_ATOHAND,e,tp,cm.thfilter,tp,LOCATION_DECK,0,0,1,nil)
	if g:GetCount()>0 then
		vgf.Sendto(LOCATION_HAND,g,nil,REASON_EFFECT)
	end
end
-- 你有等级3以上的含有「阿施笃姆」的先导者的话
function cm.powercon(e)
	local tp=e:GetHandlerPlayer()
	local v=vgf.GetVMonster(tp)
	return v and v:IsLevelAbove(3) and v:IsSetCard(0x12c)
end