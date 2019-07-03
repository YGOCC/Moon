--created by ZEN, coded by TaxingCorn117
--Blood Arts Commander - Erse
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2318620,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cid.sumcon)
	c:RegisterEffect(e1)
	--cannot disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(cid.imcon)
	c:RegisterEffect(e2)
	--special summon + damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DICE+CATEGORY_DAMAGE)
	e3:SetTarget(cid.tg)
	e3:SetOperation(cid.op)
	c:RegisterEffect(e3)
	if not cid.global_check then
		cid.global_check=true
		cid[0]=0
		cid[1]=0
		cid[2]=0
		cid[3]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(function(e) cid[0]=0 cid[1]=0 cid[2]=0 cid[3]=0 end)
		Duel.RegisterEffect(e2,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_DAMAGE)
		e5:SetOperation(cid.count)
		Duel.RegisterEffect(e5,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_TOSS_DICE_NEGATE)
		e3:SetOperation(cid.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function cid.count(e,tp,eg,ep,ev,re,r,rp)
	cid[ep]=cid[ep]+ev
end
function cid.addcount(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local ci=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if cid[4]~=ci then
		local dc={Duel.GetDiceResult()}
		for _,ct in ipairs(dc) do cid[2+ep]=cid[2+ep]+ct end
		Duel.SetDiceResult(table.unpack(dc))
		cid[4]=ci
	end
end
function cid.sumcon(e,c)
	if c==nil then return true end
	return cid[2+c:GetControler()]>23
end
function cid.imcon(e)
	return cid[e:GetHandlerPlayer()]>=2500
end
function cid.filter(c,e,tp)
	return c:IsSetCard(0x52f) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and not c:IsCode(id)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1)
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and (c:IsControler(tp) or c:IsLocation(LOCATION_REMOVED)) and cid.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cid.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectTarget(tp,cid.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,tg:GetFirst():GetLevel())
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.BreakEffect()
		local lv=tc:GetLevel()
		local d=0
		for i=1,math.ceil(tc:GetLevel()/5) do
			local t={Duel.TossDice(tp,math.min(lv,5))}
			for _,v in ipairs(t) do d=d+v end
			if lv<=5 then break end
			lv=lv-5
		end
		Duel.Damage(1-tp,d*100,REASON_EFFECT)
	end
end
