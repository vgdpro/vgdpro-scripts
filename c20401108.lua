local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 通过【费用】[计数爆发1]施放
	vgd.action.SetOrder(c,vgf.cost.CounterBlast(1))
	-- 你的后防者由于你的等级3以上的含有「阿施笃姆」的单位的能力重置时
	vgd.action.AbilityAuto(c,m,LOCATION_ORDER,EFFECT_TYPE_FIELD,EVENT_CUSTOM+20103001,cm.operation,nil,nil,cm.target)
end
function cm.filter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
-- 建立联系
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetCount()>0 end
	Duel.SetTargetCard(eg)
end
-- 这个回合中，所有的那些重置的单位和你的先导者的力量+5000
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter,nil,e)
	g:AddCard(vgf.GetVMonster(tp))
	vgf.AtkUp(e:GetHandler(),g,5000)
end