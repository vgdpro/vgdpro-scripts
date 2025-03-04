-- 真实的闪耀 阿蕾斯缇耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 【自】：这个单位登场到V时，选择你的封锁区中的1张卡，放置到牌堆底，放置了的话，将你的牌堆顶的1张卡正面封锁。
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op1,nil,cm.con1)
	-- 白翼-【起】【V】【1回合1次】：通过【费用】[计数爆发1]，这个回合中，这个单位的☆+1。
	vgd.action.AbilityAct(c,m,LOCATION_CIRCLE,cm.op2,vgf.cost.CounterBlast(1),cm.con2,nil,1)
	-- 黑翼-【永】【V】：这个单位攻击的战斗中，对手不能将触发单位卡从手牌CALL到G上。
	VgD.CannotCallToGCircleWhenAttack(c,m,function (e,re,tp)
		return re:GetHandler():IsType(TYPE_TRIGGER) and re:GetHandler():IsLocation(LOCATION_HAND)
	end,cm.con3)
end

function cm.con1(e)
    local c=e:GetHandler()
	return vgf.con.RideOnVCircle(e)
end

function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_CONFIRM,e,tp,nil,tp,LOCATION_BIND,0,1,1,nil)
	if #g>0 then
		vgf.Sendto(LOCATION_DECK,g,nil,SEQ_DECKTOP,REASON_EFFECT)
		local gtop=Duel.GetDecktopGroup(tp,1)
		vgf.Sendto(LOCATION_BIND,gtop,POS_FACEUP,REASON_EFFECT)
	end
end

function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.con.IsV(e) and vgf.WhiteWings(e)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	VgF.CriticalUp(c,c,1)
end
function cm.con3(e)
	return vgf.con.IsV(e) and vgf.BlackWings(e)
end