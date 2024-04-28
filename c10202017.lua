--幽冥之朋友 黎恩
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】：这个单位登场到R时，查看你的牌堆顶的2张卡，选择1张卡，放置到灵魂里，其余的卡放置到牌堆底。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,nil,cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return VgF.RMonsterFilter(e:GetHandler())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.DisableShuffleCheck()
	local sc=g:Select(tp,1,1,nil):GetFirst()
	Duel.Overlay(VgF.GetVMonster(tp),sc)
	local sg=Duel.GetDecktopGroup(tp,1)
	Duel.MoveSequence(sg:GetFirst(),SEQ_DECKBOTTOM)
end