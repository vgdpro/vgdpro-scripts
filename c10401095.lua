local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,cm.val,cm.con,nil,nil,EFFECT_UPDATE_DEFENSE,nil,LOCATION_GRAVE)
end
function cm.val(e)
	local tp=e:GetHandlerPlayer()
	local ct=vgf.GetMatchingGroupCount(Card.IsLevel,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,3)
	local val=math.floor(ct/2)*5000
	return val
end
function cm.con(e)
	local tp=e:GetHandlerPlayer()
	return vgf.GetVMonster(tp):IsCode(10103001)
end