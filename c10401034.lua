local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.CannotBeTarget(c,m,LOCATION_R_CIRCLE)
end