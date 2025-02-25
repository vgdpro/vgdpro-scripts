-- 茜色之小道
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- （设置指令在施放后，放置到指令区。）
	vgd.SetOrder(c)

	-- 【自】：这张卡被放置到指令区时，对手有等级3以上的先导者的话，抽1张卡。
	vgd.AbilityAuto(c,m,loc,EFFECT_TYPE_SINGLE,EVENT_MOVE,vgf.Draw,nil,cm.con1)

	-- 【自】【指令区】：这张歌曲卡被歌唱时，选择你的1张先导者，这个回合中，☆+1。
	vgd.AbilityAuto(c,m,LOCATION_ORDER,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SING,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_VMONSTER,e,tp,nil,tp,LOCATION_V_CIRCLE,0,nil)
	vgf.StarUp(c,g,1,nil)
end

function cm.filter(c)
    return c:IsLevelAbove(3) and vgf.VMonsterFilter(c)
end

function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return cm.con(e,tp,eg,ep,ev,re,r,rp) and Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_CIRCLE,1,nil)
end