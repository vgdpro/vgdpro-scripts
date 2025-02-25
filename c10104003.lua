--树角兽 卡利斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【自】：这个单位被「树角兽 拉提斯」RIDE时，将你的牌堆顶的1张卡公开，那张卡是等级2以下的单位卡的话，CALL到R上，不是的话，放置到你的灵魂里。
	vgd.BeRidedByCard(c,m,10104002,cm.operation)
	--【永】【后列的R】：这个单位攻击的战斗中，这个单位的力量+5000。
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)

end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=vgf.ReturnCard(g)
	Duel.DisableShuffleCheck()
	if vgf.IsCanBeCalled(tc,e,tp) and tc:IsLevelBelow(2) then
        vgf.Sendto(LOCATION_CIRCLE,g,0,tp)
	else
		vgf.Sendto(LOCATION_SOUL,g,c)
	end
end
function cm.con(e)
    return Duel.GetAttacker()==e:GetHandler() and vgf.IsSequence(c,1,2,3)
end