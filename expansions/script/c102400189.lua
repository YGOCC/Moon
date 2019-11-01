--created & coded by Lyris, art
--フェイツ・トワイライトガル
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(cid.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(cid.thcon)
	e4:SetTarget(cid.thtg)
	e4:SetOperation(cid.thop)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(aux.PandSSetCon(c,0))
	e1:SetOperation(cid.ssetop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetOperation(function(e)
		local c=e:GetHandler()
		if c:GetOriginalType()==TYPE_TRAP then
			c:AddMonsterAttribute(TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT)
			c:SetCardData(CARDDATA_TYPE,TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT)
		end
	end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(0)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCode(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	c:RegisterEffect(e3)
end
function cid.ssetop(e,tp,eg,ep,ev,re,r,rp,c)
	c:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
	Duel.SSet(c:GetControler(),c)
end
function cid.filter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0xf7a)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and aux.PandSSetCon(cid.filter,nil,LOCATION_DECK)(nil,e,tp,eg,ep,ev,re,r,rp)
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil) end
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not aux.PandSSetCon(cid.filter,nil,LOCATION_DECK)(nil,e,tp,eg,ep,ev,re,r,rp) then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.PandSSetFilter(cid.filter),tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		tc:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function cid.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct,l=1,0
	if Duel.GetCurrentPhase()==PHASE_STANDBY then ct,l=2,Duel.GetTurnCount() end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,ct,l)
end
function cid.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tid=e:GetHandler():GetFlagEffectLabel(id)
	return tid and tid~=Duel.GetTurnCount()
end
function cid.rfilter(c,e,tp)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x3a) 
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	return c:GetLevel()<=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x1a)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cid.rfilter,tp,0x1a,0,1,1,nil,e,tp)
	local tc=tg:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
