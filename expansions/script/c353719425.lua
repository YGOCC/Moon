function c353719425.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
    --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c353719425.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c353719425.spcon)
	e2:SetOperation(c353719425.spop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c353719425.reptg)
	e3:SetValue(c353719425.repval)
	e3:SetOperation(c353719425.repop)
	c:RegisterEffect(e3)
	end
	function c353719425.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c353719425.spfilter1(c,tp,fc)
	return c:IsFusionCode(353719424) and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c353719425.spfilter2,1,c,fc)
end
function c353719425.spfilter2(c,fc)
	return c:IsFusionCode(39311) and c:IsCanBeFusionMaterial(fc)
end
function c353719425.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c353719425.spfilter1,1,nil,tp,c)
end
function c353719425.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c353719425.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c353719425.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c353719425.repfilter(c,tp,e)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
	 and c:IsReason(REASON_EFFECT) and c:GetFlagEffect(353719425)==0
end
function c353719425.desfilter(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_ONFIELD) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c353719425.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c353719425.desfilter,tp,0,LOCATION_ONFIELD,1,nil,tp)
		and eg:IsExists(c353719425.repfilter,1,nil,tp,e) and e:GetHandler():GetFlagEffect(1552222)==0 end
	if Duel.SelectYesNo(tp,aux.Stringid(1552222,0)) then
		local g=eg:Filter(c353719425.repfilter,nil,tp,e)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tg=Duel.SelectMatchingCard(tp,c353719425.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
		Duel.HintSelection(tg)
		Duel.SetTargetCard(tg)
		tg:GetFirst():RegisterFlagEffect(353719425,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
		tg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c353719425.repval(e,c)
	return c==e:GetLabelObject()
end
function c353719425.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
	e:GetHandler():RegisterFlagEffect(353719425,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end