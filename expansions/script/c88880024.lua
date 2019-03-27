--CREATION Planetary Disruptor
function c88880024.initial_effect(c)
	--Pendulum Effects
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--(p1) If you control a scale 8 or higher "CREATION" Pendulum monster in the other pendulum scale: this cards scale becomes 1.
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_SINGLE)
	ep1:SetCode(EFFECT_CHANGE_LSCALE)
	ep1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCondition(c88880024.slcon)
	ep1:SetValue(1)
	c:RegisterEffect(ep1)
	local ep2=ep1:Clone()
	ep2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(ep2)
	--(p2) Once a turn, you can add 1 "Rank-Up-Magic" card from your deck to your hand, then, if that card was a "CREATION" card: destory this card and target 1 "CREATION" Xyz monster you control; special summon, 1 "CREATION" Xyz monster whose rank is 1 higher. (Transfer the materials. This Special Summon is treated as an Xyz Summon.)
	local ep3=Effect.CreateEffect(c)
	ep3:SetDescription(aux.Stringid(88880024,1))
	ep3:SetCategory(CATEGORY_TOHAND)
	ep3:SetType(EFFECT_TYPE_IGNITION)
	ep3:SetRange(LOCATION_PZONE)
	ep3:SetTarget(c88880024.thtg)
	ep3:SetOperation(c88880024.thop)
	c:RegisterEffect(ep3)
	--Monster Effects
	--(1) If only your opponent controls a monster(s): you can Special Summon this card from your hand.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c88880024.spcon)
	c:RegisterEffect(e1)
	--(2) When this card is Special summoned by the effect of a "CREATION" card, Pandemonium Summoned with a "CREATION" Pandemonium monster, or Pendulum summoned while you have a "CREATION" Pendulum Monster(s) in the Pendulum Zone: add 2 "CREATION" monsters with different names from your deck to your hand, but they cannot be summoned this turn, then, this cards level becomes 4. 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88880024,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c88880024.specon)
	e2:SetTarget(c88880024.spetg)
	e2:SetOperation(c88880024.speop)
	c:RegisterEffect(e2)
end
--Pendulum Effects
--(p1) If you control a scale 8 or higher "CREATION" Pendulum monster in the other pendulum scale: this cards scale becomes 1.
function c88880024.slfilter(c)
	return c:IsSetCard(0x889) and (c:GetLeftScale(8) or c:GetLeftScale(9) or c:GetLeftScale(10) or c:GetLeftScale(11) or c:GetLeftScale(12) or c:GetLeftScale(13) or c:GetLeftScale(14)) 
end
function c88880024.slcon(e)
	return Duel.IsExistingMatchingCard(c88880024.slfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
--(p2) Once a turn, you can add 1 "Rank-Up-Magic" card from your deck to your hand, then, if that card was a "CREATION" card: destory this card and target 1 "CREATION" Xyz monster you control; special summon, 1 "CREATION" Xyz monster whose rank is 1 higher. (Transfer the materials. This Special Summon is treated as an Xyz Summon.)
function c88880024.thfilter(c)
	return c:IsSetCard(0x95) and c:IsAbleToHand()
end
function c88880024.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880024.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88880024.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88880024.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			local tc=g:GetFirst()
			if tc:IsSetCard(0x889) then
				Duel.BreakEffect()
				if Duel.Destroy(c,REASON_EFFECT)~=0 and  Duel.IsExistingMatchingCard(c88880024.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) then
				 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
					local xg=Duel.SelectMatchingCard(tp,c88880024.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
					local xc=xg:GetFirst()
					if Duel.GetLocationCountFromEx(tp,tp,xc)<=0 or not aux.MustMaterialCheck(xc,tp,EFFECT_MUST_BE_XMATERIAL) or xc:IsFacedown() or xc:IsControler(1-tp) or xc:IsImmuneToEffect(e) then return end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=Duel.SelectMatchingCard(tp,c88880024.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,xc,xc:GetRank()+1,nil,xc:GetCode())
					local sc=sg:GetFirst()
					if sc then
						local mg=xc:GetOverlayGroup()
						if mg:GetCount()~=0 then
							Duel.Overlay(sc,mg)
						end
						sc:SetMaterial(Group.FromCards(xc))
						Duel.Overlay(sc,Group.FromCards(xc))
						Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
						sc:CompleteProcedure()
					end
				end
			end
		end
	end
end
function c88880024.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x889)
		and Duel.IsExistingMatchingCard(c88880024.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1,c:GetRace(),c:GetCode())
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c88880024.filter2(c,e,tp,mc,rk)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and c:IsRank(rk) and (c:IsSetCard(0x889) and mc:IsCanBeXyzMaterial(c,tp)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false))
end
--Monster Effects
--(1) If only your opponent controls a monster(s): you can Special Summon this card from your hand.
function c88880024.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--(2) When this card is Special summoned by the effect of a "CREATION" card, Pandemonium Summoned with a "CREATION" Pandemonium monster, or Pendulum summoned while you have a "CREATION" Pendulum Monster(s) in the Pendulum Zone: add 2 "CREATION" monsters with different names from your deck to your hand, but they cannot be summoned this turn, then, this cards level becomes 4. 
function c88880024.specon(e,tp,eg,ep,ev,re,r,rp,se,sp,st)
	return re:GetHandler():IsSetCard(0x889) or (e:GetHandler():IsSummonType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x889)) or (e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+726) and se and se:GetHandler():IsSetCode(0x889))
end
function c88880024.spefilter(c)
	return c:IsSetCard(0x889) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c88880024.spetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c88880024.spefilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c88880024.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c88880024.spefilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if tg1:GetCount()==2 then
		Duel.SendtoHand(tg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(4)
	c:RegisterEffect(e1)
end