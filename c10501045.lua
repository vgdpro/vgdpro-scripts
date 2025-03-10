-- 壮丽音调 琉蒂娅
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 【自】：这个单位登场到R时，通过【费用】[计数爆发1，将手牌中的2张普通单位卡公开，按希望的顺序放置到牌堆底]，选择你的1张先导者，从牌堆里探寻至多1张与那个单位同名的卡，公开后加入手牌，然后牌堆洗切。
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,cm.cost,vgf.con.RideOnRCircle)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local code=vgf.GetVMonster(tp):GetCode()
	vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DECK,Card.IsCode,1,0,code)(e,tp,eg,ep,ev,re,r,rp)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,2,nil) and vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
    vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=vgf.SelectMatchingCard(HINTMSG_CONFIRM,e,tp,cm.filter,tp,LOCATION_HAND,0,2,2,nil)
	Duel.ConfirmCards(1-tp,g)
	if vgf.Sendto(LOCATION_DECK,g,nil,SEQ_DECKTOP,REASON_COST)==#g then
		Duel.SortDecktop(tp,tp,#g)
		for i=1,#g do
			local dg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end

function cm.filter(c)
	return c:IsType(TYPE_NORMAL+TYPE_UNIT)
end