--神秘手风琴师
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】：你的RIDE阶段中这张卡被从手牌舍弃时，你可以将这张卡放置到灵魂里。
	vgd.EffectTypeTrigger(c,m,LOCATION_GRAVE,EFFECT_TYPE_SINGLE,EVENT_TO_GRAVE,cm.operation,vgf.True,cm.condition)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and Duel.GetCurrentPhase()==PHASE_STANDBY
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
	Duel.Overlay(rc,c)
end
