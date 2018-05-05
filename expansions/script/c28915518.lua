--Guardian of the Forests,
--Design and code by Kindrindra
local ref=_G['c'..28915518]
function ref.initial_effect(c)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetRange(0xff)
	ge1:SetCountLimit(1,555+EFFECT_COUNT_CODE_DUEL)
	ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	ge1:SetOperation(ref.chk)
	c:RegisterEffect(ge1,tp)
	
	--Fusion Monster
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(ref.fscon)
	e0:SetOperation(ref.fsop)
	c:RegisterEffect(e0)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,28915518)
	e1:SetCondition(ref.sscon1)
	e1:SetTarget(ref.sstg)
	e1:SetOperation(ref.ssop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(ref.sscon2)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,28915519)
	e3:SetCondition(ref.thcon)
	e3:SetTarget(ref.thtg)
	e3:SetOperation(ref.thop)
	c:RegisterEffect(e3)
end
ref.burst=true
function ref.trapmaterial(c)
	return true
end
function ref.monmaterial(c)
	return true
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,555,nil,nil,nil,nil,nil,nil)		
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.Remove(token,POS_FACEUP,REASON_RULE)
end

--Fusion Summon
function ref.ffilter(c,fc)
	return c:IsCanBeFusionMaterial(fc)
end
function ref.fselect(c,mg,sg,tp,fc)
	if sg:IsExists(Card.IsFusionAttribute,1,nil,c:GetFusionAttribute()) then return false end
	sg:AddCard(c)
	local res=false
	if sg:GetCount()==2 then
		res=true
	else
		res=mg:IsExists(ref.fselect,1,sg,mg,sg,tp,fc)
	end
	sg:RemoveCard(c)
	return res
end
function ref.fscon(e,g,gc,chkf)
	if g==nil then return true end
	local c=e:GetHandler()
	local tp=c:GetControler()
	local mg=g:Filter(ref.ffilter,nil,c)
	local sg=Group.CreateGroup()
	if gc then return ref.ffilter(gc,c) and ref.fselect(gc,mg,sg,tp,c) end
	return mg:IsExists(ref.fselect,1,sg,mg,sg,tp,c)
end
function ref.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local mg=eg:Filter(ref.ffilter,nil,c)
	local sg=Group.CreateGroup()
	if gc then sg:AddCard(gc) end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g=mg:FilterSelect(tp,ref.fselect,1,1,sg,mg,sg,tp,c)
		sg:Merge(g)
	until sg:GetCount()==2
	Duel.SetFusionMaterial(sg)
end

--Special Summon
function ref.sscon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA --e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+0x555
end
function ref.sscon2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,28915519,0,0x4011,0,0,3,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,28915519,0,0x4011,0,0,3,RACE_AQUA,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,28915519)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(ref.discon)
	e3:SetCost(ref.discost)
	e3:SetTarget(ref.distg)
	e3:SetOperation(ref.disop)
	token:RegisterEffect(e3)
end
function ref.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function ref.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function ref.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function ref.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

--Draw
function ref.thcfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetControler()==tp
end
function ref.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.thcfilter,1,nil,tp)
end
function ref.thfilter(c)
	return c:IsLevelBelow(4) and c:IsAbleToHand()
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(ref.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,ref.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
