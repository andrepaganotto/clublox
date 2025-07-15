--[[
	This guy binds a 3D Worskpace Instance of any type (Model, Script, Parts, ...) to a class
	In order for this to work the class must have a "TAG" property which value should be the same
	tag name the Instance must be attached to
	So basically what happens is, every Instance that is present in the Workspace that have a tag that
	corresponds to a class with the same tag will be bond to an instance of that class
	
	For example:
	Apple (Workspace Instance)
		Tags: Apple
	
	Apple (Module Script Class)
		Tag: Apple
		
	Whenever a new Apple appears in the workspace it will have a Apple class instance bonded to it which
	can be acessed by the Binder:getObject() method
	
	Another important thing is that the class constructor should receive a single parameter, which will be the
	Instance reference that will be stored on the class instance, this way we will always have access to the Instance
	whenever we have access to the class instance
	
	AND FOR ORGANIZATION PURPOSES
	3D Workspace Instance >>> Must be Called "Instance"
	Class Instance >>> Must be Called "Object" or when using the word "Instance", ALWAYS INCLUDE "Class" beforehand, like "Class Instance"
]]

local CollectionService = game:GetService("CollectionService")

local Binder = {}
Binder.__index = Binder

function Binder.new(tag, class)
	local self = setmetatable({
		class = class,
		tag = tag,
		objects = {},
		bound = false,
		onlyBindDescendantsOf = nil,
		debugMode = false,
	}, Binder)
	self.evInstanceAdded = CollectionService:GetInstanceAddedSignal(self.tag)
	self.evInstanceRemoved = CollectionService:GetInstanceRemovedSignal(self.tag)
	self.instanceAddedConn = nil
	self.instanceRemovedConn = nil

	return self
end

function Binder:__tostring()
	return ("<Binder %q>"):format(self.tag)
end

function Binder:print(...)
	if self.debugMode then
		print(tostring(self), ...)
	end
end

function Binder:warn(...)
	if self.debugMode then
		warn(tostring(self), ...)
	end
end

function Binder:bind()
	assert(not self.bound)
	self.bound = true
	-- Connect
	self.instanceAddedConn = self.evInstanceAdded:Connect(function(...)
		return self:onInstanceAdded(...)
	end)
	self.instanceRemovedConn = self.evInstanceRemoved:Connect(function(...)
		return self:onInstanceRemoved(...)
	end)
	-- Construct
	for _, object in pairs(CollectionService:GetTagged(self.tag)) do
		self:onInstanceAdded(object)
	end
	self:print("Is binding")
end

function Binder:unbind()
	assert(self.bound)
	self.bound = false
	-- Disconnect
	self.instanceAddedConn:Disconnect()
	self.instanceAddedConn = nil
	self.instanceRemovedConn:Disconnect()
	self.instanceRemovedConn = nil
	-- Deconstruct
	for instance, object in pairs(self.objects) do
		object:destroy()
		self.objects[instance] = nil
	end
	self:print("Has unbound")
end

function Binder:getObject(instance)
	return self.objects[instance]
end

function Binder:setObject(instance, object)
	assert(not self.objects[instance])
	self.objects[instance] = object
end

function Binder:shouldBind(instance)
	return not self.onlyBindDescendantsOf or instance:IsDescendantOf(self.onlyBindDescendantsOf)
end

function Binder:onBoundObject(instance, object)
	-- stub
end

function Binder:onUnbindingObject(instance, object)
	-- stub
end

function Binder:onInstanceUnbound(instance)
	-- stub
end

function Binder:newObject(instance)
	return self.class.new(instance)
end

function Binder:onInstanceAdded(instance)
	assert(typeof(instance) == "Instance")
	if not self.bound then
		return
	end
	assert(not self:getObject(instance))
	-- Ignore certain objects
	if not self:shouldBind(instance) then
		self:print(instance:GetFullName(), "Ignored")
		return
	end
	-- Construct
	local object = self:newObject(instance)
	self.objects[instance] = object
	self:print(instance:GetFullName(), "Bound")
	self:onBoundObject(instance, object)
end

function Binder:onInstanceRemoved(instance)
	-- Deconstruct
	local object = self.objects[instance]
	if not object then
		return
	end
	self:onUnbindingObject(instance, object)
	object:destroy()
	object = nil
	self.objects[instance] = nil
	self:print(instance:GetFullName(), "Unbound")
	self:onInstanceUnbound(instance)
end

return Binder
