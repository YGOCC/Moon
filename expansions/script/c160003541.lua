function c160003541.initial_effect(c)
	c:EnableReviveLimit()

		--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,160003541)
	e1:SetCondition(c160003541.descon)
	e1:SetCost(c160003541.discost)
	e1:SetTarget(c160003541.destg)
	e1:SetOperation(c160003541.desop)
	c:RegisterEffect(e1)
		--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160003541,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c160003541.damcon)
	e2:SetTarget(c160003541.damtg)
	e2:SetOperation(c160003541.damop)
	c:RegisterEffect(e2)
		--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(160003541,0))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c160003541.op)
	c:RegisterEffect(e5)
if not c160003541.global_check then
		c160003541.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c160003541.chk)
		Duel.RegisterEffect(ge2,0)
		
	end
end
c160003541.evolute=true
c160003541.material1=function(mc) return  (mc:GetLevel()==4 or mc:GetRank()==4) and mc:IsFaceup() end
c160003541.material2=function(mc) return  (mc:GetLevel()==3 or mc:GetRank()==3) and mc:IsFaceup() end
function c160003541.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
		c160003541.stage_o=7
c160003541.stage=c160003541.stage_o
end

function c160003541.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle()  and bc:IsType(TYPE_MONSTER)
end
function c160003541.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	local dam=bc:GetTextAttack()
	if chk==0 then return dam>0 end
	Duel.SetTargetCard(bc)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c160003541.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetTextAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
function c160003541.filter1(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0  and c:IsAbleToRemove()
end
function c160003541.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_SPECIAL+388 and c:GetMaterial():IsExists(c160003541.pmfilter,1,nil)
end
function c160003541.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1088,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1088,4,REASON_COST)
end
function c160003541.pmfilter(c)
	return c:IsType(TYPE_RITUAL)
end
function c160003541.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c160003541.filter1,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c160003541.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160003541.filter1,tp,0,LOCATION_ONFIELD,2,2,nil)
	if g:GetCount()>0 then 
	    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
function c160003541.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:GetCode()~=160003541
end
function c160003541.con(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c160003541.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c160003541.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
end