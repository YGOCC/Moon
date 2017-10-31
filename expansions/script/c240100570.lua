--Winged Blademaster Iona
function c240100570.initial_effect(c)
	c:EnableReviveLimit()
	--2 "Blademaster" monsters with the same Level
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c240100570.mfilter,c240100570.xyzcheck,2,2)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xbb2),2,2,c240100570.xyzcheck)
	--Inflicts piercing battle damage if it attacks a Defense Position monster.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--Gains 200 ATK for "Blademaster" monster you control and 100 ATK for each monster it points to.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c240100570.val)
	c:RegisterEffect(e1)
	--Once per turn while this card is on the field with material attached to it, if a "Blademaster" monster this card points to activates its effect, you can Special Summon 1 "Blademaster" monster from your GY to either field in a zone this card does not point to in face-up Defense Position immediately after that effect resolves.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c240100570.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(function(e) local c=e:GetHandler() if c:GetFlagEffect(240100570)==0 then c:RegisterFlagEffect(240100570,RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000,0,1) end end)
	c:RegisterEffect(e3)
	--Attach as many of this card's Link Materials as possible to this card as Xyz Materials immediately after it is Link Summoned.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c240100570.thcon)
	e4:SetOperation(c240100570.thop)
	c:RegisterEffect(e4)
end
function c240100570.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsSetCard(0xbb2) and c:IsLevelAbove(1)
end
function c240100570.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c240100570.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbb2)
end
function c240100570.val(e)
	return Duel.GetMatchingGroupCount(c240100570.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*100+e:GetHandler():GetLinkedGroupCount()*200
end
function c240100570.filter(c,e,tp,zone)
	return c:IsSetCard(0xbb2)
		and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone))
		or (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)))
end
function c240100570.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(240100570)==0 then return end
	c:ResetFlagEffect(240100570)
	local zone=bit.bxor(0x1f,c:GetLinkedZone())
	local g=Duel.GetMatchingGroup(c240100570.filter,tp,LOCATION_GRAVE,0,nil,e,tp,zone)
	local rc=re:GetHandler()
	if c:GetFlagEffect(240100570)~=0 or c:GetOverlayCount()==0 or not re:IsActiveType(TYPE_MONSTER) or not rc:IsSetCard(0xbb2)
		or not c:GetLinkedGroup():IsContains(rc) or g:GetCount()==0
		or not Duel.SelectEffectYesNo(tp,c) then return end
	Duel.Hint(HINT_CARD,0,240100570)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
		local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(240100570,0),aux.Stringid(240100570,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(240100570,0))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(240100570,1))+1
		else return end
		if op==0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
		else
			Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	c:RegisterFlagEffect(240100570,RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000,0,1)
end
function c240100570.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c240100570.thfilter(c,g)
	return g:IsContains(c)
end
function c240100570.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial():Filter(aux.NecroValleyFilter(aux.TRUE),nil)
	if mg:GetCount()>0 then
		Duel.Overlay(c,mg:Select(tp,1,1,nil))
	end
end
