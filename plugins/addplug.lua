local function run(msg, matches)
  if is_sudo(msg) then
  local text = matches[1]
  local b = 1
  while b ~= 0 do
    text = text:trim()
    text,b = text:gsub('^!+','')
  end
  local name = matches[2]
  local file = io.open("./plugins/"..name..".lua", "w")
  file:write(text)
  file:flush()
  file:close()
  local hash = 'group:'..msg.to.id  
  local group_lang = redis:hget(hash,'lang')  
  if group_lang then
  return "پلاگین|"..name.."|با موفقیت نصب شد"
else
  return "Plugin|"..name.."|Installed"
end
end 
return {
  description = "a Usefull plugin for sudo !",  
  usage = "A plugins to add Another plugins to the server",
  patterns = {
    "^[!/#]addplug +(.+) (.*)$"
  },
  run = run
}
