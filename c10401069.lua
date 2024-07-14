--自私雕刻师
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
--	【自】【R】：这个单位的攻击击中时，灵魂填充1。
	vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.op1,nil)
--	【自】【R】：这个单位攻击的战斗结束时，你的灵魂在10张以上的话，通过【费用】[将这个单位放置到灵魂里]，计数回充1
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_BATTLED,
	cm.op2,cm.cost,cm.con2)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e.GetHandler()
	vgf.OverlayFill(1)(e,tp,eg,ep,ev,re,r,rp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local rc=vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
	vgf.Sendto(LOCATION_OVERLAY,c,rc)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.DamageFill(1)(e,tp,eg,ep,ev,re,r,rp)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.GetMatchingGroupCount(nil,tp,LOCATION_OVERLAY,0,nil)>=10
end