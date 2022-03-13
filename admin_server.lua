local PS = game:GetService("Players");
lo
local commands = require(script.commands);
local command_prefix = "/";

PS.PlayerAdded:Connect(function (player)
	player.Chatted:Connect(function (message, recipient)
		message = string.lower(message);
		
		local message_split = message:split(" ");
		local message_command = message_split[1]:split("/")[2];
		
		if commands[message_command] then
			local arguments = {};
			
			for i=2, #message_split, 1 do
				table.insert(arguments, message_split[i]);
			end
			
			commands[message_command](player, arguments);
		end
	end)
end)
