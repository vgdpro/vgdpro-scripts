local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--（闪现指令只能在你能将防卫者CALL出场的时段施放。）
	--选择你的1个单位，这次战斗中，力量+5000。后列的你的后防者有3张以上的话，不+5000，而是+15000。
	vgd.QuickSpell(c,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	local atk=5000
	if Duel.IsExistingMatchingCard(vgf.IsSequence,tp,LOCATION_MZONE,0,3,nil,1,2,3) then atk=15000 end
	if g then
		Duel.HintSelection(g)
		vgf.AtkUp(c,g,atk)
	end
end