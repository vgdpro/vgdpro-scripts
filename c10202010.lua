--招来万雷者 弗尔格雷斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】：这个单位登场到R时，你有含有「道拉珠艾尔德」的先导者的话，通过【费用】[灵魂爆发1]，选择你的弃牌区中的1张卡，放置到灵魂里，这个回合中，这个单位的力量+2000。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,VgF.OverlayCost(1),cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return VgF.GetVMonster(tp):IsSetCard(0xe8) and VgF.RMonsterFilter(e:GetHandler())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_XMATERIAL,e,tp,nil,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(VgF.GetVMonster(tp),g)
	end
	VgF.AtkUp(c,c,2000,nil)
end
