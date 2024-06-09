--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,vgf.True,cm.con)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation1,nil,cm.con2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RIDE) or c:IsSummonType(SUMMON_TYPE_SELFRIDE)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not cm.con(e,tp,eg,ep,ev,re,r,rp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if vgf.GetAvailableLocation(tp)<=0 then return end
	local g=vgf.SelectMatchingCard(HINTMSG_Call,e,tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.HintSelection(g)
	vgf.Call(g,0,tp,nil,POS_FACEUP_DEFENSE)
end
function cm.filter(c)
	return c:IsLevel(c,0,1) and c:IsType(TYPE_MONSTER)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.AtkUp(c,c,2000)
end