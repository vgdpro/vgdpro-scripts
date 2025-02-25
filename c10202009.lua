--恐怖人偶 谢丝汀
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【起】【R】【1回合1次】：你有等级3以上的先导者的话，通过【费用】[计数爆发2]，抽1张卡。
	vgd.AbilityAct(c,m,LOCATION_CIRCLE,cm.operation,vgf.CounterBlast(2),cm.condition,nil,1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RMonsterFilter(e:GetHandler()) and vgf.GetVMonster(tp):IsLevelAbove(3)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end