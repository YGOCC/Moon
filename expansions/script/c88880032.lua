--CREATION Energy Disruptor
function c88880032.initial_effect(c)
	--(1) When this card is Special summoned by the effect of a "CREATION" card, Pandemonium Summoned with a "CREATION" Pandemonium monster, or Pendulum summoned while you have a "CREATION" Pendulum Monster(s) in the Pendulum Zone: add 1 "CREATION" Spell/Trap card from your deck to your hand, then, this cards level becomes 4.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88880032,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c88880032.specon)
	e1:SetTarget(c88880032.spetg)
	e1:SetOperation(c88880032.speop)
	c:RegisterEffect(e1)
	--(2) Once per turn, you can target this monster and other monsters on the field with the same level as this card; Special Summon, from your Extra Deck, 1 "CREATION" Xyz monster whose Rank is equal to this cards level, using the targeted monsters as material. (This Special Summon is treated as an Xyz Summon.)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c88880032.xyztg)
	e2:SetOperation(c88880032.xyzop)
	c:RegisterEffect(e2)
end
--(1) When this card is Special summoned by the effect of a "CREATION" card, Pandemonium Summoned with a "CREATION" Pandemonium monster, or Pendulum summoned while you have a "CREATION" Pendulum Monster(s) in the Pendulum Zone: add 1 "CREATION" Spell/Trap card from your deck to your hand, then, this cards level becomes 4.
function c88880032.specon(e,tp,eg,ep,ev,re,r,rp,se,sp,st)
	return re:GetHandler():IsSetCard(0x889) or (e:GetHandler():IsSummonType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x889)) or (e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+726) and se and se:GetHandler():IsSetCode(0x889))
end
function c88880032.spefilter(c)
	return c:IsSetCard(0x889) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))and c:IsAbleToHand()
end
function c88880032.spetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880032.spefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88880032.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88880032.spefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(4)
	c:RegisterEffect(e1)
end
--(2) Once per turn, you can target this monster and other monsters on the field with the same level as this card; Special Summon, from your Extra Deck, 1 "CREATION" Xyz monster whose Rank is equal to this cards level, using the targeted monsters as material. (This Special Summon is treated as an Xyz Summon.)
function c88880032.filter1(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c88880032.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
end
function c88880032.spfilter1(c,e,tp,rk)
	return c:IsRank(rk) and c:IsSetCard(0x889) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c88880032.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lv=e:GetHandler():GetLevel()
	e:SetLabel(lv)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c88880032.filter1(chkc,e,tp,lv) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(c88880032.filter1,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.GetMatchingGroup(c88880032.filter1,tp,LOCATION_MZONE,0,e:GetHandler(),e,tp,lv)
	g:AddCard(e:GetHandler())
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:Select(tp,1,#g,nil)
		Duel.SetTargetCard(sg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c88880032.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local rk=e:GetLabel()
	local mg0=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mg=mg0:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCountFromEx(tp)<=0 or #mg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88880032.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rk)
	local sc=g:GetFirst()
	if sc then
		Duel.Overlay(sc,mg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	end
end