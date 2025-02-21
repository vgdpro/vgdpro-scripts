-- 涛声之夕暮
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)

-- （设置指令在施放后，放置到指令区。）
	vgd.ContinuousSpell(c)

-- 【自】：这张卡被放置到指令区时，选择你的1张先导者，这个回合中，力量+5000。
	vgd.EffectTypeTrigger(c,m,loc,EFFECT_TYPE_SINGLE,EVENT_MOVE,cm.op1,nil,cm.con)
	
-- 【自】【指令区】：这张歌曲卡被歌唱时，这个回合中，将当前存在于前列的你所有的单位的力量+5000。
	vgd.EffectTypeTrigger(c,m,LOCATION_ORDER,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SING,cm.op2,nil,cm.con)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,vgf.VMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
	vgf.AtkUp(c,g,5000)
	Duel.ChangePosition(c,POS_FACEDOWN_ATTACK)
end

function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.GetMatchingGroup(vgf.FrontFilter,tp,LOCATION_MZONE,0,nil)
	vgf.AtkUp(c,g,5000,nil)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end


