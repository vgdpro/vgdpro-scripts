--沙尘之凶弹 兰多尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【自】：这个单位被「沙尘之重炮 尤金」RIDE时，抽1张卡，选择你的弃牌区中的至多1张卡，放置到灵魂里。
	vgd.BeRidedByCard(c,m,10401002,cm.operation)
	--【自】【V/R】：这个单位攻击时，对手的后防者在2张以下的话，通过【费用】[计数爆发1]，灵魂填充1，这次战斗中，这个单位的力量+5000。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation1,vgf.DamageCost(1),cm.condition)

end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local g=vgf.SelectMatchingCard(HINTMSG_XMATERIAL,e,tp,nil,tp,LOCATION_DROP,0,0,1,nil)
	if g:GetCount()>0 then
	vgf.Sendto(LOCATION_OVERLAY,g,vgf.GetVMonster(tp))
	end
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.OverlayFill(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=vgf.AtkUp(c,c,5000)
		vgf.EffectReset(c,e1,EVENT_BATTLED)
	end
end
function cm.condition (e,tp,eg,ep,ev,re,r,rp)
	return vgf.GetMatchingGroupCount(vgf.RMonsterFilter,tp,0,LOCATION_MZONE,nil)<=2
end
