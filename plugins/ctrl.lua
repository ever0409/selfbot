local function reload_plugins( )
	plugins = {}
  return load_plugins()
end
function run_bash(command)
    local cmd = io.popen(command)
    local result = cmd:read('*all')
    cmd:close()
    return result
end
local function is_channel_disabled( receiver )
	if not _config.disabled_channels then
		return false
	end

	if _config.disabled_channels[receiver] == nil then
		return false
	end

  return _config.disabled_channels[receiver]
end

local function enable_channel(receiver, to_id)
	if not _config.disabled_channels then
		_config.disabled_channels = {}
	end

	if _config.disabled_channels[receiver] == nil then
		return ' سلف بات روشن است'
	end
	
	_config.disabled_channels[receiver] = false

	save_config()
	return 'سلف بات روشن است:-D'
end

local function disable_channel(receiver, to_id)
	if not _config.disabled_channels then
		_config.disabled_channels = {}
	end
	
	_config.disabled_channels[receiver] = true

	save_config()
	return 'سلف بات خاموش شد:-('
end

local function pre_process(msg)
	local receiver = get_receiver(msg)
	
	-- If sender is sudo then re-enable the channel
	if is_sudo(msg) then
	  if msg.text == "#bot on" or "ربات روشن" then
	    enable_channel(receiver, msg.to.id)
	  end
	end

  if is_channel_disabled(receiver) then
  	msg.text = ""
  end

	return msg
end

local function run(msg, matches)
	if permissions(msg.from.id, msg.to.id, "bot") then
		local receiver = get_receiver(msg)
		-- Enable a channel
		if matches[1] == 'on' or 'روشن' then
			return enable_channel(receiver, msg.to.id)
		end
		-- Disable a channel
		if matches[1] == 'off' or 'خاموش' then
			return disable_channel(receiver, msg.to.id)
		end
	else
		return 
	end
	    if matches[1] == 'up' or 'ابدیت' then
  if not is_sudo(msg) then
    return nil
  end
  local receiver = get_receiver(msg)
 if string.match then
     local command = 'git pull'
   text = run_bash(command)
   local text = text..'ربات ابدیت شد'
    return text
  end
end
	if matches[1] == 'rl' and is_sudo(msg) then
		receiver = get_receiver(msg)
		reload_plugins(true)
		post_msg(receiver, "Reloaded!", ok_cb, false)
		return "تمام پلاگین ها لود شدند"
	else
		return "All Plugins Loaded"
	end
end

return {
	patterns = {
	    "^#bot? (on)$",
	    "^ربات (روشن)$",
	    "^ربات (خاموش)$",
            "^#bot? (off)$",
	    "^#bot? (up)$",
	    "^#bot (rl)$",
	    },
	run = run,
	pre_process = pre_process
}
