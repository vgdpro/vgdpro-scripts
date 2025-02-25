--招来万雷者 弗尔格雷斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【自】：这个单位登场到R时，你有含有「道拉珠艾尔德」的先导者的话，通过【费用】[灵魂爆发1]，选择你的弃牌区中的1张卡，放置到灵魂里，这个回合中，这个单位的力量+2000。
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,vgf.OverlayCost(1),cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return vgf.GetVMonster(tp):IsSetCard(0xe8) and vgf.RMonsterFilter(e:GetHandler())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_XMATERIAL,e,tp,nil,tp,LOCATION_DROP,0,1,1,nil)
	if g:GetCount()>0 then
		vgf.Sendto(LOCATION_SOUL,g,vgf.GetVMonster(tp))
	end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,2000,nil)
	end
end
