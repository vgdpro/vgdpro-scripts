-- 风奏口琴 特尔特斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 【自】【R】：这个单位攻击时，通过【费用】[计数爆发1]，这个回合中，这个单位的力量+5000。
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,vgf.cost.CounterBlast(1),vgf.con.IsR)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,5000,nil)
	end
end