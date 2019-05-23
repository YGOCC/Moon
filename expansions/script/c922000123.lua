--Orcadragon's Paradise
local m=922000123
local cm=_G["c"..m]
local id=m
function cm.initial_effect(c)
	--(1) When this card is activated: add 1 "Orcadragon" card from your deck to your hand, then, if that card is a level 4 or lower monster: Special Summon that card.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--(2) If a level 8 or higher "Orcadragon" monster is special summoned to the field: gain LP equal to half that monsters ATK. This effect of "Orcadragon Paradise" can only be activated once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
--(1)
function cm.thfilter(c)
	return c:IsSetCard(0x904) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,sg)
		local tc=sg:GetFirst()
		if tc and tc:IsLevelBelow(4) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--(2)
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	 local c=eg:GetFirst()
	return c:IsOnField() and c:IsSetCard(0x904) and c:IsLevelAbove(8)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	local lp=c:GetBaseAttack()
	Duel.Recover(tp,lp/2,REASON_EFFECT)
end