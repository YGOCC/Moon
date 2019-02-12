--Multitask Combinatore
--Script by XGlitchy30
function c86433606.initial_effect(c)
	--equip
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(86433606,0))
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,86433606)
	e0:SetCondition(c86433606.eqcon)
	e0:SetTarget(c86433606.eqtg)
	e0:SetOperation(c86433606.eqop)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86433606,1))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,80433606)
	e1:SetCondition(c86433606.thcon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c86433606.thtg)
	e1:SetOperation(c86433606.thop)
	c:RegisterEffect(e1)
end
--filters
function c86433606.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c86433606.eqfilter(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA
end
function c86433606.setcodefilter(c)
	return c:IsFaceup() and c:IsSetCard(0x86f)
end
function c86433606.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c86433606.matchlv(c,tp,total)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c86433606.matchlv2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c,c:GetLevel(),total)
end
function c86433606.matchlv2(c,lv,total)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and c:IsAbleToHand() and c:GetLevel()+lv==total
end
--equip
function c86433606.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c86433606.cfilter,1,nil,tp)
end
function c86433606.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c86433606.eqfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) 
	end
end
function c86433606.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_HAND) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c86433606.eqfilter,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()==tp or tc:IsFacedown() then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c86433606.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetValue(TYPE_UNION)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetCode(EFFECT_CANNOT_ATTACK)
	e2x:SetValue(1)
	c:RegisterEffect(e2x)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_MUST_BE_LMATERIAL)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetLabelObject(c)
	e3:SetCondition(c86433606.eqcheck)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e3)
end
function c86433606.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c86433606.eqcard(c,cc)
	return c==cc
end
function c86433606.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	local eqg=e:GetHandler():GetEquipGroup()
	return eqg:IsExists(c86433606.eqcard,1,nil,e:GetLabelObject())
end
--search
function c86433606.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount()>0 and g:FilterCount(c86433606.setcodefilter,nil)==g:GetCount()
end
function c86433606.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1,g2=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if chk==0 then return Duel.IsExistingMatchingCard(c86433606.rmfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c86433606.rmfilter,tp,0,LOCATION_HAND,1,nil)
		and g1>0 and g2>0
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c86433606.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1,g2=Duel.GetFieldGroup(tp,LOCATION_DECK,0),Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local h1,h2=Duel.GetFieldGroup(tp,LOCATION_HAND,0),Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g1:GetCount()<1 or g2:GetCount()<1 or not h1:IsExists(c86433606.rmfilter,1,nil) or not h2:IsExists(c86433606.rmfilter,1,nil) then return end
	Duel.ConfirmCards(tp,g1)
	Duel.ConfirmCards(1-tp,g2)
	for p=0,1 do
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
		local hr=Duel.SelectMatchingCard(p,c86433606.rmfilter,p,LOCATION_HAND,0,1,1,nil)
		local tc=hr:GetFirst()
		if tc then
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
				local total=Duel.GetOperatedGroup():GetFirst():GetLevel()
				if Duel.IsExistingMatchingCard(c86433606.matchlv,p,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,p,total) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
					local sg1=Duel.SelectMatchingCard(p,aux.NecroValleyFilter(c86433606.matchlv),p,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,p,total)
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
					local sg2=Duel.SelectMatchingCard(p,aux.NecroValleyFilter(c86433606.matchlv2),p,LOCATION_DECK+LOCATION_GRAVE,0,1,1,sg1:GetFirst(),sg1:GetFirst():GetLevel(),total)
					sg1:Merge(sg2)
					if sg1:GetCount()==2 then
						Duel.SendtoHand(sg1,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-p,sg1)
					end
				end
			end
		end
	end
end