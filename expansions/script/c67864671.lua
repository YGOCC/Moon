--VECTOR Legion HQ Command
--Scripted by Zerry
function c67864671.initial_effect(c)
--Activate
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67864671,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCountLimit(1,67864671)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c67864671.eqtg)
	e2:SetOperation(c67864671.eqop)
	c:RegisterEffect(e2)
end
function c67864671.tgfilter(c,e,tp,chk)
	return (not c:GetEquipGroup() or not c:GetEquipGroup():IsExists(function(cc) return cc:GetOriginalType()&TYPE_UNION~=0 end,1,nil)) and c:IsSetCard(0x2a6)
		and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and c:IsCanBeEffectTarget(e)
		and (chk or Duel.IsExistingMatchingCard(c67864671.cfilter,tp,LOCATION_DECK,0,1,nil,c))
end
function c67864671.cfilter(c,ec)
	return c:IsType(TYPE_UNION) and c:IsSetCard(0x52a6) and c:CheckEquipTarget(ec) and aux.CheckUnionEquip(c,ec) and not c:IsCode(ec:GetCode())
end
function c67864671.eqtg(e,eg,tp,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c67864671.tgfilter(chkc,e,tp,true) end
	local g=Duel.GetMatchingGroup(c67864671.tgfilter,tp,LOCATION_MZONE,0,nil,e,tp,false)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g:GetFirst())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:Select(tp,1,1,nil)
		Duel.SetTargetCard(tc)
	end
end
function c67864671.eqop(e,eg,tp,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,c67864671.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc)
		local ec=sg:GetFirst()
		if ec and aux.CheckUnionEquip(ec,tc) and Duel.Equip(tp,ec,tc) then
			aux.SetUnionState(ec)
		end
	end
end