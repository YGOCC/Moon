--Senpaizuri no Helper
function c30000.initial_effect(c)
end

--ARCHETYPES
--Gemini
Card.Gemini={
	[26120085]=true; [19041767]=true; [91798373]=true; [68366996]=true; [33846209]=true; [18096222]=true; [26254876]=true; [26120084]=true;
	[30105]=true; [30108]=true;

}
function Card.IsGemini(c,fbool)
	if fbool then
		return Card.Gemini[c:GetFusionCode()]
	else
		return Card.Gemini[c:GetCode()]
	end
end

--Mantra
function Card.IsMantra(c,fbool)
	if fbool then
		return c:GetFusionCode()>=30200 and c:GetFusionCode()<30300
	else
		return c:GetCode()>=30200 and c:GetCode()<30300
	end
end

--Zero
function Card.IsZero(c,fbool)
	if fbool then
		return c:GetFusionCode()>=30400 and c:GetFusionCode()<30500
	else
		return c:GetCode()>=30400 and c:GetCode()<30500
	end
end

--Zero HERO
function Card.IsZHERO(c,fbool)
	if fbool then
		return c:GetFusionCode()>=30400 and c:GetFusionCode()<30500 and c:IsSetCard(0x8)
	else
		return c:GetCode()>=30400 and c:GetCode()<30500 and c:IsSetCard(0x8)
	end
end

--UTILITY
-- function Card.SetGBCustom(c,reg)
	-- if reg==nil or reg then
		-- e0=Effect.CreateEffect(c)
		-- e0:SetType(EFFECT_TYPE_FIELD)
		-- e0:SetCode(EFFECT_SPSUMMON_PROC_G)
		-- e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		-- e0:SetRange(LOCATION_PZONE)
		-- e0:SetCountLimit(1,10000000)
		-- e0:SetCondition(Auxiliary.PendCondition())
		-- e0:SetOperation(GBop)
		-- e0:SetValue(SUMMON_TYPE_PENDULUM)
		-- c:RegisterEffect(e0)
		-- e1=Effect.CreateEffect(c)
		-- e1:SetType(EFFECT_TYPE_ACTIVATE)
		-- e1:SetCode(EVENT_FREE_CHAIN)
		-- e1:SetRange(LOCATION_HAND)
		-- c:RegisterEffect(e1)
	-- else
		-- aux.EnablePendulumAttribute(c,true)
	-- end

-- end
-- function GBop()
	-- local f=Auxiliary.PendOperation()
	-- return function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
		-- f(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
		-- local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
		-- if rpz:IsSetCard(0x19) then
			-- local c=sg:GetFirst()
			-- while c do
				-- if c:IsSetCard(0x19) then
					-- c:RegisterFlagEffect(c:GetOriginalCode(),RESET_EVENT+0x47f0000,0,0)
				-- end
				-- c=sg:GetNext()
			-- end
		-- end
	-- end
-- end
