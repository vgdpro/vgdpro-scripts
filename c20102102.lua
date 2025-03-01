local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 被等级3的含有「奥赛拉杰斯特」的单位RIDE时
	vgd.action.AbilityAutoRided(c,m,cm.ridefilter,vgf.op.Draw(),nil,cm.condition)
	-- 盾护+10000
	vgd.action.AbilityCont(c,m,LOCATION_G_CIRCLE,EFFECT_TYPE_SINGLE,EFFECT_UPDATE_DEFENSE,10000,cm.powercon)
end
function cm.ridefilter(c)
	return c:IsLevel(3) and c:IsSetCard(0x12b)
end
-- 你的灵魂在4张以上的话
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return vgf.GetSoulGroup(tp):GetCount()>=4
end
-- 你有等级3以上的含有「奥赛拉杰斯特」的先导者的话
function cm.powercon(e)
	local tp=e:GetHandlerPlayer()
	local v=vgf.GetVMonster(tp)
	return v and  v:IsLevelAbove(3) and v:IsSetCard(0x12b)
end