--蒸汽艺术家 皮坦纳
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
--	【起】【R】：通过【费用】[将这个单位放置到灵魂里]，选择你的1个单位，这个回合中，力量+2000。
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.op,cm.cost,vgf.RMonsterCondition)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsRelateToEffect(e) end
	local rc=vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
	vgf.Sendto(LOCATION_OVERLAY,c,rc)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	VgF.AtkUp(c,g,2000,nil)
end