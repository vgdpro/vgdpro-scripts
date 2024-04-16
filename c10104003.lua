--树角兽 卡利斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】：这个单位被「树角兽 拉提斯」RIDE时，将你的牌堆顶的1张卡公开，那张卡是等级2以下的单位卡的话，CALL到R上，不是的话，放置到你的灵魂里。
	vgd.BeRidedByCard(c,m,10104002,cm.operation)
	--【永】【后列的R】：这个单位攻击的战斗中，这个单位的力量+5000。
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con)
    e1:SetValue(5000)
    c:RegisterEffect(e1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=vgf.ReturnCard(g)
	Duel.DisableShuffleCheck()
	if tc:IsType(TYPE_MONSTER) and vgf.IsLevel(tc,0,1,2) then
        vgf.Call(g,0,tp)
	elseif tc:IsCanOverlay() then
		Duel.Overlay(c,g)
	end
end
function cm.con(e)
    return Duel.GetAttacker()==e:GetHandler() and vgf.IsSequence(c,1,2,3)
end