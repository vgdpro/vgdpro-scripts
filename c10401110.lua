local cm,m,o=GetID()
--暗淡游灵
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【自】【R】：这个单位支援时，这个回合中，	这个单位的力量+2000。
	vgd.AbilityAuto(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.operation,nil,cm.con)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	vgf.AtkUp(c,c,2000,nil)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end