-- 神秘之音 蕾娜塔
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 【自】：这个单位登场到R时，选择你的弃牌区中的相互同名的至多2张宝石卡，将1张放置到牌堆底，其余的卡放置到灵魂里。
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,vgf.con.RideOnRCircle)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=vgf.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DROP,0,nil,0xc040):SelectSubGroup(tp, cm.filter, false, 0, 2)
	local step = 0
	g:ForEach(function (c)
		if step == 0 then
			vgf.Sendto(LOCATION_DECK,c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			step = step + 1
		else
			vgf.Sendto(LOCATION_SOUL,c)
		end
	end)
end

function cm.filter(g)
	return g:GetClassCount(Card.GetCode) <= 1
end