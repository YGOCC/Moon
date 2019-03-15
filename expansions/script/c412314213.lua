local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
--created by Jake, coded by Lyris, art from Cardfight!! Vanguard's "Battlefield Storm, Sagramore"
--Dawn Blader - Lion
function cid.initial_effect(c)
	--If this card is discarded by the effect of, or to activate the effect of, a "Dawn Blader" monster: Special Summon this card.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_DISCARD)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetCondition(cid.con)
	e0:SetTarget(cid.sptg)
	e0:SetOperation(cid.spop)
	c:RegisterEffect(e0)
	--This card can be treated as a Level 2 monster when used for a Synchro Summon of a "Dawn Blader" Synchro Monster.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cid.slevel)
	c:RegisterEffect(e2)
	--A Warrior-Type Synchro Monster that used this card as Synchro Material gains the following effect.(below)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsRace(RACE_WARRIOR) end)
	e1:SetOperation(cid.matop)
	c:RegisterEffect(e1)
end
function cid.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return (0x2<<16)+lv
end
function cid.con(e,tp,eg,ep,ev,re,r,rp)
	local rs=r&0xc0
	local res=rs~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x613)
	if rs&REASON_COST==REASON_COST then res=res and re:IsHasType(0x7e0) end
	return res
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function cid.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	--If it would leave the field, you can discard 1 card: Return it to the Extra Deck instead.
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetTarget(cid.reptg)
	e1:SetOperation(function(e) Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT+REASON_REPLACE) end)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function cid.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_MZONE) and c:IsAbleToExtra() and not c:IsReason(REASON_REPLACE)
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		return true
	else return false end
end
