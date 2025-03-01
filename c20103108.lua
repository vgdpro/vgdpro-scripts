local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 通过【费用】[计数爆发1]施放
	vgd.action.SetOrder(c,vgf.cost.CounterBlast(1))
	-- 由于你的等级3以上的含有「阿施笃姆」的单位的能力重置时
	vgd.action.AbilityAuto(c,m,LOCATION_R_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_CUSTOM+20103001,cm.operation)
end
-- 这个回合中，这个单位的力量+10000
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		vgf.AtkUp(c,c,10000)
	end
end