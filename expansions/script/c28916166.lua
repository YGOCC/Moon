--Coded by Kinny~
local ref=_G['c'..28916166]
local id=28916166
function ref.initial_effect(c)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
	if not ref.global_check then
		ref.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(ref.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function ref.RecoverV(c)
	return c:IsSetCard(1856) and c:IsAbleToHand()
end
function ref.SSVMon(c,e,tp)
	return c:IsSetCard(1856) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end

--Check
function ref.checkop(e,tp,eg,ep,ev,re,r,rp)
	if (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) then Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1) end
end

function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and (Duel.IsExistingTarget(ref.RecoverV,tp,LOCATION_GRAVE,0,1,nil) or Duel.IsExistingMatchingCard(ref.SSVMon,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)) end
	if chkc then return ref.RecoverV(chkc) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) end
	local res1=Duel.IsExistingTarget(ref.RecoverV,tp,LOCATION_GRAVE,0,1,nil)
	local res2=Duel.IsExistingMatchingCard(ref.SSVMon,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	local opt=1
	if res2 then
		opt = 2
	end
	if (res1 and res2) then
		opt = Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2))
	end
	e:SetLabel(opt)
	local cat=0
	if (opt==0 or opt==1) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g0 = Duel.SelectTarget(tp,ref.RecoverV,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g0,g0:GetFirst():GetControler(),g0:GetCount(),g0:GetFirst():GetLocation())
		cat=cat+CATEGORY_TOHAND
	end
	if (opt==0 or opt==2) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
		cat=cat+CATEGORY_SPECIAL_SUMMON
	end
	e:SetCategory(cat)
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	if (opt==0 or opt==1) then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
		end
	end
	if (opt==0 or opt==2) then
		local tc=Duel.SelectMatchingCard(tp,ref.SSVMon,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			Duel.RaiseSingleEvent(tc,EVENT_SUMMON_SUCCESS,e,REASON_EFFECT,tp,tc:GetControler(),ev)
		end
	end
end
