--Synchro-Converter Future Summoner
function c249000536.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--summon & set with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c249000536.ntcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c249000536.rmtg)
	e3:SetOperation(c249000536.rmop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,249000536)
	e4:SetCondition(c249000536.condition)
	e4:SetCost(c249000536.cost)
	e4:SetOperation(c249000536.operation)
	c:RegisterEffect(e4)
end
function c249000536.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
end
function c249000536.rgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end

function c249000536.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c249000536.rgfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(92510265,2))
	local g1=Duel.SelectTarget(tp,c249000536.rgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
end
function c249000536.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0 and lc:IsRelateToEffect(e) and lc:IsControler(1-tp)
	and Duel.Remove(lc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1:SetCountLimit(1)
		e1:SetCondition(c249000536.retcon)
		e1:SetOperation(c249000536.retop)
		e1:SetLabel(1)
		e1:SetLabelObject(lc)
		Duel.RegisterEffect(e1,tp)
	end
end
function c249000536.retcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c249000536.retop(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetLabel()
	if t==1 then e:SetLabel(0)
	else Duel.ReturnToField(e:GetLabelObject())	end
end
function c249000536.confilter(c,e)
	return c:IsSetCard(0x1CA) and not c:IsCode(e:GetHandler():GetCode())  and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVEYARD))
end
function c249000536.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000536.confilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e)
end
function c249000536.costfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function c249000536.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000536.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000536.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c249000536.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c249000536.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local lv=e:GetLabelObject():GetLevel()
	local att=e:GetLabelObject():GetAttribute()
	local race=e:GetLabelObject():GetRace()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	ac=Duel.AnnounceCard(tp)
	sc=Duel.CreateToken(tp,ac)
	while not (sc:IsType(TYPE_SYNCHRO) and sc:GetLevel() and  math.abs(lv - sc:GetLevel()) <= 2 and sc:IsRace(race)
	and sc:IsAttribute(att) and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and sc:GetCode()~=e:GetLabelObject():GetCode())
	do
		ac=Duel.AnnounceCard(tp)
		sc=Duel.CreateToken(tp,ac)
		if sc:IsType(TYPE_TRAP) then return end
	end
	if sc then
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
