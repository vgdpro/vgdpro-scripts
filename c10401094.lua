-- 《于无人知晓的黑暗之中》
-- （设置指令在施放后，放置到指令区。）
-- 通过【费用】[灵魂爆发1]施放！
-- 【自】：这张卡被放置到指令区时，选择前列的对手的1张后防者，退场。
-- 【永】【指令区】：你的指令区中没有世界卡以外的设置指令卡的话，根据你的指令区中的卡的张数生效以下全部的效果。
-- ·1张——你的世界卡的内容变为黑夜。
-- ·2张以上——你的世界卡的内容变为深渊黑夜。
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.ContinuousSpell(c,vgf.OverlayCost(1))
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_MOVE,cm.operation,nil,cm.condition)
	--黑夜
	vgd.NightEffect(c)
	--深渊黑夜
	vgd.DeepNightEffect(c)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_OPPO,e,tp,cm.filter1,tp,0,LOCATION_MZONE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end
function cm.filter1(c)
	return vgf.RMonsterFilter(c) and vgf.FrontFilter(c)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,1,nil) and vgf.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ORDER,0,1,nil,0x5040)
		and not vgf.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ORDER,0,2,nil,0x5040)
end
function cm.filter(c)
	return not c:IsSetCard(0x5040) and c:IsType(TYPE_CONTINUOUS)
end
