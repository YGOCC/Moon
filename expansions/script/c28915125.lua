--Glimmers of Hope
local ref=_G['c'..28915125]
local id=28915125
function ref.initial_effect(c)
	aux.EnableCoronaNeo(c,1,1,aux.TRUE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(ref.acttg)
	e1:SetOperation(ref.actop)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RECOVER)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(2,id)
	e2:SetCondition(ref.drcon)
	e2:SetTarget(ref.drtg)
	e2:SetOperation(ref.drop)
	c:RegisterEffect(e2)
end

function ref.lpfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	if chkc then return chkc:IsControler(1-tp) and ref.lpfilter(chkc) end
	if Duel.IsExistingMatchingCard(ref.lpfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local tc=Duel.SelectTarget(tp,ref.lpfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tc:GetAttack())
	end
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end

--Draw
function ref.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function ref.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function ref.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
