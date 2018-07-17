--Mecha Blade: Cosmic Shift
local m=88990012
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),2,2)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88990012,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(cm.xyztg)
    e2:SetOperation(cm.xyzop)
    c:RegisterEffect(e2)
end
function cm.cfilter(c,e)
    return c:IsFaceup() and c:IsSetCard(0xffd)
end
function cm.xyzfilter(c,e,tp)
    return c:IsRankAbove(3) and c:IsRankBelow(5)
end
--and c:IsRankBelow(c,5)
function cm.mfilter1(c,mg,exg)
    return mg:IsExists(cm.mfilter2,1,c,c,exg,tp)
end
function cm.mfilter2(c,mc,exg)
    local g=Group.FromCards(c,mc)
    return exg:IsExists(Card.IsXyzSummonable,1,nil,g) and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
    local exg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
    if chk==0 then return mg:IsExists(cm.mfilter1,1,nil,mg,exg,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local sg1=mg:FilterSelect(tp,cm.mfilter1,1,1,nil,mg,exg,tp)
    local tc1=sg1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local sg2=mg:FilterSelect(tp,cm.mfilter2,1,1,tc1,tc1,exg,tp)
    sg1:Merge(sg2)
    Duel.SetTargetCard(sg1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.filter2(c,e)
    return c:IsRelateToEffect(e) and c:IsFaceup()
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.filter2,nil,e)
    if g:GetCount()<2 then return end
    if Duel.GetLocationCountFromEx(tp,tp,g)<=0 then return end
    local xyzg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,g,e,tp)
    if xyzg:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
        Duel.SpecialSummonStep(xyz,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
        Duel.Overlay(xyz,g)
        Duel.SpecialSummonComplete()
    end
end
