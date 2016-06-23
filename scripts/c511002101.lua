--フォトン・サテライト
function c511002101.initial_effect(c)
	--lvup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(63223260,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511002101.target)
	e1:SetOperation(c511002101.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(511001225)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)	
	e3:SetOperation(c511002101.op)
	c:RegisterEffect(e3)
end
function c511002101.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x55) and c:IsLevelAbove(1)
end
function c511002101.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511002101.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511002101.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511002101.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c511002101.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c511002101.filterx(c)
	return c:IsType(TYPE_XYZ) and c.xyz_count and c.xyz_count>0
end
function c511002101.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c511002101.filterx,c:GetControler(),LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		local tck=Duel.CreateToken(tp,419)
		if tc:GetFlagEffect(419)==0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetDescription(aux.Stringid(71921856,0))
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_EXTRA)
			e1:SetValue(SUMMON_TYPE_XYZ)
			e1:SetCondition(c511002101.xyzcon)
			e1:SetOperation(c511002101.xyzop)
			e1:SetLabelObject(tck)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(419,RESET_EVENT+EVENT_ADJUST,0,1) 	
		end
		tc=g:GetNext()
	end
end
function c511002101.mfilter(c,rk,xyz)
	return c:IsFaceup() and xyz.xyz_filter(c) and c:IsCanBeXyzMaterial(xyz) and c:IsXyzLevel(xyz,rk)
end
function c511002101.amfilter(c)
	return c:GetEquipGroup():IsExists(Card.IsHasEffect,1,nil,511001175)
end
function c511002101.subfilter(c,rk,xyz,tck)
	return c:IsFaceup() and c.xyzsub and c.xyzsub==rk and not c:IsStatus(STATUS_DISABLED) 
		and xyz.xyz_filter(tck)
end
function c511002101.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local rk=c:GetRank()
	local ct=c.xyz_count
	local mg=Duel.GetMatchingGroup(c511002101.mfilter,tp,LOCATION_MZONE,0,nil,rk,c)
	local tck=e:GetLabelObject()
	local mg2=Duel.GetMatchingGroup(c511002101.subfilter,tp,LOCATION_ONFIELD,0,nil,rk,c,tck)
	mg:Merge(mg2)
	if not mg:IsExists(c511002101.amfilter,1,nil) and not mg:IsExists(Card.IsHasEffect,1,nil,511001225)
		and not mg:IsExists(c511002101.subfilter,1,nil,rk,c,tck) then return false end
	local g=mg:Filter(c511002101.amfilter,nil)
	local eqg=Group.CreateGroup()
	local tce=g:GetFirst()
	while tce do
		local eq=tce:GetEquipGroup()
		eq=eq:Filter(Card.IsHasEffect,nil,511001175)
		g:Merge(eq)
		tce=g:GetNext()
	end
	local dob=mg:Filter(Card.IsHasEffect,nil,511001225)
	local dobc=dob:GetFirst()
	while dobc do
		ct=ct-1
		dobc=dob:GetNext()
	end
	mg:Merge(g)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and mg:GetCount()>=ct
end
function c511002101.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local c=e:GetHandler()
	local rk=c:GetRank()
	local ct=c.xyz_count
	local mg=Duel.GetMatchingGroup(c511002101.mfilter,tp,LOCATION_MZONE,0,nil,rk,c)
	local tck=e:GetLabelObject()
	local mg2=Duel.GetMatchingGroup(c511002101.subfilter,tp,LOCATION_ONFIELD,0,nil,rk,c,tck)
	mg:Merge(mg2)
	local g1=Group.CreateGroup()
	g1:KeepAlive()
	local eqg=Group.CreateGroup()
	eqg:KeepAlive()
	while ct>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:Select(tp,1,1,nil)
		if g2:GetFirst() and c511002101.amfilter(g2:GetFirst()) then
			eq=g2:GetFirst():GetEquipGroup()
			eq=eq:Filter(Card.IsHasEffect,nil,511001175)
			mg:Merge(eq)
		elseif g2:GetFirst() and g2:GetFirst():GetEquipTarget()~=nil then
			eqg:Merge(g2)
		end
		if g2:GetFirst() and g2:GetFirst():IsHasEffect(511001225) and ct>0 and (mg:GetCount()<=1 or Duel.SelectYesNo(tp,aux.Stringid(61965407,0))) then
			ct=ct-1
		end
		mg:Sub(g2)
		g1:Merge(g2)
		ct=ct-1
	end
	local sg=Group.CreateGroup()
	local tc=g1:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
		tc=g1:GetNext()
	end
	sg:Merge(eqg)
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end
