--救命天使 库拉比耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    vgd.CardToG(c,vgf.DisCardCostg(1))
end
