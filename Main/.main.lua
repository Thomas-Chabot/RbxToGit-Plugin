local Parser       = require (script.Parser);
local Scripts      = require (script.Scripts);
local shouldIgnore = require (script.Ignore);
local Communicator = require (script.Communicator);
local Input        = require (script.Input);

local comm         = Communicator.new ("localhost", "2402");
local scripts      = Scripts.new ();

function addScript (name, contents)
	scripts:addScript (name, contents);
end


function saveScripts ()
	scripts:sort ();
	local posted = { };
	
	for _,object in pairs (scripts:toArray ()) do
		if (not posted [object.name]) then
			print ("Saving ", object.name);
			posted [object.name] = true;
			comm:post (object.contents);
		end
	end
end

function doSave ()
	for _,obj in pairs (game:GetDescendants ()) do
		pcall (function ()
			if shouldIgnore (obj) then return end
			
			local contents = Parser:parse (obj);
			if (contents) then
				addScript (obj:GetFullName(), contents);
			end
		end)
	end
	
	saveScripts ();
	print ("All saved!");
end

Input.Event:connect (doSave);