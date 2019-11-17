--Generic Token
--霞鳥クラウソラス
function c15077706.initial_effect(c)
c:SetUniqueOnField(1,0,15077706)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15077706,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c15077706.condition)
	e1:SetTarget(c15077706.target)
	e1:SetOperation(c15077706.operation)
	c:RegisterEffect(e1)
end
function c15077706.sfilter(c,e,tp)
    return c:IsSetCard(341) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c15077706.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c15077706.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(c15077706.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c15077706.operation(e,tp,eg,ep,ev,re,r,rp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=Duel.SelectMatchingCard(tp,c15077706.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
        if Duel.GetLocationCountFromEx(tp)>0 then
                Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        end
end

