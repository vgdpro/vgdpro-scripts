--午夜课程 凡努
local cm,m,o=GetID()
function cm.initial_effect(c)
    -- 【自】：这个单位登场到R时，通过【费用】[计数爆发2]，查看你的牌堆顶的5张卡，选择至多2张触发单位卡，CALL到不存在单位的R上，然后牌堆洗切。
    vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.cost.CounterBlast(2),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,5)
	local c=e:GetHandler()
    Duel.ConfirmCards(tp,g)
	Duel.DisableShuffleCheck()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
	local sg=g:FilterSelect(tp,cm.filter,0,2,nil,e,tp)
	if #sg>0 then
		vgf.Sendto(LOCATION_CIRCLE,sg,0,tp,"NoMonster")
	end
	Duel.ShuffleDeck(tp)
end

function cm.filter(c,e,tp)
	return not c:IsTrigger(TRIGGER_NONE) and vgf.IsCanBeCalled(c,e,tp)
end