-- 茜色之小道
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
-- （设置指令在施放后，放置到指令区。）
	vgd.ContinuousSpell(c)

-- 【自】：这张卡被放置到指令区时，对手有等级3以上的先导者的话，抽1张卡。
	vgd.EffectTypeTrigger(c,m,loc,EFFECT_TYPE_SINGLE,EVENT_MOVE,cm.op1,nil,cm.con1)

-- 【自】【指令区】：这张歌曲卡被歌唱时，选择你的1张先导者，这个回合中，☆+1。
	vgd.EffectTypeTrigger(c,m,LOCATION_ORDER,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.DrawCard(1),nil,cm.condition)
	vgd.EffectTypeIgnition(c,m,LOCATION_ORDER,cm.operation,vgf.OverlayFill(1),cm.condition1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.GetMatchingGroup(vgf.FrontFilter,tp,LOCATION_MZONE,0,nil)
	vgf.StarUp(c,g,1,nil)
end

function cm.filter(c)
    return c:IsLevelAbove(3) and vgf.VMonsterFilter(c)
end

function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil)
end