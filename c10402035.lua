local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityCont(c, m, LOCATION_G_CIRCLE, EFFECT_TYPE_SINGLE, 5000, EFFECT_UPDATE_DEFENSE, cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.GetVMonster(1-tp):IsLevelAbove(3)
end
