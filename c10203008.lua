local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,loc,EFFECT_TYPE_SINGLE,EVENT_MOVE,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_G_CIRCLE) and c:IsPreviousLocation(LOCATION_CIRCLE) and re:IsHasCategory(CATEGORY_DEFENDER) and vgf.GetVMonster(tp):GetOverlayGroup():FilterCount(Card.IsSetCard,nil,0x76)>=1
end
function cm.filter(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=vgf.DefUp(c,c,10000)
	vgf.EffectReset(c,e1,EVENT_BATTLED)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=vgf.DefUp(c,c,10000)
	vgf.EffectReset(c,e1,EVENT_BATTLED)
end