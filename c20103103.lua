local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 被「闪击兆级喷气机 雷维利欧」RIDE时
	vgd.action.AbilityAutoRided(c,m,20103002,cm.operation)
	-- 力量+5000
	vgd.action.AbilityCont(c,m,LOCATION_G_CIRCLE,EFFECT_TYPE_SINGLE,EFFECT_UPDATE_ATTACK,5000,cm.powercon)
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
-- 你的回合中，你有等级3以上的含有「阿施笃姆」的先导者的话
function cm.powercon(e)
	local tp=e:GetHandlerPlayer()
	local v=vgf.GetVMonster(tp)
	return Duel.GetTurnPlayer()==tp and v and v:IsLevelAbove(3) and v:IsSetCard(0x12c)
end