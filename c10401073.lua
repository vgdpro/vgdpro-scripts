--蒸汽侦探 乌巴里特
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
--【自】：这个单位登场到R时，选择你其他的1个与这个单位同纵列的单位，这个回合中，力量+2000。你处于“一气呵成之势”状态的话，力量不+2000而是+5000。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.GetColumnGroup(c):FilterSelect(tp,cm.filter,1,1,nil,tp)
	local atk=2000
	if Duel.GetFlagEffectLabel(tp,FLAG_CONDITION)==10102001 then
		atk=5000
	end
	vgf.AtkUp(c,g,atk)
end
function cm.filter(c,tp)
	return c:IsControler(tp) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not (c:IsSummonType(SUMMON_TYPE_SELFRIDE) or c:IsSummonType(SUMMON_TYPE_RIDE))
end
