--天惠之源龙王 恩宠吐息
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--追加效果——抽1张卡！选择你的1个单位，这个回合中，☆+1！将当前存在于前列的你所有的单位的力量+10000！你的伤害区中的卡的张数在对手的伤害区中的卡的张数以上的话，选择你的伤害区中的1张卡，回复！
	vgf.AddEffectWhenTrigger(c,m,cm.operation)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_TRIGGER)
	local g1=vgf.SelectMatchingCard(HINTMSG_CRITICAL_STRIKE,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	vgf.StarUp(c,g1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
	local g2=vgf.GetMatchingGroup(vgf.IsSequence,tp,LOCATION_MZONE,0,nil,0,4,5)
    vgf.AtkUp(c,g2,10000,nil)
	if vgf.GetMatchingGroupCount(nil,tp,LOCATION_DAMAGE,0,nil)>=vgf.GetMatchingGroupCount(nil,tp,0,LOCATION_DAMAGE,nil) then
        local tc=vgf.SelectMatchingCard(HINTMSG_TODROP,e,tp,nil,tp,LOCATION_DAMAGE,0,1,1,nil):GetFirst()
        if tc then
            vgf.Sendto(LOCATION_DROP,tc,REASON_TRIGGER)
        end
    end
end