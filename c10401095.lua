local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityCont(c, m, LOCATION_G_CIRCLE, EFFECT_TYPE_SINGLE, cm.val, EFFECT_UPDATE_DEFENSE, cm.con)
end
function cm.val(e)
	local tp=e:GetHandlerPlayer()
	local ct=vgf.GetMatchingGroupCount(Card.IsLevel,tp,LOCATION_CIRCLE+LOCATION_G_CIRCLE,0,nil,3)
	local val=math.floor(ct/2)*5000
	return val
end
function cm.con(e)
	local tp=e:GetHandlerPlayer()
	return vgf.GetVMonster(tp):IsCode(10103001)
end