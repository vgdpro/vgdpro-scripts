--蒸汽侦探 乌巴里特
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
--【自】：这个单位登场到R时，选择你其他的1个与这个单位同纵列的单位，这个回合中，力量+2000。你处于“一气呵成之势”状态的话，力量不+2000而是+5000。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,cm.con)
end
function cm.op()
	
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RMonsterFilter(e:GetHandler())
end
