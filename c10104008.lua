--友情的骑士 塞伊拉斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【起】【R】【1回合1次】：通过【费用】[灵魂爆发2]，公开你的牌堆顶的1张卡，那张卡是单位卡的话，CALL到R上，不是的话，加入手牌
	vgd.AbilityAct(c,m,LOCATION_CIRCLE,cm.operation,vgf.cost.SoulBlast(2),vgf.con.IsR,nil,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=vgf.ReturnCard(g)
	Duel.DisableShuffleCheck()
	if vgf.IsCanBeCalled(tc,e,tp) then
        vgf.Sendto(LOCATION_CIRCLE,g,0,tp)
	else
		vgf.Sendto(LOCATION_HAND,g,nil,REASON_EFFECT)
	end
end