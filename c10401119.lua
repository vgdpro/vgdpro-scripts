local cm,m,o=GetID()
--幽灵追猎
--选择你的1个单位，这次战斗中，力量+5000。选择你的1张没有正在被攻击的后防者，返回手牌
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.QuickSpell(c,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	return vgf.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	vgf.AtkUp(c,g,5000,EVENT_BATTLED)
    local b=vgf.IsExistingMatchingCard(vgf.RMonsterFilter,tp,LOCATION_MZONE,0,1,Duel.GetAttackTarget())
	if b==true then
		local sg=vgf.SelectMatchingCard(vgf.RMonsterFilter,e,tp,nil,tp,LOCATION_MZONE,0,1,1,,Duel.GetAttackTarget())
		vgf.Sendto(LOCATION_HAND,sg,REASON_EFFECT)
	end
end
