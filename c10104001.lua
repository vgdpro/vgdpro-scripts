--树角兽王 马格诺利亚
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】【V】：这个单位攻击的战斗结束时，通过【费用】[计数爆发1]，选择你的1张后防者，这个回合中，那个单位可以从后列攻击，力量+5000。这个回合中你进行了人格RIDE的话，不选择1张，而是选择3张。
	vgd.EffectTypeTrigger(c,m,cm,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_DAMAGE_STEP_END,cm.operation,vgf.DamageCost(1),vgf.VMonsterCondition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
    local g=Duel.SelectMatchingCard(tp,vgf.RMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
    if g then
		Duel.Hintselectgion(g)
		--可以从后列攻击
		vgF.AtkUp(c,g,5000,nil)
	end
end
--未写效果
--1.可以从后列攻击
--2.进行了人格ride的话，不是选择1张，而是选择3张