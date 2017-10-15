--Girl Of The Skies: Charb
function c33309.initial_effect(c)
--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_TOKEN),1,1)
	c:EnableReviveLimit()

 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33309,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetOperation(c33309.spop1)
	c:RegisterEffect(e2)

local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c33309.sptg)
	e4:SetOperation(c33309.spop)
	c:RegisterEffect(e4)
end

function c33309.spop1(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	local token=Duel.CreateToken(tp,3330)
	  Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP,zone)
	Duel.SpecialSummonComplete()
	end
end


function c33309.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33309.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,3330,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,3330)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.SpecialSummonComplete()
		ft=ft-1
	end
	if ft>0 and Duel.SelectYesNo(tp,aux.Stringid(33309,1)) then
		local token=Duel.CreateToken(tp,3330)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end