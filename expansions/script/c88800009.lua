--Divina, Shadow of the Dragonlords
--Delivery
local card=c88800009
local id=88800009
function card.initial_effect(c)
    --Discard from hand, add 1 "Dragonlord".
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,88800019)
    e1:SetCost(card.cost)
    e1:SetTarget(card.target)
    e1:SetOperation(card.operation)
    c:RegisterEffect(e1)
    --Special Summon from GY if a "Dragonlord" card is Tributed.
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id)
    e2:SetCondition(card.spcon)
    e2:SetTarget(card.sptg)
    e2:SetOperation(card.spop)
    c:RegisterEffect(e2)
    --Cannot be Targeted by card effects.
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
    --While Face-Up cannot be tributed for a Tribute Summon (E4) or anything else (E5)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UNRELEASABLE_SUM)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e5)
end
--------------------------------------------------
--Add from deck to hand  (Unbugged   26/01/19)
--------------------------------------------------
function card.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return  e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function card.thfilter(c)
    return c:IsSetCard(0xfb0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(id)
end
function card.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(card.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function card.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,card.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-----------------------------------------
--Special Summon from GY   (Unbugged(?) 6/10/18)
---------------------------------------------------
--Condition Is it your opponent's turn, was a monster sent and if it was, was it this card.
function card.spcon(e,tp,eg,ep,ev,re,r,rp)
    return not eg:IsContains(e:GetHandler()) and eg:IsExists(card.spcfilter,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--Sets the operation to Special Summon for itself and the whole effect.
function card.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--Activates the effect to Special Summon it from the GY.
function card.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
----------------------------------------------------
--Filters
----------------------------------------------------
--Is its a Dracolord Monster...and...something else im not sure of, you can probably delete it? w/e basically saying, is a "Dragonlord" monster you control and something about a sequence, no clue here.
function card.hspfilter(c,ft,tp)
    return c:IsSetCard(0xfb0)
        and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
-- Checking to see who controlled the sent "Dragonlord" Monster, where it was sent from and whether or not it was a "Dragonlord" Monster at all.
function card.spcfilter(c,tp)
    return c:GetPreviousControler()==tp and c:IsSetCard(0xfb0) and c:IsType(TYPE_MONSTER) and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
