-- 神秘之音 蕾娜塔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【自】：这个单位登场到R时，选择你的弃牌区中的相互同名的至多2张宝石卡，将1张放置到牌堆底，其余的卡放置到灵魂里。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,cm.con)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=vgf.SelectMatchingCard(HINTMSG_CONFIRM,e,tp,cm.filter1,tp,LOCATION_GRAVE,0,0,1,nil)
	if #g1 ~= 0 then
		local cg1=g1:GetFirst()
		local cg1code=cg1:GetCode()
		vgf.Sendto(LOCATION_DECK,cg1,nil,SEQ_DECKBOTTOM,REASON_COST)
		local g2count=vgf.GetMatchingGroupCount(cm.filter2,tp,LOCATION_GRAVE,0,cg1)
		if g2count ~= 0 then
			local g2=vgf.SelectMatchingCard(HINTMSG_CONFIRM,e,tp,cm.filter1,tp,LOCATION_GRAVE,0,0,1,cg1)
			if #g2 ~= 0 then
				local rc=vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
				vgf.Sendto(LOCATION_OVERLAY,g2,rc)
			end
		end
	end
end

function cm.filter1(c)
	return c:IsSetCard(0xc040)
end

function cm.filter2(c,code)
	return c:IsCode(code)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RSummonCondition(e)
end