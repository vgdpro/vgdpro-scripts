--树角兽王 马格诺利亚
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【自】【V】：这个单位攻击的战斗结束时，通过【费用】[计数爆发1]，选择你的1张后防者，这个回合中，那个单位可以从后列攻击，力量+5000。这个回合中你进行了人格RIDE的话，不选择1张，而是选择3张。
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_BATTLED,cm.operation,vgf.DamageCost(1),cm.condition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=1
	if c:IsSummonType(SUMMON_TYPE_SELFRIDE) then ct=3 end
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,vgf.RMonsterFilter,tp,LOCATION_CIRCLE,0,1,ct,nil)
    if g then
		Duel.Hintselectgion(g)
		for tc in vgf.Next(g) do
			tc:RegisterFlagEffect(FLAG_ATTACK_AT_REAR,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,vgf.Stringid(VgID,10))
		end
		vgf.AtkUp(c,g,5000,nil)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return vgf.VMonsterCondition(e) and Duel.GetAttacker()==e:GetHandler()
end